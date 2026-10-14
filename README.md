# Threadline – E-Commerce Clothing App (Flutter)

A Flutter e-commerce app for a clothing brand, built for the Flutter Developer technical assessment.
It follows **Clean Architecture** with **BLoC (explicit Events & States)**, **dedicated use cases**, and the **repository pattern**. Products are loaded from local JSON; cart and watchlist live in memory.

| Module | What it does |
|---|---|
| Login | Live email/password validation, button enabled only when valid, dummy auth, error messages |
| Products | 12 products from `assets/data/products.json`, typed models, loading / success / empty / error states |
| Watchlist | Add/remove via heart icon, dedicated screen, synced with the catalogue, empty state |
| Cart | Add, remove, +/- quantity, live total and item count (badge), empty state, clear cart |
| Payment | Checkout summary, Pay Now with loading overlay, success screen with order ID, cart cleared |

**Demo login:** `demo@shop.com` / `Password@123`

## 📱 App Demo

## Demo

🎥 [Watch demo video](https://drive.google.com/file/d/1ygeSkaAsWrYJJxKXLcofLfcnzHQSXI-W/view?usp=sharing)

📥 [Download video](https://drive.google.com/uc?export=download&id=1ygeSkaAsWrYJJxKXLcofLfcnzHQSXI-W)

## ⬇️ Download the App

<p align="center">
  <a href="assets/readme/shopping.apk">
    <img src="https://img.shields.io/badge/Download-Android%20APK-2E7D32?style=for-the-badge&logo=android&logoColor=white" alt="Download Android APK">
  </a>
</p>
---

## 1. Setup

Requirements: Flutter 3.22+ (Dart 3.3+).

```bash
git clone https://github.com/sndp0816/clothing_store
cd clothing_store

# Generate the platform folders (android/, ios/, web/...) if they are not in the repo.
# Existing files (lib/, test/, pubspec.yaml) are NOT overwritten.
flutter create . --project-name clothing_store

flutter pub get
flutter test          # run all unit + widget tests
flutter run           # launch on a device / emulator
```

> Product images are loaded from `picsum.photos`, so the device needs internet for images. Offline, a placeholder is shown. To use your own images, put them in `assets/images/`, add that folder under `flutter: assets:` in `pubspec.yaml`, and set `"image_url": "assets/images/xyz.jpg"` in the JSON — `ProductImage` loads asset paths automatically.

---

## 2. Architecture

```
Presentation (Pages, Widgets)
        │  dispatches Events / renders States
        ▼
BLoC (Events & States)
        │  calls
        ▼
Use Cases               ← business rules live here
        │  depend on
        ▼
Repository Interfaces   ← domain layer (abstract)
        ▲  implemented by
        │
Repository Implementations  ← data layer, maps exceptions → Failures, models → entities
        │
        ▼
Local Data Sources
        │
        ▼
Local JSON (products) / In-memory Maps (cart, watchlist)
```

### Folder structure (feature-first)

```
lib/
├── main.dart                     # bootstraps DI and runs the app
├── app.dart                      # global Cart & Watchlist BlocProviders + MaterialApp
├── injection_container.dart      # get_it wiring: data sources → repos → use cases → blocs
├── core/
│   ├── bloc/event_transformers.dart   # sequential() transformer
│   ├── constants/  error/  theme/  usecases/  utils/
│   └── widgets/                  # PrimaryButton, StateMessage, LoadingView, ProductImage...
└── features/
    ├── auth/  products/  watchlist/  cart/  payment/  home/
    │   ├── domain/        entities · repositories (abstract) · usecases
    │   ├── data/          models · datasources · repositories (impl)
    │   └── presentation/  bloc · pages · widgets
```

### Layer responsibilities

**Domain** (pure Dart, no Flutter imports): entities (`Product`, `Cart`, `CartItem`, `User`, `PaymentResult`), repository interfaces, and use cases. Business rules live here — e.g. "a product can't appear twice in the watchlist", "max 10 units per item", "quantity 0 removes the item", "can't pay for an empty cart". Cart totals are derived getters on the `Cart` entity, so they can never drift out of sync.

**Data**: models (`ProductModel.fromJson`, `toEntity()`), data sources (JSON asset reader, in-memory maps, simulated auth/payment), and repository implementations. Repositories catch exceptions and return `Either<Failure, T>` (dartz), so upper layers never deal with raw exceptions.

**Presentation**: pages and reusable widgets. Widgets only dispatch events and render states. `ProductCard` is a pure widget (data + callbacks); `ProductGrid` connects it to the BLoCs and is reused by both the catalogue and the watchlist screen.

### Key design decisions

- **State sync across screens:** `CartBloc` and `WatchlistBloc` are provided *above* `MaterialApp`, so every route reads the same instance. The heart on the catalogue, the watchlist screen, the cart badge and the checkout all render from one source of truth.
- **Fine-grained rebuilds:** each product card uses `context.select` to rebuild only when *its* favourite flag or cart quantity changes.
- **Sequential event processing:** Cart and Watchlist BLoCs register one handler with a `sequential()` transformer, so rapid taps (e.g. hitting "+" quickly) are processed in order and never read stale state.
- **No BLoC-to-BLoC dependencies:** after a successful payment, the checkout page's `BlocListener` dispatches `ClearCart` to `CartBloc`. Coordination stays in the presentation layer.
- **Models vs entities:** JSON concerns stay in data models; the domain only sees entities. Swapping the in-memory source for Hive/SQLite/REST touches only the data layer.
- **Dependency injection:** `get_it`; repositories are registered against their interfaces, BLoCs are factories.

---

## 3. BLoC Events, States & Use Cases

### Auth — `LoginBloc`
| Events | State |
|---|---|
| `LoginEmailChanged`, `LoginPasswordChanged`, `LoginSubmitted` | `LoginState { email, password, emailError, passwordError, status: initial/submitting/success/failure, errorMessage, user }` + `isFormValid` getter |

Use case: **`LoginUseCase`** — normalises email, validates both fields, then calls `AuthRepository.login`.

### Products — `ProductBloc`
| Events | States |
|---|---|
| `LoadProducts` | `ProductInitial`, `ProductLoading`, `ProductLoaded(products)`, `ProductEmpty`, `ProductError(message)` |

Use case: **`GetProductsUseCase`**.

### Watchlist — `WatchlistBloc` (app-wide)
| Events | State |
|---|---|
| `LoadWatchlist`, `AddToWatchlist`, `RemoveFromWatchlist`, `ToggleWatchlist` (extra, for the heart icon) | `WatchlistState { status: initial/loading/loaded/failure, items, errorMessage }` + `contains(id)` |

Use cases: **`GetWatchlistUseCase`**, **`AddToWatchlistUseCase`** (prevents duplicates), **`RemoveFromWatchlistUseCase`**.

### Cart — `CartBloc` (app-wide)
| Events | State |
|---|---|
| `LoadCart`, `AddToCart`, `RemoveFromCart`, `IncreaseQuantity`, `DecreaseQuantity`, `ClearCart` | `CartState { status: initial/loading/loaded/failure, cart, errorMessage }` — `cart.totalItems`, `cart.totalAmount` |

Use cases: **`GetCartUseCase`**, **`AddToCartUseCase`** (insert or increment, max 10), **`RemoveFromCartUseCase`**, **`UpdateCartQuantityUseCase`** (0 removes, >10 rejected), **`ClearCartUseCase`**.

### Payment — `PaymentBloc` (scoped to checkout)
| Events | States |
|---|---|
| `InitiatePayment(amount, itemCount)` | `PaymentInitial`, `PaymentProcessing`, `PaymentSuccess(result)`, `PaymentError(message)` |

Use case: **`ProcessDummyPaymentUseCase`** — rejects empty orders, simulates a 2-second gateway, returns a generated order ID.

---

## 4. Error handling

| Where | How |
|---|---|
| Data sources | Throw typed exceptions (`DataSourceException`, `InvalidCredentialsException`, `PaymentException`) |
| Repositories | Catch and return `Left(Failure)` |
| Use cases | Return `Left(ValidationFailure / CartFailure)` for rule violations |
| BLoCs | Map failures to explicit failure/error states |
| UI | Error views with retry (products, cart, watchlist), inline login error, snackbars for cart/watchlist/payment errors |

To see the empty and error states for products: edit `assets/data/products.json` to `{"products": []}` (empty) or break the JSON syntax (error), then hot restart.

---

## 5. Tests

```bash
flutter test
```

| File | Covers |
|---|---|
| `test/core/utils/validators_test.dart` | Email and password validation rules |
| `test/features/auth/login_usecase_test.dart` | Validation guard, email normalisation, repository delegation (mocktail) |
| `test/features/auth/login_bloc_test.dart` | Field errors, form validity, submit success/failure (bloc_test) |
| `test/features/cart/cart_total_test.dart` | Cart total & item count calculation |
| `test/features/cart/cart_usecases_test.dart` | Increment vs insert, quantity limits, remove, clear |
| `test/features/cart/cart_bloc_test.dart` | Event sequence → state & totals |
| `test/features/watchlist/watchlist_test.dart` | Add, remove, no duplicates, toggle sync, rapid taps |
| `test/features/products/product_model_test.dart` | JSON → typed model parsing |
| `test/features/payment/payment_usecase_test.dart` | Empty-cart guard, order ID generation |
| `test/widget_test.dart` | Reusable `ProductCard` renders and fires callbacks |

---

## 6. Packages

`flutter_bloc`, `equatable`, `dartz` (Either), `get_it` (DI) · dev: `bloc_test`, `mocktail`, `flutter_lints`.

## 7. Possible improvements

Persist cart/watchlist with Hive or SharedPreferences (data layer only), routing with `go_router`, product detail screen with size selection, search and category filters, golden tests, and dark theme.
