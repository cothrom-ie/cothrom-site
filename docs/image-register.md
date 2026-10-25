# Image register

Working inventory for unique-first assignment. Source of truth: `images/`.
Hugo publish paths are filled when images are copied/edited into page bundles or `static/`.

**Rule:** Each basename has one published role. Prefer service-folder ownership over gallery twin.

## Locked assignments

| Image | assigned_page | Status |
|-------|----------------|--------|
| `images/gallery/20150203_190036-1.png` | home (hero) | **locked** — see `content/cothrom-home-hero.jpg` |
| `images/prodMan/A01_0550-1.png` | production-management (hero) | **locked** — see `content/production-management/hero.jpg` |
| `images/techDir/IMG_0266.png` | technical-direction (hero) | **locked** — see `content/technical-direction/hero.jpg` |
| `images/creativeTech/IMG_0980.png` | creative-technology (hero) | **locked** — see `content/creative-technology/hero.jpg` |
| `images/sysDesign/152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1.png` | system-design (hero) | **locked** — see `content/system-design/hero.jpg` |
| `images/gallery/100_0154-1.png` | gallery (g01) | **locked** — see `content/gallery/photos/g01.jpg` |
| `images/gallery/PA260002-1.png` | gallery (g02) | **locked** — see `content/gallery/photos/g02.jpg` |
| `images/gallery/IMG_1105.png` | gallery (g03) | **locked** — see `content/gallery/photos/g03.jpg` |
| `images/gallery/first 218-1.png` | gallery (g04) | **locked** — see `content/gallery/photos/g04.jpg` |
| `images/gallery/IMAG0231-1.png` | gallery (g05) | **locked** — see `content/gallery/photos/g05.jpg` |
| `images/gallery/2013-03-17 08.16.30-1.png` | gallery (g06) | **locked** — see `content/gallery/photos/g06.jpg` |
| `images/gallery/IMG_0102-1.png` | gallery (g07) | **locked** — see `content/gallery/photos/g07.jpg` |
| `images/gallery/0201170730-1.png` | gallery (g08) | **locked** — see `content/gallery/photos/g08.jpg` |
| `images/gallery/IMG_0075-1.png` | gallery (g09) | **locked** — see `content/gallery/photos/g09.jpg` |
| `images/gallery/20150713_142432-1.png` | gallery (g10) | **locked** — see `content/gallery/photos/g10.jpg` |
| `images/gallery/20150831_183531-1.png` | gallery (g11) | **locked** — see `content/gallery/photos/g11.jpg` |
| `images/gallery/IMAG0069-1.png` | gallery (g12) | **locked** — see `content/gallery/photos/g12.jpg` |
| `images/gallery/2015-01-12 10.34.44-1.png` | gallery (g13) | **locked** — see `content/gallery/photos/g13.jpg` |
| `images/gallery/IMG_0647.png` | gallery (g14) | **locked** — see `content/gallery/photos/g14.jpg` |
| `images/gallery/IMG_0946.png` | gallery (g15) | **locked** — see `content/gallery/photos/g15.jpg` |
| `images/gallery/IMG_1413.png` | gallery (g16) | **locked** — see `content/gallery/photos/g16.jpg` |
| `images/gallery/IMG_0398.png` | gallery (g17) | **locked** — see `content/gallery/photos/g17.jpg` |
| `images/gallery/PHOTO-2026-10-03-15-58-29-1.png` | gallery (g18) | **locked** — see `content/gallery/photos/g18.jpg` |

## Snapshot

| Folder | Count | Default assigned_page |
|--------|------:|-----------------------|
| gallery | 69 (1 locked to Home) | gallery |
| prodMan | 9 | production-management |
| techDir | 7 | technical-direction |
| creativeTech | 9 | creative-technology |
| sysDesign | 4 | system-design |
| logos | 9 | chrome |

## Duplicate basenames (service owns; gallery twin → omit)

| Basename | Service path | Gallery path | assigned_page |
|----------|--------------|--------------|---------------|
| `152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1` | `images/sysDesign/152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1.png` | `images/gallery/152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1.png` | system-design |
| `A01_0491-1` | `images/prodMan/A01_0491-1.png` | `images/gallery/A01_0491-1.png` | production-management |
| `A01_0550-1` | `images/prodMan/A01_0550-1.png` | `images/gallery/A01_0550-1.png` | production-management |
| `IMAGE_012-1` | `images/techDir/IMAGE_012-1.png` | `images/gallery/IMAGE_012-1.png` | technical-direction |
| `IMG_0003-1` | `images/sysDesign/IMG_0003-1.png` | `images/gallery/IMG_0003-1.png` | system-design |
| `IMG_0004-1` | `images/sysDesign/IMG_0004-1.png` | `images/gallery/IMG_0004-1.png` | system-design |
| `IMG_0023-1` | `images/prodMan/IMG_0023-1.png` | `images/gallery/IMG_0023-1.png` | production-management |
| `IMG_0214-1` | `images/prodMan/IMG_0214-1.png` | `images/gallery/IMG_0214-1.png` | production-management |
| `IMG_0266` | `images/techDir/IMG_0266.png` | `images/gallery/IMG_0266.png` | technical-direction |
| `IMG_0770` | `images/techDir/IMG_0770.png` | `images/gallery/IMG_0770.png` | technical-direction |
| `IMG_0980` | `images/creativeTech/IMG_0980.png` | `images/gallery/IMG_0980.png` | creative-technology |
| `IMG_1572-1` | `images/sysDesign/IMG_1572-1.png` | `images/gallery/IMG_1572-1.png` | system-design |
| `PA080012-1` | `images/prodMan/PA080012-1.png` | `images/gallery/PA080012-1.png` | production-management |
| `PA080013-1` | `images/prodMan/PA080013-1.png` | `images/gallery/PA080013-1.png` | production-management |
| `PB070058-1` | `images/techDir/PB070058-1.png` | `images/gallery/PB070058-1.png` | technical-direction |
| `PB080085-1` | `images/techDir/PB080085-1.png` | `images/gallery/PB080085-1.png` | technical-direction |
| `PC300072-1` | `images/techDir/PC300072-1.png` | `images/gallery/PC300072-1.png` | technical-direction |

## Full register

| id | source_path | basename | assigned_page | status | notes |
|----|-------------|----------|---------------|--------|-------|
| img-001 | `images/gallery/0201170730-1.png` | `0201170730-1` | gallery | locked | Gallery Phase 3 marquee (g08). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g08.jpg`. |
| img-002 | `images/gallery/100_0154-1.png` | `100_0154-1` | gallery | locked | Gallery Phase 3 marquee (g01). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g01.jpg`. |
| img-003 | `images/gallery/152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1.png` | `152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1` | omit | omit | Duplicate of images/sysDesign/; service owns basename |
| img-004 | `images/sysDesign/152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1.png` | `152B3A8A-AB46-4FD4-AC70-59E16EE078B0-1` | system-design | locked | System Design H1 hero (Phase 2). Resized 3840×2160→2400×1350, PNG→JPG q86, saved as `content/system-design/hero.jpg`. |
| img-005 | `images/gallery/2013-03-17 08.16.30-1.png` | `2013-03-17 08.16.30-1` | gallery | locked | Gallery Phase 3 marquee (g06). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g06.jpg`. |
| img-006 | `images/gallery/2013-04-14 07.36.29-1.png` | `2013-04-14 07.36.29-1` | gallery | candidate |  |
| img-007 | `images/gallery/2014-04-01 08.16.51-1.png` | `2014-04-01 08.16.51-1` | gallery | candidate |  |
| img-008 | `images/gallery/2014-06-12 08.58.41-1.png` | `2014-06-12 08.58.41-1` | gallery | candidate |  |
| img-009 | `images/gallery/2014-07-10 20.00.52-1.png` | `2014-07-10 20.00.52-1` | gallery | candidate |  |
| img-010 | `images/gallery/2014-10-27 15.50.06-1.png` | `2014-10-27 15.50.06-1` | gallery | candidate |  |
| img-011 | `images/gallery/2015-01-12 10.34.44-1.png` | `2015-01-12 10.34.44-1` | gallery | locked | Gallery Phase 3 marquee (g13). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g13.jpg`. |
| img-012 | `images/gallery/2015-02-02 13.46.09-1.png` | `2015-02-02 13.46.09-1` | gallery | candidate |  |
| img-013 | `images/gallery/2015-02-20 07.13.50-1.png` | `2015-02-20 07.13.50-1` | gallery | candidate |  |
| img-014 | `images/gallery/2015-03-21 13.43.39-1.png` | `2015-03-21 13.43.39-1` | gallery | candidate |  |
| img-015 | `images/gallery/20150203_190036-1.png` | `20150203_190036-1` | home | locked | Home H2 hero (Phase 1). Resized 6080×3200→2400×1263, converted PNG→JPG q86, saved as `content/cothrom-home-hero.jpg` (page resource of Home). Removed from Gallery candidate pool. |
| img-016 | `images/gallery/20150713_142432-1.png` | `20150713_142432-1` | gallery | locked | Gallery Phase 3 marquee (g10). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g10.jpg`. |
| img-017 | `images/gallery/20150831_183531-1.png` | `20150831_183531-1` | gallery | locked | Gallery Phase 3 marquee (g11). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g11.jpg`. |
| img-018 | `images/gallery/A01_0491-1.png` | `A01_0491-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-019 | `images/prodMan/A01_0491-1.png` | `A01_0491-1` | production-management | candidate | Owns basename vs gallery twin |
| img-020 | `images/gallery/A01_0550-1.png` | `A01_0550-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-021 | `images/prodMan/A01_0550-1.png` | `A01_0550-1` | production-management | locked | Production Management H1 hero (Phase 2). Resized 5594×3146→2400×1350, PNG→JPG q86, saved as `content/production-management/hero.jpg`. |
| img-022 | `images/gallery/IMAG0069-1.png` | `IMAG0069-1` | gallery | locked | Gallery Phase 3 marquee (g12). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g12.jpg`. |
| img-023 | `images/gallery/IMAG0231-1.png` | `IMAG0231-1` | gallery | locked | Gallery Phase 3 marquee (g05). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g05.jpg`. |
| img-024 | `images/techDir/IMAGE_010-1.png` | `IMAGE_010-1` | technical-direction | candidate |  |
| img-025 | `images/gallery/IMAGE_012-1.png` | `IMAGE_012-1` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-026 | `images/techDir/IMAGE_012-1.png` | `IMAGE_012-1` | technical-direction | candidate | Owns basename vs gallery twin |
| img-027 | `images/gallery/IMG_0003-1.png` | `IMG_0003-1` | omit | omit | Duplicate of images/sysDesign/; service owns basename |
| img-028 | `images/sysDesign/IMG_0003-1.png` | `IMG_0003-1` | system-design | candidate | Owns basename vs gallery twin |
| img-029 | `images/gallery/IMG_0004-1.png` | `IMG_0004-1` | omit | omit | Duplicate of images/sysDesign/; service owns basename |
| img-030 | `images/sysDesign/IMG_0004-1.png` | `IMG_0004-1` | system-design | candidate | Owns basename vs gallery twin |
| img-031 | `images/gallery/IMG_0023-1.png` | `IMG_0023-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-032 | `images/prodMan/IMG_0023-1.png` | `IMG_0023-1` | production-management | candidate | Owns basename vs gallery twin |
| img-033 | `images/gallery/IMG_0026-1.png` | `IMG_0026-1` | gallery | candidate |  |
| img-034 | `images/gallery/IMG_0034-1.png` | `IMG_0034-1` | gallery | candidate |  |
| img-035 | `images/gallery/IMG_0043-1.png` | `IMG_0043-1` | gallery | candidate |  |
| img-036 | `images/gallery/IMG_0046-1.png` | `IMG_0046-1` | gallery | candidate |  |
| img-037 | `images/gallery/IMG_0068-1.png` | `IMG_0068-1` | gallery | candidate |  |
| img-038 | `images/gallery/IMG_0075-1.png` | `IMG_0075-1` | gallery | locked | Gallery Phase 3 marquee (g09). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g09.jpg`. |
| img-039 | `images/gallery/IMG_0085-1.png` | `IMG_0085-1` | gallery | candidate |  |
| img-040 | `images/gallery/IMG_0088-1.png` | `IMG_0088-1` | gallery | candidate |  |
| img-041 | `images/prodMan/IMG_0094.png` | `IMG_0094` | production-management | candidate |  |
| img-042 | `images/prodMan/IMG_0095.png` | `IMG_0095` | production-management | candidate |  |
| img-043 | `images/gallery/IMG_0098-1-1.png` | `IMG_0098-1-1` | gallery | candidate |  |
| img-044 | `images/gallery/IMG_0101-1.png` | `IMG_0101-1` | gallery | candidate |  |
| img-045 | `images/gallery/IMG_0102-1.png` | `IMG_0102-1` | gallery | locked | Gallery Phase 3 marquee (g07). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g07.jpg`. |
| img-046 | `images/gallery/IMG_0213-1.png` | `IMG_0213-1` | gallery | candidate |  |
| img-047 | `images/gallery/IMG_0214-1.png` | `IMG_0214-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-048 | `images/prodMan/IMG_0214-1.png` | `IMG_0214-1` | production-management | candidate | Owns basename vs gallery twin |
| img-049 | `images/gallery/IMG_0222-1.png` | `IMG_0222-1` | gallery | candidate |  |
| img-050 | `images/gallery/IMG_0232-1.png` | `IMG_0232-1` | gallery | candidate |  |
| img-051 | `images/gallery/IMG_0266.png` | `IMG_0266` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-052 | `images/techDir/IMG_0266.png` | `IMG_0266` | technical-direction | locked | Technical Direction H1 hero (Phase 2). Resized 4032×3024→2400×1800, PNG→JPG q86, saved as `content/technical-direction/hero.jpg`. |
| img-053 | `images/gallery/IMG_0327-1.png` | `IMG_0327-1` | gallery | candidate |  |
| img-054 | `images/gallery/IMG_0361.png` | `IMG_0361` | gallery | candidate |  |
| img-055 | `images/gallery/IMG_0398.png` | `IMG_0398` | gallery | locked | Gallery Phase 3 marquee (g17). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g17.jpg`. |
| img-056 | `images/gallery/IMG_0647.png` | `IMG_0647` | gallery | locked | Gallery Phase 3 marquee (g14). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g14.jpg`. |
| img-057 | `images/gallery/IMG_0685.png` | `IMG_0685` | gallery | candidate |  |
| img-058 | `images/gallery/IMG_0770.png` | `IMG_0770` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-059 | `images/techDir/IMG_0770.png` | `IMG_0770` | technical-direction | candidate | Owns basename vs gallery twin |
| img-060 | `images/gallery/IMG_0896.png` | `IMG_0896` | gallery | candidate |  |
| img-061 | `images/gallery/IMG_0946.png` | `IMG_0946` | gallery | locked | Gallery Phase 3 marquee (g15). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g15.jpg`. |
| img-062 | `images/gallery/IMG_0949.png` | `IMG_0949` | gallery | candidate |  |
| img-063 | `images/creativeTech/IMG_0979.png` | `IMG_0979` | creative-technology | candidate |  |
| img-064 | `images/creativeTech/IMG_0980.png` | `IMG_0980` | creative-technology | locked | Creative Technology H1 hero (Phase 2). Resized 4032×3024→2400×1800, PNG→JPG q86, saved as `content/creative-technology/hero.jpg`. |
| img-065 | `images/gallery/IMG_0980.png` | `IMG_0980` | omit | omit | Duplicate of images/creativeTech/; service owns basename |
| img-066 | `images/gallery/IMG_1104.png` | `IMG_1104` | gallery | candidate |  |
| img-067 | `images/gallery/IMG_1105.png` | `IMG_1105` | gallery | locked | Gallery Phase 3 marquee (g03). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g03.jpg`. |
| img-068 | `images/creativeTech/IMG_1289-1.png` | `IMG_1289-1` | creative-technology | candidate |  |
| img-069 | `images/gallery/IMG_1291-1.png` | `IMG_1291-1` | gallery | candidate |  |
| img-070 | `images/creativeTech/IMG_1292-1.png` | `IMG_1292-1` | creative-technology | candidate |  |
| img-071 | `images/prodMan/IMG_1297-1.png` | `IMG_1297-1` | production-management | candidate |  |
| img-072 | `images/gallery/IMG_1299-1.png` | `IMG_1299-1` | gallery | candidate |  |
| img-073 | `images/gallery/IMG_1413.png` | `IMG_1413` | gallery | locked | Gallery Phase 3 marquee (g16). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g16.jpg`. |
| img-074 | `images/gallery/IMG_1431.png` | `IMG_1431` | gallery | candidate |  |
| img-075 | `images/gallery/IMG_1572-1.png` | `IMG_1572-1` | omit | omit | Duplicate of images/sysDesign/; service owns basename |
| img-076 | `images/sysDesign/IMG_1572-1.png` | `IMG_1572-1` | system-design | candidate | Owns basename vs gallery twin |
| img-077 | `images/gallery/IMG_1624.png` | `IMG_1624` | gallery | candidate |  |
| img-078 | `images/gallery/IMG_1628.png` | `IMG_1628` | gallery | candidate |  |
| img-079 | `images/gallery/IMG_1681.png` | `IMG_1681` | gallery | candidate |  |
| img-080 | `images/gallery/P2050052-1.png` | `P2050052-1` | gallery | candidate |  |
| img-081 | `images/creativeTech/P2270002.png` | `P2270002` | creative-technology | candidate |  |
| img-082 | `images/creativeTech/P4280049.png` | `P4280049` | creative-technology | candidate |  |
| img-083 | `images/creativeTech/P5020069.png` | `P5020069` | creative-technology | candidate |  |
| img-084 | `images/creativeTech/P9250165.png` | `P9250165` | creative-technology | candidate |  |
| img-085 | `images/creativeTech/P9250169.png` | `P9250169` | creative-technology | candidate |  |
| img-086 | `images/gallery/PA080012-1.png` | `PA080012-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-087 | `images/prodMan/PA080012-1.png` | `PA080012-1` | production-management | candidate | Owns basename vs gallery twin |
| img-088 | `images/gallery/PA080013-1.png` | `PA080013-1` | omit | omit | Duplicate of images/prodMan/; service owns basename |
| img-089 | `images/prodMan/PA080013-1.png` | `PA080013-1` | production-management | candidate | Owns basename vs gallery twin |
| img-090 | `images/gallery/PA260002-1.png` | `PA260002-1` | gallery | locked | Gallery Phase 3 marquee (g02). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g02.jpg`. |
| img-091 | `images/gallery/PB070058-1.png` | `PB070058-1` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-092 | `images/techDir/PB070058-1.png` | `PB070058-1` | technical-direction | candidate | Owns basename vs gallery twin |
| img-093 | `images/gallery/PB080085-1.png` | `PB080085-1` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-094 | `images/techDir/PB080085-1.png` | `PB080085-1` | technical-direction | candidate | Owns basename vs gallery twin |
| img-095 | `images/gallery/PC300072-1.png` | `PC300072-1` | omit | omit | Duplicate of images/techDir/; service owns basename |
| img-096 | `images/techDir/PC300072-1.png` | `PC300072-1` | technical-direction | candidate | Owns basename vs gallery twin |
| img-097 | `images/gallery/PHOTO-2026-10-03-15-58-29-1.png` | `PHOTO-2026-10-03-15-58-29-1` | gallery | locked | Gallery Phase 3 marquee (g18). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g18.jpg`. |
| img-098 | `images/logos/cothrom-logo-kraft.svg` | `cothrom-logo-kraft` | chrome | candidate | Brand chrome / favicons only |
| img-099 | `images/logos/cothrom-logo-kraft-1200x800.png` | `cothrom-logo-kraft-1200x800` | chrome | candidate | Brand chrome / favicons only |
| img-100 | `images/logos/cothrom-logo-kraft-600x400.png` | `cothrom-logo-kraft-600x400` | chrome | candidate | Brand chrome / favicons only |
| img-101 | `images/logos/cothrom-mark-kraft.svg` | `cothrom-mark-kraft` | chrome | candidate | Brand chrome / favicons only |
| img-102 | `images/logos/cothrom-mark-kraft-1024.png` | `cothrom-mark-kraft-1024` | chrome | candidate | Brand chrome / favicons only |
| img-103 | `images/logos/cothrom-mark-kraft-180.png` | `cothrom-mark-kraft-180` | chrome | candidate | Brand chrome / favicons only |
| img-104 | `images/logos/cothrom-mark-kraft-192.png` | `cothrom-mark-kraft-192` | chrome | candidate | Brand chrome / favicons only |
| img-105 | `images/logos/cothrom-mark-kraft-32.png` | `cothrom-mark-kraft-32` | chrome | candidate | Brand chrome / favicons only |
| img-106 | `images/logos/cothrom-mark-kraft-512.png` | `cothrom-mark-kraft-512` | chrome | candidate | Brand chrome / favicons only |
| img-107 | `images/gallery/first 218-1.png` | `first 218-1` | gallery | locked | Gallery Phase 3 marquee (g04). Resized to 1280px tall, PNG→JPG q85, saved as `content/gallery/photos/g04.jpg`. |
