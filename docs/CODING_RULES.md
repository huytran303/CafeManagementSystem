# BrewBoss Coding Rules & Patterns

Read this before writing any code. Every rule here exists so that 5 people can
work on the same codebase without stepping on each other. When in doubt, copy
an existing feature that already follows the pattern.

Stack (fixed, do not add alternatives): Flutter + `flutter_riverpod` (state)
+ `go_router` (navigation) + Firebase (`firebase_auth`, `cloud_firestore`)
+ `freezed` / `json_serializable` (models) + `intl` (formatting).

---

## 1. Golden rules (memorize these)

1. **Feature-first folders.** Every module lives in `lib/features/<module>/`
   with exactly three sub-folders: `data/`, `application/`, `presentation/`.
2. **One-way dependency.** `presentation → application → data`. Never the
   reverse. Never skip a layer (a widget never calls a repository directly).
3. **Only `data/` touches Firebase.** `FirebaseFirestore.instance` and
   `FirebaseAuth.instance` appear in repository files only.
4. **No cross-feature imports** except through `application/` providers.
   `features/pos/` may `ref.watch(productsProvider)` from menu, but may not
   import `features/menu/data/...` or `features/menu/presentation/...`.
5. **Money is `int` VND.** Never `double`. Format with `formatVnd()` only.
6. **Models are `freezed`.** No hand-written `copyWith`, `==`, `toJson`.
7. **Every screen handles 3 states:** loading, error, data. Use `AsyncValue.when`.
8. **Business rules live in pure Dart functions** (no Flutter, no Firebase
   import) so they can be unit tested. See section 8.
9. **`flutter analyze` must be clean** and code must be `dart format`-ed
   before every commit. No `// ignore:` without a comment explaining why.
10. **English only** in code, comments, commits, and docs. Vietnamese is
    allowed only in user-facing strings.

---

## 2. Folder structure

```text
lib/
├── main.dart                     # Firebase.initializeApp + runApp(ProviderScope(child: App()))
├── app.dart                      # MaterialApp.router(routerConfig, theme)
├── core/
│   ├── router/
│   │   ├── app_router.dart       # GoRouter + redirect (role guard)
│   │   └── routes.dart           # const route paths, no magic strings
│   ├── theme/app_theme.dart
│   ├── utils/
│   │   ├── format.dart           # formatVnd, formatDate
│   │   ├── validators.dart       # required, email, phone
│   │   └── timestamp_converter.dart
│   ├── firebase/firestore_refs.dart   # typed collection refs, one place
│   └── widgets/                  # AppButton, EmptyState, LoadingView, ErrorView
├── models/                       # freezed models: user.dart, product.dart, order.dart ...
└── features/
    └── <module>/                 # auth, staff, menu, inventory, pos, barista, customer, reports, loyalty
        ├── data/
        │   └── <module>_repository.dart
        ├── application/
        │   └── <module>_providers.dart        # + <name>_controller.dart if needed
        └── presentation/
            ├── <screen>_screen.dart           # one screen = one file
            └── widgets/                       # widgets used only by this feature
```

What goes where:

| Layer | Contains | Must NOT contain |
|---|---|---|
| `data/` | Repository classes, Firestore queries, `runTransaction` | Widgets, `BuildContext`, business decisions |
| `application/` | Riverpod providers, `AsyncNotifier` controllers, pure business functions | Widgets, Firestore calls |
| `presentation/` | Screens and widgets, `ref.watch`, navigation | Firestore calls, price math, validation logic |
| `models/` | freezed data classes + `fromJson` / `toJson` | Anything with side effects |

---

## 3. Naming

| Thing | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `order_editor_screen.dart` |
| Classes | `PascalCase` | `OrderEditorScreen` |
| Screen widget | `<Name>Screen` | `LoginScreen`, `TableMapScreen` |
| Reusable widget | `<Name>` or `<Name>Card`, `<Name>Tile` | `ProductCard`, `OrderItemTile` |
| Repository | `<Module>Repository` | `MenuRepository` |
| Provider (data stream/list) | `<things>Provider` | `productsProvider`, `currentUserProvider` |
| Provider (repository) | `<module>RepositoryProvider` | `menuRepositoryProvider` |
| Controller (mutations) | `<Name>Controller` + `<name>ControllerProvider` | `OrderEditorController` |
| Model | Singular noun | `Product`, `Order`, `OrderItem` |
| Enum | `PascalCase` type, `camelCase` values | `OrderStatus.preparing` |
| Route constants | `Routes.<name>` | `Routes.posOrder` |
| Booleans | `is`/`has`/`can` prefix | `isAvailable`, `canCancel` |
| Firestore field names | `camelCase`, must match `docs/product-brief.md` §9.2 exactly | `basePrice`, `createdAt` |

---

## 4. Pattern: Model (`lib/models/`)

Requires `freezed_annotation`, `json_annotation`; dev: `build_runner`, `freezed`, `json_serializable`.

```dart
// lib/models/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    required String name,
    @Default('') String description,
    required int basePrice,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default([]) List<ProductSize> sizes,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
abstract class ProductSize with _$ProductSize {
  const factory ProductSize({required String code, required int priceDelta}) = _ProductSize;
  factory ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);
}
```

Rules:
- `id` is always the Firestore document id. It is **not** stored inside the
  document. Repository adds it when reading (`fromJson({...doc.data()!, 'id': doc.id})`)
  and strips it when writing (`toJson()..remove('id')`).
- Timestamps: annotate with `@TimestampConverter()` (see `core/utils/timestamp_converter.dart`).
- Enums stored as strings: `@JsonEnum()` + `@JsonValue('preparing')` on each value.
- After editing a model run:
  `dart run build_runner build --delete-conflicting-outputs`
- Generated `*.freezed.dart` / `*.g.dart` files **are committed**.

```dart
// lib/core/utils/timestamp_converter.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp json) => json.toDate();
  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object);
}
```

---

## 5. Pattern: Repository (`features/<module>/data/`)

One class per module. Methods return `Stream<T>` for things the UI watches
live, `Future<T>` for one-shot reads and all writes. No business logic here,
only I/O.

```dart
// lib/features/menu/data/menu_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/product.dart';

class MenuRepository {
  MenuRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _products => _db.collection('products');

  Stream<List<Product>> watchProducts() => _products
      .orderBy('name')
      .snapshots()
      .map((snap) => snap.docs.map(_fromDoc).toList());

  Future<Product?> getProduct(String id) async {
    final doc = await _products.doc(id).get();
    return doc.exists ? _fromDoc(doc) : null;
  }

  Future<void> saveProduct(Product product) =>
      _products.doc(product.id).set(product.toJson()..remove('id'));

  Future<void> setAvailability(String id, bool isAvailable) =>
      _products.doc(id).update({'isAvailable': isAvailable});

  Product _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Product.fromJson({...doc.data()!, 'id': doc.id});
}
```

Rules:
- Constructor takes `FirebaseFirestore` (and `FirebaseAuth` if needed) so tests
  can pass `FakeFirebaseFirestore`.
- Multi-document writes that must succeed together → `_db.runTransaction` or
  `_db.batch()`. Never a chain of separate `await`s.
- Let Firebase exceptions bubble up. The controller/UI decides what to show.

---

## 6. Pattern: Providers & controllers (`features/<module>/application/`)

Use plain Riverpod (no `riverpod_generator`). Three provider kinds only:

```dart
// lib/features/menu/application/menu_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/product.dart';
import '../data/menu_repository.dart';

// 1. Repository provider: one per module, never autoDispose.
final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepository(FirebaseFirestore.instance),
);

// 2. Read providers: StreamProvider / FutureProvider. UI only watches these.
final productsProvider = StreamProvider.autoDispose<List<Product>>(
  (ref) => ref.watch(menuRepositoryProvider).watchProducts(),
);

final productProvider = FutureProvider.autoDispose.family<Product?, String>(
  (ref, id) => ref.watch(menuRepositoryProvider).getProduct(id),
);

// 3. Derived providers: pure transforms of other providers.
final availableProductsProvider = Provider.autoDispose<List<Product>>((ref) {
  final products = ref.watch(productsProvider).value ?? [];
  return products.where((p) => p.isAvailable).toList();
});
```

Writes (create / update / delete / submit) go through a controller so the UI
gets loading + error state for free:

```dart
// lib/features/menu/application/product_form_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/product.dart';
import 'menu_providers.dart';

class ProductFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> save(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(menuRepositoryProvider).saveProduct(product),
    );
    return !state.hasError;
  }
}

final productFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProductFormController, void>(
  ProductFormController.new,
);
```

Rules:
- `ref.watch` in `build()` and in widgets. `ref.read` only inside callbacks
  (`onPressed`, controller methods).
- Controller methods return `bool` (success) so the screen can decide whether
  to pop / navigate. The screen never catches exceptions itself.
- Pure business functions (price total, points earned, status transitions)
  go in `application/<module>_rules.dart` as top-level functions. No `ref`,
  no Firebase. See section 8.

---

## 7. Pattern: Screen (`features/<module>/presentation/`)

```dart
// lib/features/menu/presentation/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../application/menu_providers.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.productForm('new')),
        child: const Icon(Icons.add),
      ),
      body: products.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(productsProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'No products yet')
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => ProductCard(product: items[i]),
              ),
      ),
    );
  }
}
```

Submitting from a form:

```dart
// inside a ConsumerWidget / ConsumerState
final isSaving = ref.watch(productFormControllerProvider).isLoading;

ref.listen(productFormControllerProvider, (_, next) {
  if (next.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error.toString())),
    );
  }
});

ElevatedButton(
  onPressed: isSaving
      ? null
      : () async {
          if (!_formKey.currentState!.validate()) return;
          final ok = await ref.read(productFormControllerProvider.notifier).save(product);
          if (ok && context.mounted) context.pop();
        },
  child: isSaving ? const CircularProgressIndicator() : const Text('Save'),
)
```

Rules:
- `ConsumerWidget` by default. `ConsumerStatefulWidget` only when you need
  `TextEditingController`, `FormKey`, animation, or `initState`.
- A screen file over ~250 lines → extract widgets into `presentation/widgets/`.
- Always `const` constructors where possible (the linter will tell you).
- Text shown to users: hardcoded Vietnamese strings are OK for now (no i18n
  package). Keep them in the widget, not in providers.
- Navigation: `context.push(Routes.x)` / `context.go(Routes.x)`. Never
  `Navigator.push` with a `MaterialPageRoute`.
- Check `context.mounted` after every `await` before using `context`.

---

## 8. Pattern: Business rules (pure functions + tests)

Every rule in `docs/product-brief.md` §11 becomes one pure function and at
least one test. Pure means: Dart only, deterministic, no I/O.

```dart
// lib/features/pos/application/pos_rules.dart
import '../../../models/order.dart';

int calcSubtotal(List<OrderItem> items) =>
    items.fold(0, (sum, item) => sum + item.unitPrice * item.qty);

int calcPointsEarned({required int total, required int pointsPerVnd}) =>
    total ~/ pointsPerVnd;

/// Allowed status transitions. Anything not listed is rejected.
const allowedTransitions = <OrderStatus, Set<OrderStatus>>{
  OrderStatus.pending: {OrderStatus.preparing, OrderStatus.cancelled},
  OrderStatus.preparing: {OrderStatus.ready, OrderStatus.cancelled},
  OrderStatus.ready: {OrderStatus.served},
  OrderStatus.served: {OrderStatus.paid},
  OrderStatus.paid: {},
  OrderStatus.cancelled: {},
};

bool canTransition(OrderStatus from, OrderStatus to) =>
    allowedTransitions[from]?.contains(to) ?? false;
```

```dart
// test/features/pos/pos_rules_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cafe_shop_management_system/features/pos/application/pos_rules.dart';
import 'package:cafe_shop_management_system/models/order.dart';

void main() {
  test('paid order cannot change status', () {
    expect(canTransition(OrderStatus.paid, OrderStatus.pending), isFalse);
  });

  test('points earned rounds down', () {
    expect(calcPointsEarned(total: 25000, pointsPerVnd: 10000), 2);
  });
}
```

Test layout mirrors `lib/`: `test/features/<module>/...`, `test/models/...`.

---

## 9. Routing (`core/router/`)

```dart
// lib/core/router/routes.dart
abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const manager = '/manager';
  static const managerMenu = '/manager/menu';
  static String productForm(String id) => '/manager/menu/$id';
  static const pos = '/pos';
  static String posOrder(String id) => '/pos/order/$id';
  static const barista = '/barista';
}
```

- Route paths come from `docs/product-brief.md` §8. Add the constant here first,
  then the `GoRoute` in `app_router.dart`, then the screen.
- Role guard is a single `redirect` in `app_router.dart` that reads
  `currentUserProvider`. Screens never check roles themselves.
- Screen owners add their own `GoRoute` entries; keep them grouped by module
  with a comment header to reduce merge conflicts.

---

## 10. Formatting & shared helpers (`core/utils/`)

```dart
// lib/core/utils/format.dart
import 'package:intl/intl.dart';

final _vnd = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
String formatVnd(int amount) => _vnd.format(amount);

final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
String formatDateTime(DateTime d) => _dateTime.format(d);
```

Before writing a helper, grep `core/` first. If two features need the same
widget or function, move it to `core/` in its own PR.

---

## 11. Error handling

| Where | What to do |
|---|---|
| Repository | Let exceptions propagate. Do not catch. |
| Controller | `AsyncValue.guard` captures them into `state`. |
| Screen | `ref.listen` on the controller → `SnackBar`. Read providers → `ErrorView` with retry. |
| Validation | `validators.dart` functions on `TextFormField.validator`. Show inline, not in a dialog. |

Never `print()`. Use `debugPrint()` only while developing and remove it
before the PR.

---

## 12. Git & PR workflow

- Branch: `feat/<module>-<short-desc>`, e.g. `feat/pos-order-editor`,
  `fix/menu-price-format`. Branch from `main`, keep it under ~3 days.
- Commits: Conventional Commits. `feat(pos): add order editor screen`,
  `fix(menu): use int for basePrice`, `test(pos): cover status transitions`.
- PR title includes the requirement id: `[FR-POS-03] Create order`.
- PR checklist (copy into the description):

```text
- [ ] flutter analyze: 0 issues
- [ ] dart format .
- [ ] build_runner ran, generated files committed (if models changed)
- [ ] New business rules have a unit test
- [ ] Screen handles loading / error / empty
- [ ] No Firebase calls outside data/
- [ ] Route constant added to routes.dart (if new screen)
```

- One reviewer approves before merge. Squash merge.
- Never commit `google-services.json` / `GoogleService-Info.plist` secrets to a
  public repo; they are in `.gitignore`.

---

## 13. Checklist: adding a new screen end-to-end

1. Find the screen and route in `docs/product-brief.md` §8.
2. Model exists in `lib/models/`? If not, add it (section 4) and run build_runner.
3. Add repository methods in `features/<module>/data/` (section 5).
4. Add providers / controller in `application/` (section 6).
5. Add route constant in `core/router/routes.dart`, `GoRoute` in `app_router.dart`.
6. Build the screen in `presentation/` (section 7), handling loading / error / empty.
7. Write tests for any pure rule you added (section 8).
8. `flutter analyze && dart format . && flutter test`, then open the PR.

---

## 14. Things you will be asked to change in review

- `double` for money → `int`.
- `FirebaseFirestore.instance` inside a widget → move to repository.
- `setState` for server data → provider.
- `Navigator.push(MaterialPageRoute(...))` → `context.push(Routes.x)`.
- Try/catch inside a screen → controller with `AsyncValue.guard`.
- A 400-line screen file → split into `widgets/`.
- Business math inside `build()` → pure function in `application/<module>_rules.dart` + test.
- Hardcoded route string `'/pos/order/abc'` → `Routes.posOrder(id)`.
- Missing `const` → add it.
- Vietnamese identifiers or comments → English.
