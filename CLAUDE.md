# CLAUDE.md — Working rules for Mualimi (معلّمي)

You are working on an existing, carefully structured Flutter app. The architecture skeleton is done. Build features INSIDE it; never redesign it. When a rule here conflicts with what you think is better, the rule wins — stop and ask the human instead.

## What the app is
Mualimi helps students in Gaza study the official Palestinian Ministry of Education learning packs (condensed curriculum prepared for Gaza). It knows where each student actually is, fills their learning gaps from earlier grades, and answers questions from their own learning pack with the page number. Most features work offline.

## The principle that matters most
- Lessons, explanations, solutions, key terms, gap-review mini-lessons, saved answers and the question bank MUST work fully offline. Never make any of them depend on the network.
- The network is needed only for: (1) downloading a grade pack, (2) free-form questions to the tutor, (3) lesson videos.
- With no internet the app degrades gracefully — it never breaks or blocks a lesson.

## Tutor architecture (3 layers)
1. **Prebuilt content inside the pack (offline):** lesson explanations, summaries, key terms, a question bank with answers, diagnostic questions, prerequisite maps. Prepared ahead, human-reviewed, shipped as text in `content.db`.
2. **Pack search (offline):** SQLite FTS5 over pack chunks, with Arabic normalization. Always available.
3. **Cloud LLM (online, free-form questions only):** behind the `LlmDataSource` interface. Retrieved chunks + the question are sent; the model answers ONLY from those chunks. With no internet, the question goes to `pending_questions` and is answered when the connection returns.

There is no on-device model in this app. Do not add one.

## API keys (strict)
- Never write an API key in code, in a committed file, in a test, or in a log.
- Keys are passed at run time only: `flutter run --dart-define=GEMINI_API_KEY=...`, read with `String.fromEnvironment`.
- Never commit `.env` files or anything containing a key. If you find a key in the code, stop and tell the human.

## Architecture — do not cross these lines
- Clean Architecture, feature-based: `domain / data / presentation` per feature.
- **domain** imports only pure Dart (+ `dartz`, `equatable`). Never Flutter, drift, http or any plugin.
- **Views** contain no logic — they render and call controller methods.
- **Controllers** never touch data sources directly — always through a use case.
- Every repository has an interface in `domain/repositories` and an implementation in `data/repositories`.
- Every external service (LLM, downloader, database, connectivity, notifications) sits behind an interface.
- State management is **GetX** only. Do not introduce Bloc, Riverpod, Provider or any other.

## Feature ownership (two developers — never edit the other track's features)
| AI track (Kamal) | Content & study track (teammate) |
|---|---|
| `curriculum_tutor` (tutor chat, LLM client, question bank, offline queue, saved answers, history, report) | `onboarding` (splash, welcome, grade) |
| `gap_filling` (diagnostic, skill mastery, learning path, prerequisites card, mini-reviews) | `content_manager` (pack download, update, import from file, sharing) |
| Pack builder tool (`tools/pack_builder/`, Python, outside the app) | `subjects`, `lesson`, `profile`, `shell` |

Work ONLY inside the features of your track. If a task needs a change in the other track, stop and ask.

## Contracts between the two tracks (change only when both agree)
- **Opening the tutor:** the tutor is opened from other features only through `AppRoutes.tutor` with `TutorArgs(subjectId, lessonId)`. It opens as a full screen on top of the current page, with a back button. The tutor tab in the shell stays as is.
- **Pack schema:** `pack_meta` contains `schema_version`. Packs ship already at the schema the app expects; the app never migrates `content.db`. If a pack's schema is older than expected, the app treats it as needing an update and downloads it again.
- The pack format is defined in `docs/pack-format.md`. Any change to it goes through a PR reviewed by both developers.
- **Tutor → pack viewer:** "Open in pack" opens the lesson viewer route with `lessonId` and `pdfPage`.
- **Prerequisites card:** `gap_filling` exposes `LessonPrerequisitesCard(lessonId)`. The lesson page only places it.
- **Learning path on Home:** `gap_filling` exposes the "مسارك" widget. Home only places it.
- **After the pack installs:** onboarding navigates to `/diagnostic`; when it finishes it navigates to `/shell`.
- **Profile → diagnostic:** "retake the diagnostic" opens `/diagnostic`.

## Databases
- `content.db` — read-only, replaced as a whole file on pack update. Tables: `subjects`, `units`, `lessons`, `sections`, `key_terms`, `questions`, `book_solutions`, `chunks` (with `printed_page`, `pdf_page`) + `chunks_fts`, `prebuilt_answers`, `question_bank` + `question_bank_fts`, `skills`, `lesson_prerequisites`, `diagnostic_questions`, `pack_meta`.
- `user.db` — read/write, never wiped by pack updates. Tables: `saved_answers`, `question_history`, `lesson_progress`, `pending_reports`, `pending_questions`, `tutor_usage`, `skill_mastery`, `diagnostic_attempts`, `downloads_state`.
- Close `content.db` through `DatabaseService` before replacing it, then reopen.
- Page numbers shown to students are the pack's printed page numbers (`printed_page`). `pdf_page` is used only to open the PDF viewer.

## Things you must not do without asking the human first
- Edit anything in `lib/core/` (constants, theme, widgets, services, db, routes) — it is shared by both developers.
- Rename, move or restructure existing folders or files.
- Add a package to `pubspec.yaml`.
- Change the manifest JSON shape or any drift table schema.
- Touch the other track's features.
- Rewrite a whole file to make a small change. Edit the minimum.

A task prompt from the human may explicitly authorize some of these. Then follow the prompt, and list every such change in your report.

## Code style
- Write code the way an experienced Flutter engineer on this team does. Follow the naming already used in the project (`...UseCase`, `...Repository`, `...RepositoryImpl`, `...DataSource`, `...Controller`, `...Binding`, `...Page`).
- Names describe the domain. Avoid vague names (`Helper`, `Util`, `Handler`, `Manager2`, `Smart...`, `Magic...`).
- Comments only where the reason is not obvious from the code. No comments that narrate the code, no banner comments, no emojis.
- No wording in code, comments, docs, tests or commit messages that refers to an assistant, a code generator, or how the code was produced. A provider name appears only in the class that talks to that provider (e.g. `GeminiClient`).
- No dead code, no commented-out code, no stray `print`s.
- One main class per file; keep files under ~150 lines. `snake_case` files, `PascalCase` classes; file name matches the class.

## Performance (weak phones, scarce electricity)
- Heavy work (hashing, unzip, search scoring) runs inside `Isolate.run`, never on the UI thread.
- `const` widgets and `ListView.builder` for every list.
- Search returns at most the top 4 chunks.
- While streaming an answer, batch UI updates (~50 ms) — never rebuild on every chunk.
- Prefer `prebuilt_answers` and `question_bank` over calling the LLM.
- Respect the values in `lib/core/constants/limits.dart` (max output tokens, daily question limit, match thresholds, weak-skill threshold).

## Offline and assets
- Fonts are bundled assets. Never use `google_fonts` or any runtime-downloaded resource.
- Lesson videos need internet: with no connection, show the "video needs internet" card — never an error.

## UI
- No hardcoded colors — use `AppColors`. No magic spacing numbers — use `AppSizes`.
- RTL + Arabic (IBM Plex Sans Arabic). The back arrow points right.
- Match `design/screens/light/<Name>.png` (look) and `.html` (exact values), then check `design/screens/dark/<Name>.png`.
- Screens not in `design/` follow the same visual style and reuse `lib/core/widgets/`.

## Quality gate
- `flutter analyze` reports zero issues before every commit.
- Add or keep unit tests for any logic you touch. No real network calls in tests.

## Git (strict)
- Work only on a branch named `feat/<feature-name>`. Never commit to `main`.
- Local commits are fine. Never push, never force-push, never rebase shared history, never add or modify a remote, never touch the other developer's branch. The human reviews and pushes.
- Commit messages: short, imperative, plain English. No trailers or attribution lines.
- This file is shared and committed. Personal instructions go in your user-level `~/.claude/CLAUDE.md`, never in this file. Changes to this file go through a PR that the other developer reviews.

## When you finish a task, report
1. Files added, changed and removed, and why.
2. Any decision the task didn't specify, with the reason.
3. Any TODO left.
4. The output of `flutter analyze` and `flutter test`.