# BNPL App

A Flutter app for **Buy Now, Pay Later** (BNPL): browse products, choose installment plans, and complete orders with card and biometric authentication.

## Setup

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK ^3.41.4)

### Running the app

1. **Clone and enter the project**
   ```bash
   git clone <repo-url>
   cd bnpl_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Copy `.env`:
     - `BASE_URL` – API base URL for the BNPL backend

4. **Run**
   ```bash
   flutter run
   ```

### Running tests

```bash
flutter test
```

### Lint and format

The project uses [very_good_analysis](https://pub.dev/packages/very_good_analysis). To analyze and format:

```bash
flutter analyze
dart format .
```

---

## Architecture

- **Clean Architecture** with clear layers:
  - **Presentation**: Flutter UI + BLoC for state.
  - **Domain**: Entities, repository interfaces, use cases (no Flutter).
  - **Data**: Repositories implementation, data sources (remote + local cache), DTOs/models.

- **Dependency injection**: [get_it](https://pub.dev/packages/get_it) in `lib/di/di.dart`; async init for `SharedPreferences` and registration of repositories, data sources, use cases, and BLoCs.

- **Routing**: [go_router](https://pub.dev/packages/go_router) with a single `AppRouter` and named routes; deep links and shell (tabs) for Products and Orders.

- **Errors**: Domain and data layers use [dartz](https://pub.dev/packages/dartz) `Either<AppException, T>`; presentation maps failures to UI (e.g. snackbars, retry).

---

## Why BLoC for state management

- **Testability**: BLoC holds business logic in one place; events and states are easy to unit test without the UI.
- **Predictable flow**: Single direction (events → bloc → states) makes behavior and debugging straightforward.
- **Separation of concerns**: UI only listens to states and dispatches events; logic stays in the bloc.
- **Ecosystem**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) fits well with Clean Architecture and is widely used in production Flutter apps.

---

## Accessibility

- **Semantics**: Buttons and interactive elements rely on Flutter’s default semantics (e.g. `ElevatedButton`, `BottomNavigationBar`). Labels and icons are set so screen readers can describe actions (e.g. “Products”, “Orders”, “Buy Now, Pay Later”).
- **Touch targets**: Layout uses `flutter_screenutil` for responsive sizing; primary actions use full-width or large buttons to keep touch targets usable.
- **Contrast**: Material theme and primary colors are used consistently; no custom low-contrast combinations.
- **Future work**: Explicit `Semantics` widgets and `semanticsLabel`/`hint` can be added where default labels are insufficient (e.g. custom cards, images, or complex list items).

---

## Linting: very_good_analysis

The project uses **very_good_analysis** as the lint rule set (see `analysis_options.yaml`). It provides:

- Stricter style and consistency (formatting, naming, documentation).
- Fewer bugs (null safety, unnecessary code, error handling).
- Better maintainability (single responsibility, avoid redundant code).

Some rules are relaxed in `analysis_options.yaml` (e.g. `public_member_api_docs: false`) to suit the project; the rest follow the package’s recommendations.

---

## Known limitations

- **Auth**: Biometric (e.g. fingerprint/face) is used for order confirmation; there is no full login/session flow.
- **Offline**: Limited offline support via local cache (e.g. last products/orders); not all flows are fully offline-capable.
- **Platform**: Developed and tested primarily for mobile (iOS/Android); web/desktop may need extra layout and env checks.

---

## CI

GitHub Actions runs on every push and pull request to `main`/`master`:

- Checkout, Flutter setup (stable), dependency install.
- `dart format .`
- `flutter analyze`
- ` flutter test 
            test/domain/usecases/get_all_products_test.dart 
            test/presentation/products/bloc/products_bloc_test.dart 
            test/presentation/splash/splash_view_test.dart`

Workflow file: [.github/workflows/ci.yml](.github/workflows/ci.yml).
---

## Testing Payment Success

To test a successful payment flow:
- Use any card number starting with **4** (e.g., `4242...`).
- Or use the specific test card: `1111222233334444`.
- Any expiration date and CVV will be accepted for these cards.
