# BrewBoss — Cafe Shop Management System (Flutter)

Full rules and code templates: `docs/CODING_RULES.md`. Requirements, screens,
data model, business rules: `docs/product-brief.md`. Read both before coding.

## Stack (fixed)
Flutter + `flutter_riverpod` (plain providers, no codegen) + `go_router`
+ Firebase (`firebase_auth`, `cloud_firestore`) + `freezed`/`json_serializable`
+ `intl`. Do not add a second state-management or routing library.

## Architecture
- Feature-first: `lib/features/<module>/{data,application,presentation}/`.
  Shared: `lib/core/` (router, theme, utils, widgets), `lib/models/` (freezed).
- Dependency direction: `presentation → application → data`. Never reversed, never skipped.
- Only `data/` repositories touch Firebase. Widgets never call `FirebaseFirestore.instance`.
- Cross-feature access only via providers in `application/`. Never import another feature's `data/` or `presentation/`.
- Business rules = pure Dart functions in `application/<module>_rules.dart` + a unit test in `test/features/<module>/`.
- Reference slice to copy: `lib/features/staff/` + `lib/models/shift.dart` + `test/features/staff/`.
- Riverpod 3: controllers extend `AsyncNotifier<T>`; use `AsyncNotifierProvider.autoDispose<C, T>(C.new)`.
- Models with timestamps import `cloud_firestore` (with `// ignore: unused_import`) so the generated `.g.dart` compiles.

## Hard rules
- Money is `int` VND. Format with `formatVnd()` from `core/utils/format.dart`.
- Models are `@freezed abstract class` with `fromJson`. `id` = Firestore doc id, not stored in the doc.
- Writes go through an `AsyncNotifier` controller using `AsyncValue.guard`; methods return `bool`.
- Every screen handles loading / error / empty via `AsyncValue.when`.
- Navigation via `context.push(Routes.x)` with constants in `core/router/routes.dart`. No `Navigator.push`.
- `ref.watch` in build, `ref.read` in callbacks. Check `context.mounted` after `await`.
- Firestore field names must match `docs/product-brief.md` §9.2 exactly.
- English only in code, comments, commits. Vietnamese only in user-facing strings.

## Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after editing models
flutter analyze && dart format . && flutter test            # before every commit
```

## Git
Branch `feat/<module>-<desc>`; Conventional Commits with scope (`feat(pos): ...`);
PR title carries the requirement id (`[FR-POS-03] ...`). Commit generated `*.freezed.dart` / `*.g.dart`.
