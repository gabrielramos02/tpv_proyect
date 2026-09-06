# AGENTS.md

Flutter point-of-sale (TPV) app. Pub package name is `flutter_proyect` — imports are `package:flutter_proyect/...`, not the repo name.

## Commands

- `flutter pub get` → `flutter analyze` → `flutter test` — run analyze before tests; there is no lint step beyond `flutter_lints`.
- PR CI (`.github/workflows/pr-check.yml`) runs `flutter analyze` + `flutter test` on every PR — keep it green; it is the verification gate for agent PRs.
- Codegen (required after editing `lib/data/services/database/tables.dart` or `dbConnection.dart`):
  `dart run build_runner build --delete-conflicting-outputs`
- After bumping `schemaVersion`: `dart run drift_dev schema dump lib/data/services/database/dbConnection.dart drift_schemas/my_database/` then regenerate test helpers with `dart run drift_dev schema generate drift_schemas/my_database/ test/drift/my_database/generated/` — otherwise `test/drift/my_database/migration_test.dart` breaks.
- App icons: `dart run flutter_launcher_icons` (config in `flutter_launcher_icons.yaml`).

## Architecture

- `lib/main.dart` — entrypoint. Exposes a **global singleton** `AppDatabase database` that all widgets import and use directly (no DI/provider). DB queries are written inline in widgets.
- `lib/data/services/database/` — drift database. `dbConnection.dart` (`AppDatabase`, current `schemaVersion` 2, step-by-step migrations), `tables.dart` (table definitions, referenced from `build.yaml`). `*.g.dart` / `*.steps.dart` are generated — never hand-edit.
- `lib/data/services/` — `settings.dart` (SharedPreferences-backed `Config`, `Config.init()` runs in `main`), `printer/` (thermal printer via `flutter_thermal_printer`).
- `lib/data/repositories/` — `db_updates.dart` (order/ticket state-machine logic, class `DbUpdates`; destined to become an order repository in Phase 2). Currently the only "repository".
- `lib/domain/` — `calculate_from_expression.dart` (pure math).
- `lib/core/` — `logger.dart` (global `logger`).
- `lib/ui/features/` — screens grouped by feature: `zone/` (`zone_view.dart`, the only route, `new_table_form.dart`), `table/` (`table_view.dart` order taking, `checkout.dart`, `split_table.dart`, `forms/`), `config/` (`config_view.dart`, `select_printer_view.dart`).
- `lib/ui/core/` — shared widgets (`keyboard.dart`, `product_list.dart`, `products.dart`, `product_types.dart`, `edit_product.dart`) and `theme/` (`proyect_styles.dart`).
- Tests: drift migration tests (`test/drift/`) plus unit tests that mirror `lib/` (e.g. `test/domain/`, `test/data/`). No widget tests yet.

## Issue tracking (Linear)

- This repo is tracked in **Linear** — workspace `tpv-app` (`linear.app/tpv-app`), team `TPV`, key `TPV`. The current refactor work lives in project **major refactor** (`linear.app/tpv-app/project/major-refactor-dc33e1c17814`). Use the `linear-project_*` MCP tools.
- Any **planning session the user accepts must be exported to Linear** as issues (create/extend the relevant milestone; attach path/file references from the plan).
- Use labels `Feature`, `Bug`, `Improvement`; set priorities; statuses are Backlog → Todo → In Progress → In Review → Done.

## Git workflow & agents

- Feature work never lands directly on `main` — pushing to `main` ships a release (see Conventions). Always open a **PR targeting `main`**; review via Linear Reviews or GitHub.
- **Branch per Linear issue** using the auto-generated branch name (e.g. `grp29113110/tpv-6-databaseservice-capa-de-repositorios`). Use the magic word `Fixes TPV-N` in the PR description to link it to Linear and auto-close the issue on merge; `Refs TPV-N` links without closing.
- Linear git automations move status automatically: PR open → In Progress, review requested → In Review, merge → Done.
- Issues can be **delegated to agents** (GitHub Copilot is installed as an agent); the human stays the assignee/owner and reviews the agent's PR. Agent PRs are validated by `.github/workflows/pr-check.yml` (`flutter analyze` + `flutter test`) — agents can't reliably run the Flutter toolchain locally, so CI is the verification gate.
- Provide agent instructions via Linear **Agent guidance** (Settings → Agents → Additional guidance): point at `gabrielramos02/tpv_proyect`, enforce per-issue branches + `Fixes TPV-N` in PRs, `flutter analyze` → `flutter test`, English comments, never commit `key.properties`/`upload.jks`.

## Conventions & gotchas

- README and in-code comments are in **English**; match that when adding comments/docs.
- Check if changes mades afect the README file. Update it if neccessary
- App is landscape-only (locked in `main.dart`); UI is designed for tablets.
- `analysis_options.yaml` excludes all platform dirs (android/ios/web/...) — only `lib/` and `test/` are analyzed.
- `Config.init()` tries to auto-connect to a saved BLE/USB printer on startup; printer code requires Android permissions.
- Never commit `android/key.properties` or `android/app/upload.jks` — CI (`.github/workflows/push-main.yml`) injects them from secrets on push to `main`, builds split-per-abi release APKs, and publishes them to the separate `gabrielramos02/tpv_release` repo. Pushing to `main` = shipping a release.
- `todo.md` at repo root is the maintainer's scratch task list.
