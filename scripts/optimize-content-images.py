#!/usr/bin/env python3
"""Optimize raster images under content/ in place.

For every supported image under content/:
  - Apply EXIF orientation (then drop all original metadata)
  - Cap width at MAX_WIDTH (default 1920), keeping aspect ratio (never upscale)
  - Re-encode as progressive JPEG (quality 85, optimize)
  - Write minimal EXIF: Artist (name) + Copyright (company) only — no GPS,
    camera, software, timestamps, or other leftover tags
  - Replace the original file

If the source was not already .jpg/.jpeg, the optimized file is written as
`<stem>.jpg` and the original is removed. Front-matter / markdown that still
points at the old extension must be updated by hand — the script prints those
renames clearly.

Usage:
  python3 scripts/optimize-content-images.py [--dry-run] [--root content] \\
      [--max-width 1920] [--dpi 72] [--author NAME] [--company NAME]
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

try:
    from PIL import Image, ImageOps
except ImportError as exc:  # pragma: no cover - makefile installs Pillow first
    sys.stderr.write(
        "Pillow is required. Run: make optimize-images-deps\n"
        f"({exc})\n"
    )
    sys.exit(2)

# Raster formats we will convert/replace. SVG stays vector; leave it alone.
SUPPORTED_SUFFIXES = {".jpg", ".jpeg", ".png", ".webp", ".tif", ".tiff", ".bmp", ".gif"}
JPEG_SUFFIXES = {".jpg", ".jpeg"}

# Skip junk / OS noise if it ever appears under content/
SKIP_NAMES = {".DS_Store", "Thumbs.db"}

# Web/screen JFIF density. Browsers ignore DPI for layout (pixels win), but we
# still write a real density so the file isn't left at 1dpi / unset.
DEFAULT_DPI = 300

# Credit tags kept after the metadata strip (matches hugo.toml author / site title).
DEFAULT_AUTHOR = "Dominic Capparelli"
DEFAULT_COMPANY = "Cothrom Productions"

# EXIF IFD0 tag numbers (Pillow Image.Exif).
EXIF_ARTIST = 0x013B
EXIF_COPYRIGHT = 0x8298


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument(
        "--root",
        type=Path,
        default=Path("content"),
        help="Directory to scan recursively (default: content)",
    )
    p.add_argument(
        "--max-width",
        type=int,
        default=1920,
        help="Maximum pixel width; height follows aspect ratio (default: 1920)",
    )
    p.add_argument(
        "--quality",
        type=int,
        default=85,
        help="JPEG quality 1–95 (default: 85)",
    )
    p.add_argument(
        "--dpi",
        type=int,
        default=DEFAULT_DPI,
        help=f"JPEG JFIF density (DPI) written into the file (default: {DEFAULT_DPI})",
    )
    p.add_argument(
        "--author",
        default=DEFAULT_AUTHOR,
        help=f"EXIF Artist (name) kept after strip (default: {DEFAULT_AUTHOR!r})",
    )
    p.add_argument(
        "--company",
        default=DEFAULT_COMPANY,
        help=f"EXIF Copyright (company) kept after strip (default: {DEFAULT_COMPANY!r})",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="Report actions without writing or deleting files",
    )
    return p.parse_args()


def build_credit_exif(author: str, company: str) -> bytes:
    """Minimal EXIF payload: Artist + Copyright only (nothing else forwarded)."""
    exif = Image.Exif()
    if author:
        exif[EXIF_ARTIST] = author
    if company:
        exif[EXIF_COPYRIGHT] = company
    return exif.tobytes()


def iter_images(root: Path) -> list[Path]:
    files: list[Path] = []
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        if path.name in SKIP_NAMES:
            continue
        if path.suffix.lower() not in SUPPORTED_SUFFIXES:
            continue
        files.append(path)
    return files


def target_path(src: Path) -> Path:
    if src.suffix.lower() in JPEG_SUFFIXES:
        # Normalise .jpeg → .jpg when replacing, so references stay predictable.
        if src.suffix.lower() == ".jpeg":
            return src.with_suffix(".jpg")
        return src
    return src.with_suffix(".jpg")


def optimize_one(
    src: Path,
    *,
    max_width: int,
    quality: int,
    dpi: int,
    author: str,
    company: str,
    dry_run: bool,
) -> dict:
    before = src.stat().st_size
    with Image.open(src) as im:
        # Honour orientation, then discard the source's EXIF/XMP/etc. entirely —
        # we never forward im.info / original exif bytes into the save.
        im = ImageOps.exif_transpose(im)
        w, h = im.size
        new_w, new_h = w, h
        if w > max_width:
            new_w = max_width
            new_h = max(1, round(h * (max_width / w)))

        dest = target_path(src)
        resized = w != new_w
        renamed = dest != src

        action = {
            "src": str(src),
            "dest": str(dest),
            "from": f"{w}x{h}",
            "to": f"{new_w}x{new_h}",
            "resized": resized,
            "renamed": renamed,
            "bytes_before": before,
            "bytes_after": None,
            "skipped": False,
        }

        if dry_run:
            return action

        # Convert to RGB for JPEG (drop alpha onto white if present).
        # Fresh Image / convert path → no camera GPS, software, or timestamps.
        if im.mode in ("RGBA", "LA") or (im.mode == "P" and "transparency" in im.info):
            rgba = im.convert("RGBA")
            background = Image.new("RGB", rgba.size, (255, 255, 255))
            background.paste(rgba, mask=rgba.split()[-1])
            out = background
        else:
            out = im.convert("RGB")

        if resized:
            out = out.resize((new_w, new_h), Image.Resampling.LANCZOS)

        credit_exif = build_credit_exif(author, company)

        # Write via a sibling temp file, then replace — never leave a half-written original.
        tmp = dest.with_name(dest.name + ".tmp")
        out.save(
            tmp,
            format="JPEG",
            quality=quality,
            optimize=True,
            progressive=True,
            dpi=(dpi, dpi),
            exif=credit_exif,
        )
        tmp.replace(dest)
        if renamed and src.exists():
            src.unlink()

        action["bytes_after"] = dest.stat().st_size
        return action


def main() -> int:
    args = parse_args()
    root = args.root.resolve()
    if not root.is_dir():
        sys.stderr.write(f"Root not found or not a directory: {root}\n")
        return 1
    if args.max_width < 1:
        sys.stderr.write("--max-width must be ≥ 1\n")
        return 1
    if args.dpi < 1:
        sys.stderr.write("--dpi must be ≥ 1\n")
        return 1

    images = iter_images(root)
    if not images:
        print(f"No supported images under {root}")
        return 0

    print(
        f"{'DRY RUN — ' if args.dry_run else ''}"
        f"Scanning {root} ({len(images)} image(s)), "
        f"max-width={args.max_width}, jpeg q={args.quality}, dpi={args.dpi}"
    )
    print(
        f"  Metadata: strip all → keep Artist={args.author!r}, "
        f"Copyright={args.company!r}"
    )

    total_before = 0
    total_after = 0
    renames: list[tuple[str, str]] = []

    for src in images:
        try:
            result = optimize_one(
                src,
                max_width=args.max_width,
                quality=args.quality,
                dpi=args.dpi,
                author=args.author,
                company=args.company,
                dry_run=args.dry_run,
            )
        except Exception as exc:  # keep going; report failures per file
            sys.stderr.write(f"ERROR {src}: {exc}\n")
            continue

        total_before += result["bytes_before"]
        after = result["bytes_after"]
        if after is not None:
            total_after += after

        flag = []
        if result["resized"]:
            flag.append("resize")
        else:
            flag.append("re-encode")
        if result["renamed"]:
            flag.append("rename")
            renames.append((result["src"], result["dest"]))

        size_note = f"{result['bytes_before'] // 1024}k"
        if after is not None:
            size_note += f" → {after // 1024}k"

        print(
            f"  [{', '.join(flag)}] {result['src']}"
            f"  {result['from']} → {result['to']}  ({size_note})"
        )

    if not args.dry_run and total_after:
        saved = max(0, total_before - total_after)
        print(
            f"Done. {total_before // 1024}k → {total_after // 1024}k "
            f"(saved {saved // 1024}k)"
        )
    elif args.dry_run:
        print("Dry run complete — no files written.")

    if renames:
        print("\nRenamed (update any content references from old → new):")
        for old, new in renames:
            print(f"  {old}  →  {new}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
