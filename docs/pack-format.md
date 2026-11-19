# Pack format (schema v3)

This is the contract between the pack builder (`tools/pack_builder/`) and the app. A grade pack is one `content.db` plus the subject PDFs. Any change to this file goes through a PR reviewed by both developers.

## Schema rule

Packs ship at the schema the app expects, `ContentDatabase.packSchemaVersion` (currently **3**). The app never migrates `content.db`. A pack with an older schema is treated as needing an update and is downloaded again. In debug and profile builds the development seed deletes and rebuilds a `content.db` whose schema differs.

**`PRAGMA user_version` is a hard rule.** `content.db` MUST have `PRAGMA user_version = 3`, equal to `pack_meta.schema_version` and `ContentDatabase.packSchemaVersion`. The app opens `content.db` read-only through drift (`ContentDatabase.readOnly`) and has no `onUpgrade`: when `user_version` differs, drift tries to create or upgrade the schema on a read-only file and opening fails. The pack builder must set it, and the development seed does. `test/dev_seed_contract_test.dart` asserts that the value matches both.

## Package layout

```
content.db
pdf/<subject_id>.pdf      one PDF per subject, the ministry file as is
images/<file>.webp        images referenced from section bodies
```

`images/` sits at the pack root and is flat: no subfolders. Every image is WebP with a maximum width of 1080 px. Expect 20-30 MB of images per grade. The manifest's zip `size` already includes the images, so the free-space check needs no separate figure.

## Subject ids

`arabic`, `english`, `math`, `science`.
Reserved for later: `islamic`, `social_studies`, `technology`.

## `pack_meta`

Key/value rows. All four are required.

| key | value |
|---|---|
| `schema_version` | the app's `ContentDatabase.packSchemaVersion` |
| `grade` | grade number, for example `9` |
| `pack_version` | integer, increases with every release of the pack |
| `built_at` | UTC time in ISO 8601, for example `2026-11-18T00:00:00Z` |

## Page numbers

There is no fixed offset between PDF pages and printed pages. The offset can change inside one book (front matter, unnumbered plates).

- `lessons` has `pdf_page_from`, `pdf_page_to` (integers) and `printed_page_from`, `printed_page_to` (text, like `pack_pages.printed_page`, so Roman numerals and empty values are allowed).
- `pack_pages(subject_id, pdf_page, printed_page)` maps every PDF page of a subject to its printed number. An unnumbered page has `printed_page = ''`. Roman numerals are allowed.
- `chunks` keeps `pdf_page` (integer) and `printed_page` (text).
- Students always see printed pages. `pdf_page` is only used to open the PDF viewer.
- `lessons.book_pages_from`, `book_pages_to` and `pdf_file` are older columns still read by the lesson feature. New content should fill the new columns; `pdf_file` is the file name inside `pdf/`.
- Two page sources exist for now: `book_pages_from/to` next to `printed_page_from/to` + `pdf_page_from/to`. After this schema merges, `subjects` and `lesson` move to `printed_page_*` / `pdf_page_*`; then `book_pages_*` is dropped in a later schema version.

## `sections.body` (Markdown)

| element | syntax |
|---|---|
| subheadings | `##` and `###` (the section title is stored in `sections.title`, not in the body) |
| lists | `- item` |
| highlighted text | `**bold**` |
| callouts | a blockquote that starts with `**تذكّر:**` or `**انتبه:**` |
| inline math | `$...$` |
| block math | `$$...$$` on its own lines |
| images | `![caption](images/<file>.webp)`, path relative to the pack root |
| tables | GitHub-style Markdown tables |

Example:

```markdown
## القوة بين شحنتين نقطيتين

تتناسب القوة **طردياً** مع حاصل ضرب الشحنتين، وتساوي $F = k \frac{q_1 q_2}{r^2}$.

$$F = k \frac{q_1 q_2}{r^2}$$

> **تذكّر:** إذا تضاعفت المسافة قلّت القوة إلى الربع.
```

## `book_solutions`

`id`, `lesson_id`, `number`, `question`, `page`, `solution`. `question` is the text of the textbook question; `page` is a printed page number, stored as text like `pack_pages.printed_page`.

## `lessons.video_chapters_json`

A JSON array ordered by `start_seconds`:

```json
[{"start_seconds": 0, "title": "مقدمة"}, {"start_seconds": 95, "title": "الشحن بالدلك"}]
```
