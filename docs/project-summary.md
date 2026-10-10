# ສະຫຼຸບ Project: `learn_app` (Flutter E-commerce)

> ແອັບ **Flutter** ຕົວຢ່າງຮ້ານຄ້າອອນລາຍ: login → ເບິ່ງສິນຄ້າ → ກະຕ່າ → profile
> ໃຊ້ສະຖາປັດຕະຍະກຳແບບ **Layered + Provider (State Management)**

---

## 1. ພາບລວມ: ແຕ່ລະຟ່າຍ (Layers)

ແອັບແບ່ງອອກເປັນ **4 ຊັ້ນ** ທີ່ຕໍ່ກັນຈາກລຸ່ມຂຶ້ນເທິງ:

```
┌──────────────────────────────────────────────────────────┐
│  presentation/pages/     → ໜ້າຈໍ ທີ່ user ເຫັນ (UI)          │
│        ↕ (ຟັງ/ເອີ້ນຜ່ານ)                                    │
│  presentation/providers/ → ຈັດການ state + business (Logic)  │
│        ↕ (ເອີ້ນ)                                            │
│  data/repositories/      → ຕົວກາງຄຸຍກັບ API                  │
│        ↕ (ເອີ້ນ)                                            │
│  core/network/           → ຍິງ HTTP ຈິງ (Dio)                │
└──────────────────────────────────────────────────────────┘
      ↑ ໃຊ້ຮ່ວມ: data/models/, core/constants/, core/storage/,
                 core/theme/, shared/widgets/
```

ໂຄງສ້າງ folder ຕົວຈິງ (ຫຼັງຈັດ clean):

```
lib/
├── main.dart                      ← ຈຸດ start + ລົງທະບຽນ provider
├── core/                          ← ຂອງກາງ ໃຊ້ໄດ້ທົ່ວແອັບ
│   ├── constants/                 (app_color, app_image, data_demo, path_api)
│   ├── network/                   (services.dart — Dio)
│   ├── storage/                   (secure_storage.dart)
│   └── theme/                     (app_theme.dart)
├── data/                          ← ຊັ້ນຂໍ້ມູນ
│   ├── models/                    (6 model: user_model, products_model, ...)
│   └── repositories/              (authen_repository.dart)
├── presentation/                  ← ຊັ້ນ UI + logic
│   ├── pages/                     (splash, login, register, dashboard,
│   │                               home, cart, product_details, ...)
│   │       └── <feature>/components/  ← widget ຍ່ອຍຂອງໜ້ານັ້ນ
│   └── providers/                 (home/, login/ → logic + state)
└── shared/
    └── widgets/                   (my_text_field, my_text_style, alert_loading)
```

**ຫຼັກການສຳຄັນ:** ຊັ້ນເທິງເອີ້ນຊັ້ນລຸ່ມໄດ້ ແຕ່ຊັ້ນລຸ່ມບໍ່ຮູ້ຈັກຊັ້ນເທິງ.
UI ບໍ່ເຄີຍຍິງ API ໂດຍກົງ — ຕ້ອງຜ່ານ **Logic → Repository → Service** ສະເໝີ.

---

## 2. ແຕ່ລະ folder ແຈ້ງລະອຽດ

### `lib/main.dart` — ຈຸດເລີ່ມຕົ້ນ
- `runApp(MyApp())` ເປັນຈຸດ start ຂອງແອັບ.
- ຫໍ່ແອັບດ້ວຍ `MultiProvider` ລົງທະບຽນ 2 provider ໃຫ້ທົ່ວແອັບເຂົ້າເຖິງໄດ້: `HomeLogic` ແລະ `LoginLogic`.
- ຕັ້ງ `home: Splashpage()` → ໜ້າທຳອິດທີ່ເປີດຂຶ້ນ.

### `core/` — ຂອງກາງ ໃຊ້ໄດ້ທົ່ວແອັບ
- **`core/constants/`** — ຄ່າຄົງທີ່:
  - `app_color.dart` — ສີຂອງແອັບ (`AppColors.primaryColor`...)
  - `path_api.dart` — URL ຂອງ API (`baseUrl = dummyjson.com`, path `auth/login`, `users`)
  - `app_image.dart` — path ຮູບພາບ
  - `data_demo.dart` — ຂໍ້ມູນສິນຄ້າ/promotion ປອມ (ໃຊ້ແທນ API ຊົ່ວຄາວ)
- **`core/network/services.dart`** — ຊັ້ນຕິດຕໍ່ network (ຕ່ຳສຸດ):
  - ຫໍ່ library **Dio** ໄວ້ `_request()` ອັນດຽວ ແລ້ວແຕກເປັນ `get/post/update/delete`.
  - ຈັດການ token (`Authorization: Bearer`), timeout, ແລະ **ແປງ error** ເປັນຂໍ້ຄວາມພາສາລາວ.
- **`core/storage/secure_storage.dart`** — ບ່ອນເກັບ token ປອດໄພ (`saveToken/getToken/deleteToken`).
- **`core/theme/app_theme.dart`** — theme ກາງ (`AppTheme.light`) ທີ່ main.dart ເອີ້ນໃຊ້.

### `data/` — ຊັ້ນຂໍ້ມູນ
- **`data/models/`** — ໂຄງສ້າງຂໍ້ມູນ (ແປງ JSON ⇄ Dart object, ມີ `fromJson`/`toJson`):
  - `login_model.dart` — ຂໍ້ມູນ token ຫຼັງ login
  - `user_model.dart` — ຂໍ້ມູນ user (firstName, image...) *(ແກ້ຊື່ຈາກ user_modle)*
  - `products_model.dart` — ສິນຄ້າ (title, price, discount, images...)
  - `cart_model.dart` — 1 ລາຍການໃນກະຕ່າ = `{ qty, product }`
  - `response_api.dart` — ຮູບແບບ response ກາງ `{ message, success, data }`
  - `signup_model.dart` — ຂໍ້ມູນສະໝັກ
- **`data/repositories/authen_repository.dart`** — ຕົວກາງ:
  - ຮັບ `Services` ເຂົ້າມາ (dependency injection).
  - `login()` / `getuser()`: ປະກອບ data → ເອີ້ນ `services.post/get` → ຫໍ່ຜົນເປັນ `ResponseApi`.
  - ໜ້າທີ່: ແຍກ "ຈະຄຸຍກັບ API ແນວໃດ" ອອກຈາກ UI ແລະ Logic.

### `presentation/` — ຊັ້ນ UI + Logic
- **`presentation/providers/<feature>/`** → `xxx_logic.dart` (ສະໝອງ) + `xxx_state.dart` (ຂໍ້ມູນ)
- **`presentation/pages/<feature>/`** → ໜ້າຈໍ
- **`presentation/pages/<feature>/components/`** → widget ຍ່ອຍແຍກຈາກໜ້າຫຼັກ ໃຫ້ອ່ານງ່າຍ

ໜ້າຫຼັກ:

| folder | ໜ້າທີ່ |
|--------|--------|
| `splash/` | ເຊັກ token ຕອນເປີດແອັບ ແລ້ວພາໄປ login ຫຼື dashboard |
| `login/` + `register/` | ເຂົ້າ/ສະໝັກລະບົບ (ມີ provider) |
| `dashboard/` | ໂຄງ `BottomNavigationBar` ສະລັບ 4 ໜ້າ |
| `home/` | ສະແດງ user, slide ໂຄສະນາ, ລາຍການສິນຄ້າ (ມີ provider) |
| `product_details/` | ລາຍລະອຽດສິນຄ້າ + ປຸ່ມ +/- ກະຕ່າ |
| `cart/` | ກະຕ່າສິນຄ້າ + ສະຫຼຸບລາຄາ |
| `category/`, `order/`, `profile/` | ໜ້າປະເພດ, ອໍເດີ, ໂປຣໄຟລ໌ |

### `shared/widgets/` — ຊິ້ນສ່ວນໃຊ້ຊ້ຳ
`my_text_field.dart`, `my_text_style.dart`, `alert_loading.dart` (dialog ກຳລັງໂຫຼດ) — ໃຊ້ໄດ້ທຸກໜ້າ.

---

## 3. ການເຮັດວຽກ: Provider pattern (ຫົວໃຈຂອງແອັບ)

ແຕ່ລະ feature ແຍກເປັນ 3 ສ່ວນ (ຕົວຢ່າງ Home):

```
home_state.dart   →  ເກັບ "ຂໍ້ມູນ" (productList, cartList, status) — ປ່ຽນຜ່ານ copyWith()
home_logic.dart   →  "ສະໝອງ" (extends ChangeNotifier) — ມີ function ປ່ຽນ state ແລ້ວ notifyListeners()
home_page.dart    →  "ໜ້າຈໍ" — Consumer/context.read() ຟັງ logic ແລ້ວ rebuild ເມື່ອ state ປ່ຽນ
```

**ຮອບການເຮັດວຽກ:**
1. UI ເອີ້ນ function ໃນ Logic (ເຊັ່ນ `context.read<HomeLogic>().addToCart(id)`)
2. Logic ປ່ຽນ State ດ້ວຍ `copyWith()` → ສ້າງ state ໃໝ່
3. Logic ເອີ້ນ `notifyListeners()`
4. ທຸກ `Consumer` ທີ່ຟັງ logic ນັ້ນ **rebuild ອັດຕະໂນມັດ** → ໜ້າຈໍ update

---

## 4. ຕົວຢ່າງ flow ຈິງ: ການ Login (ເຊື່ອມທຸກຊັ້ນ)

ນີ້ຄືຕົວຢ່າງທີ່ເຫັນການເຊື່ອມຕໍ່ຂອງ **ທຸກ folder** ພ້ອມກັນ:

```
login_page.dart  (ຜູ້ໃຊ້ກົດ "ເຂົ້າສູ່ລະບົບ")
   │  context.read<LoginLogic>().login(username, password)
   ▼
login_logic.dart ── alertLoading() [shared/widgets/]
   │  authenRepository.login(...)
   ▼
authen_repository.dart  ── ໃຊ້ PathApi.login [core/constants/]
   │  services.post(path, data)
   ▼
services.dart  ── Dio ຍິງ POST ໄປ dummyjson.com ──→ 🌐 API   [core/network/]
   │  ໄດ້ JSON ກັບມາ
   ▼
authen_repository  ── ຫໍ່ເປັນ ResponseApi [data/models/]
   ▼
login_logic ── loginModelFromJson() [data/models/]
   │  ├─ secureStorage.saveToken() [core/storage/]  ← ເກັບ token
   │  ├─ getUser()  ← ດຶງຂໍ້ມູນ user ຕໍ່
   │  └─ copyWith(status: success) + notifyListeners()
   ▼
Navigator → DashboardPage  (ເຂົ້າສູ່ແອັບ)
```

---

## 5. Navigation flow (ການໄຫຼຂອງໜ້າຈໍ)

```
Splash (ເຊັກ token)
   ├─ ບໍ່ມີ token → LoginPage ──(login ສຳເລັດ)──┐
   └─ ມີ token ─────────────────────────────────▼
                                          DashboardPage
                                     (BottomNavigationBar)
                        ┌──────┬────────┬───────┬────────┐
                      Home  Category  Order  Profile
                        │
                   ProductDetails / CartPage
```

---

## 6. ⚠️ ຈຸດທີ່ຄວນລະວັງ (ພົບຕອນອ່ານ code)

1. **`presentation/pages/splash/splash.dart`** — `getToken()` ເປັນ `Future` ແຕ່ບໍ່ໄດ້ `await`, ແລະ function `loginPage()`
   ຍັງ **ຫວ່າງເປົ່າ return null**. ສະນັ້ນຕອນນີ້ມັນຈະເຂົ້າ DashboardPage ສະເໝີ
   (ເພາະ `token == null` ເປັນ false ເພາະ token ເປັນ Future object ບໍ່ແມ່ນ null — analyzer ເຕືອນ dead code).
2. **`presentation/providers/login/login_logic.dart`** — ຕັ້ງ status ເປັນ `error` ກ່ອນເລີ່ມ login (ຄວນເປັນ `loading`).
3. **`core/network/services.dart`** — `baseUrl = 'https://api.com'` ບໍ່ຖືກໃຊ້ຈິງ (repository ສົ່ງ full URL), ອາດສັບສົນພາຍຫຼັງ.

---

## 7. 🔗 ການເຊື່ອມຕໍ່ຂອງແຕ່ລະໜ້າ (ລະອຽດ)

### ຫຼັກການ: ໜ້າຕ່າງໆເຊື່ອມກັນ 2 ແບບ

```
ແບບ A — Navigation (ການຍ້າຍໜ້າ)
   ໃຊ້ Navigator.push / pushAndRemoveUntil
   → ຍ້າຍຈາກໜ້າໜຶ່ງໄປອີກໜ້າ (ບາງເທື່ອສົ່ງຂໍ້ມູນໄປນຳ)

ແບບ B — Shared State / Provider (ສາຍລັບທີ່ເຊື່ອມເຖິງກັນ)   ← ສຳຄັນສຸດ!
   HomeLogic ແລະ LoginLogic ຖືກລົງທະບຽນໃນ main.dart (MultiProvider)
   → ທຸກໜ້າໃຊ້ "instance ດຽວກັນ"
   → ໜ້າໜຶ່ງ "ຂຽນ" state (addToCart) → ໜ້າອື່ນທີ່ "ຟັງ" (watch) rebuild ເອງ
```

**ຈຸດທີ່ມັກເຂົ້າໃຈຜິດ:** Home ກັບ Cart ບໍ່ໄດ້ສົ່ງຂໍ້ມູນຫາກັນຜ່ານ Navigator —
ແຕ່ແບ່ງ `HomeLogic` ອັນດຽວກັນ. ນີ້ຄືສາຍທີ່ເຊື່ອມເຖິງກັນ.

### ການເຊື່ອມຂອງແຕ່ລະໜ້າ

| ຈາກ | ໄປ / ແບ່ງກັບ | ວິທີ | ສົ່ງ/ແບ່ງຫຍັງ |
|-----|--------------|------|----------------|
| `main` | `Splash` | ຫໍ່ MultiProvider | HomeLogic + LoginLogic (ທົ່ວແອັບ) |
| `Splash` | `Login` / `Dashboard` | `pushAndRemoveUntil` (A) | ເຊັກ token ຈາກ SecureStorage |
| `Login` | `Dashboard` | `pushAndRemoveUntil` (A) | ຫຼັງ login → saveToken + getUser |
| `Login` | `Register` | `push` (A) | — |
| `Dashboard` | Home/Category/Order/Profile | `BottomNav` (switch index) | ສ້າງໄວ້ພ້ອມກັນ, ແຄ່ສະລັບການສະແດງ |
| `Home` | `Cart` | `push` (A) ແຕະ badge | — |
| `Home`→`ProductList` | `ProductDetails` | `push(data: item)` (A) | ສົ່ງ `ProductsModel` ໄປ |
| `Home`→`ProductList` | — | `HomeLogic.addToCart(id)` (B) | ຂຽນ cartList |
| `BadgesProduct` | — | `watch<HomeLogic>` (B) | ອ່ານ `cartList.length` |
| `ProductDetails` | — | `addToCart / addQty` (B) | ຂຽນ cartList + selectQty |
| `Cart` | — | `watch<HomeLogic>` (B) | ສະທ້ອນ cartList (+/- , deleteAll) |
| `Profile` | `Login` | `pushAndRemoveUntil` (A) | `LoginLogic.deleteToken()` (logout) |

> `Category` ແລະ `Order` ຕອນນີ້ເປັນໜ້າເປົ່າ (placeholder) ຍັງບໍ່ເຊື່ອມຫຍັງ.

### ແຜນທີ່ການເຊື່ອມທັງໝົດ

```
main → Splash ─┬─(ບໍ່ມີ token)→ Login ──┬─→ Register
               │                        └─(ສຳເລັດ)→ Dashboard
               └─(ມີ token)──────────────────────→ Dashboard
                                                      │ (BottomNav)
                        ┌──────────┬──────────┬───────┴──────┐
                      Home      Category    Order         Profile
                        │                                    │
          ┌─────────────┼─────────────┐                 (logout)→ Login
          ▼             ▼             │
    ProductDetails    Cart ◀──────────┘ (ແຕະ badge)
          │             ▲
          └─────────────┘  * ທັງ Home/ProductDetails/Cart/Badge
             ແບ່ງ HomeLogic.cartList ອັນດຽວກັນ (ການແບ່ງ = ແບບ B)
```

**ເສັ້ນທຶບ** = Navigation (ແບບ A) · **ການແບ່ງ cartList** = Shared State (ແບບ B)

### ຕົວຢ່າງຈິງ: "ເພີ່ມສິນຄ້າ 1 ອັນ" (ເຫັນແບບ B ຊັດໆ)

```
1. ຢູ່ Home ແຕະປຸ່ມກະຕ່າ → ProductList ເອີ້ນ HomeLogic.addToCart(id)
2. HomeLogic ແກ້ cartList → notifyListeners()
3. ພ້ອມກັນ 3 ບ່ອນ rebuild ອັດຕະໂນມັດ (ບໍ່ຕ້ອງ refresh):
   • BadgesProduct → ຕົວເລກ +1
   • CartPage (ຖ້າເປີດຢູ່) → ມີ item ເພີ່ມ
   • CartBottomBar → total ປ່ຽນ
```

👉 ບໍ່ມີການສົ່ງຂໍ້ມູນຜ່ານ Navigator ເລີຍ — ທຸກຢ່າງເຊື່ອມຜ່ານ **`HomeLogic` ອັນດຽວ**.

> ⚠️ *ໝາຍເຫດ:* ປຸ່ມ logout ຢູ່ `profile_page.dart` ເອີ້ນ `loginPage()` ທີ່ return ຫວ່າງ
> (ຄືກັບ `splash.dart`) → ຕອນນີ້ logout ຍັງບໍ່ພາກັບໄປໜ້າ Login ຈິງ. ເບິ່ງຂໍ້ 6.

---

*ສ້າງໂດຍ Claude Code · ວັນທີ 2026-10-05*
