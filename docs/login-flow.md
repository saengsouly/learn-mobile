# ສະຫຼຸບການເຮັດວຽກຂອງລະບົບ Login (ລະອຽດ)

ເອກະສານນີ້ອະທິບາຍ **ແຕ່ລະ file ເຮັດວຽກຫຍັງ** ແລະ **ເຊື່ອມຕໍ່ກັນແນວໃດ** ໃນ flow ການ login
ຂອງແອັບ `learn_app` (ໃຊ້ dummyjson API).

---

## 1. ພາບລວມ (Architecture)

ແອັບນີ້ແບ່ງ code ອອກເປັນ **4 ຊັ້ນ (layers)** ຕາມໜ້າທີ່:

```
┌─────────────────────────────────────────────────────────────┐
│  UI Layer        login_page.dart        (ໜ້າຈໍ + ປຸ່ມ)        │
│                        │                                       │
│                        │ ເອີ້ນຜ່ານ context.read<LoginLogic>()  │
│                        ▼                                       │
│  Logic Layer     login_logic.dart       (ChangeNotifier)      │
│                  login_state.dart       (ເກັບ state)          │
│                        │                                       │
│                        │ ເອີ້ນ authenRepository.login()        │
│                        ▼                                       │
│  Data Layer      authen_repository.dart (ຈັດການ API login)    │
│                        │                                       │
│                        │ ເອີ້ນ services.post()                 │
│                        ▼                                       │
│  Network Layer   services.dart          (Dio HTTP client)     │
│                  path_api.dart          (URL endpoints)       │
│                        │                                       │
│                        ▼                                       │
│                   🌐 dummyjson.com/auth/login                  │
└─────────────────────────────────────────────────────────────┘
```

**ຫຼັກການ:** ແຕ່ລະຊັ້ນຮູ້ຈັກສະເພາະຊັ້ນທີ່ຢູ່ຕິດກັນລຸ່ມມັນເທົ່ານັ້ນ — UI ບໍ່ຍິງ API ໂດຍກົງ,
ແຕ່ສົ່ງຜ່ານ Logic → Repository → Services. ແບບນີ້ແກ້/ທົດສອບງ່າຍ ແລະ ແຍກໜ້າທີ່ຊັດເຈນ.

---

## 2. ແຕ່ລະ file ເຮັດວຽກຫຍັງ

### 2.1 `lib/main.dart` — ຈຸດເລີ່ມຕົ້ນ + ລົງທະບຽນ Provider

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => HomeLogic()),
    ChangeNotifierProvider(create: (context) => LoginLogic()),  // ← ສ້າງ LoginLogic ໃຫ້ທັງແອັບໃຊ້ຮ່ວມ
  ],
  child: MaterialApp(
    home: LoginPage(),   // ← ໜ້າທຳອິດ
  ),
)
```

- ຫໍ່ແອັບທັງໝົດດ້ວຍ `MultiProvider` ເພື່ອໃຫ້ທຸກໜ້າເຂົ້າເຖິງ `LoginLogic` ໄດ້.
- `ChangeNotifierProvider` ສ້າງ object `LoginLogic` 1 ຕົວ ແລະ ແບ່ງປັນໃຫ້ widget ລູກ.
- ໜ້າທຳອິດທີ່ສະແດງຄື `LoginPage`.

---

### 2.2 `lib/pages/login/login_page.dart` — ຊັ້ນ UI (ໜ້າຈໍ)

ໜ້າ login ທີ່ຜູ້ໃຊ້ເຫັນ. ສ່ວນສຳຄັນ:

**(ກ) ຮັບຄ່າ input ດ້ວຍ Controller**
```dart
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
```
- `_emailController` / `_passwordController` ເກັບຂໍ້ຄວາມທີ່ພິມ.
- `_formKey` ໃຊ້ກວດ validation (ວ່າງ ຫຼື ບໍ່).

**(ຂ) ຊ່ອງ password ຫໍ່ດ້ວຍ `Consumer<LoginLogic>`**
```dart
Consumer<LoginLogic>(
  builder: (context, loginState, child) {
    final state = loginState.loginState;
    return TextFormField(
      obscureText: state.isShowpassword,       // ← ເຊື່ອງ/ສະແດງ password ຕາມ state
      suffixIcon: GestureDetector(
        onTap: () {
          loginState.changePassword(            // ← ສັ່ງ Logic ສະຫຼັບ show/hide
            isShowPassword: state.isShowpassword ? false : true,
          );
        },
        ...
      ),
    );
  },
)
```
- `Consumer` ຈະ **rebuild ສະເພາະສ່ວນນີ້** ເມື່ອ state ປ່ຽນ (ບໍ່ rebuild ໝົດໜ້າ).
- ກົດ icon ຕາ → ເອີ້ນ `changePassword()` → state ປ່ຽນ → ຊ່ອງ password ສະຫຼັບເຊື່ອງ/ສະແດງ.

**(ຄ) ປຸ່ມ "ເຂົ້າສູ່ລະບົບ"**
```dart
onPressed: () {
  if (_formKey.currentState!.validate()) {        // 1. ກວດວ່າ input ບໍ່ວ່າງ
    context.read<LoginLogic>().login(              // 2. ເອີ້ນ login() ໃນ Logic
      context: context,
      username: _emailController.text,
      password: _passwordController.text,
    );
  }
}
```
- `context.read<LoginLogic>()` = ດຶງ object `LoginLogic` ທີ່ main.dart ສ້າງໄວ້.
- `.read` (ບໍ່ແມ່ນ `.watch`) ເພາະຢູ່ໃນ callback — ເອີ້ນ action ຄັ້ງດຽວ ບໍ່ຕ້ອງ rebuild.

> ⚠️ **ໝາຍເຫດ:** ຊ່ອງນີ້ຊື່ "ອີເມວ" ແຕ່ dummyjson ຕ້ອງການ **username** (ເຊັ່ນ `emilys`),
> ບໍ່ແມ່ນ email. ສົ່ງ `_emailController.text` ໄປເປັນ `username`.

---

### 2.3 `lib/pages/login/provider/login_state.dart` — ຮູບແບບຂອງ State

ເປັນ "ກ່ອງຂໍ້ມູນ" ທີ່ບອກວ່າໜ້າ login ຢູ່ສະຖານະໃດ.

```dart
enum LoginStatus { initial, loading, success, error }   // ສະຖານະ 4 ແບບ

class LoginState {
  LoginStatus loginStatus;    // ກຳລັງຢູ່ສະຖານະໃດ
  bool isShowpassword;        // ສະແດງ password ຫຼືບໍ່
  SignUpModel? signUpModel;   // ຂໍ້ມູນ register
  LoginModel? loginModel;     // ຂໍ້ມູນ user ຫຼັງ login ສຳເລັດ

  LoginState copyWith({...}) { ... }   // ສ້າງ state ໃໝ່ ໂດຍແກ້ສະເພາະ field ທີ່ຕ້ອງການ
}
```

**ຈຸດສຳຄັນ — `copyWith`:** ໃນ Flutter state ຄວນ *immutable* (ບໍ່ແກ້ຂອງເກົ່າໂດຍກົງ).
`copyWith` ຈະ copy state ເກົ່າ ແລ້ວປ່ຽນສະເພາະ field ທີ່ສົ່ງເຂົ້າ — ທີ່ເຫຼືອຄົງເດີມ.
```dart
loginState.copyWith(loginStatus: LoginStatus.success)
// → ໄດ້ state ໃໝ່: status=success, field ອື່ນ (isShowpassword ຯລຯ) ຍັງຄືເກົ່າ
```

---

### 2.4 `lib/pages/login/provider/login_logic.dart` — ຊັ້ນ Logic (ສະໝອງ)

ຫົວໃຈຂອງການຈັດການ. ເປັນ `ChangeNotifier` — ເມື່ອ state ປ່ຽນ ຈະແຈ້ງ UI ໃຫ້ rebuild.

```dart
class LoginLogic extends ChangeNotifier {
  LoginState _loginState = LoginState.initial();   // state ປັດຈຸບັນ (private)
  LoginState get loginState => _loginState;         // ໃຫ້ UI ອ່ານໄດ້

  // ສ້າງ Repository ໄວ້ຍິງ API
  AuthenRepository authenRepository = AuthenRepository(services: Services());

  // ສະຫຼັບເຊື່ອງ/ສະແດງ password
  void changePassword({required bool isShowPassword}) {
    _loginState = loginState.copyWith(isShowpassword: isShowPassword);
    notifyListeners();   // ← ແຈ້ງ Consumer ໃຫ້ rebuild
  }

  // ການ login
  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      final resulf = await authenRepository.login(      // 1. ຍິງ API
        username: username,
        password: password,
      );
      if (resulf != null && resulf.success == true) {   // 2. ສຳເລັດ
        final loginData = loginModelFromJson(jsonEncode(resulf.data));
        _loginState = loginState.copyWith(
          loginStatus: LoginStatus.success,
          loginModel: loginData,                         // ເກັບ user ໄວ້ໃນ state
        );
        Navigator.pushAndRemoveUntil(                    // 3. ໄປໜ້າ Dashboard
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false,                              // ລຶບ history ທັງໝົດ (ກັບບໍ່ໄດ້)
        );
      } else {                                           // 2b. ບໍ່ສຳເລັດ
        _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
      }
      notifyListeners();
    } catch (e) {                                        // 4. error (ເຊັ່ນ 400)
      _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
      notifyListeners();
    }
  }
}
```

**ໜ້າທີ່:**
- ເກັບ ແລະ ອັບເດດ `LoginState`.
- ເອີ້ນ `AuthenRepository` ໄປຍິງ API.
- ແປງ JSON ທີ່ໄດ້ຄືນ ເປັນ `LoginModel` (`loginModelFromJson`).
- ຖ້າສຳເລັດ → ໄປ `DashboardPage`; ຖ້າ error → ຕັ້ງ status = error.
- ທຸກຄັ້ງທີ່ state ປ່ຽນ → `notifyListeners()` ໃຫ້ UI ອັບເດດ.

---

### 2.5 `lib/repository/authen_repository.dart` — ຊັ້ນ Data (ຈັດການ login)

ຕົວກາງລະຫວ່າງ Logic ກັບ Services. ຮູ້ວ່າ "login ຕ້ອງຍິງ path ໃດ, ສົ່ງ data ຫຍັງ".

```dart
class AuthenRepository {
  final Services services;
  AuthenRepository({required this.services});

  Future<ResponseApi?> login({
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> data = {'username': username, 'password': password};
    try {
      final response = await services.post(path: PathApi.login, data: data);
      return ResponseApi(message: "ເຂົ້າສູ່ລະບົບສຳເລັດ", data: response.data);
    } catch (e) {
      print('Error in login: $e');
      return ResponseApi(message: e.toString(), success: false, data: null);
    }
  }
}
```

**ໜ້າທີ່:**
- ສ້າງ body `{username, password}`.
- ເອີ້ນ `services.post()` ໄປທີ່ `PathApi.login`.
- ຫໍ່ຜົນລັບເປັນ `ResponseApi` (success / message / data).
- ຖ້າ error → ສົ່ງ `ResponseApi(success: false, ...)` ແທນການ crash.

---

### 2.6 `lib/services/services.dart` — ຊັ້ນ Network (HTTP client)

ໃຊ້ **Dio** ຍິງ HTTP. ເປັນ method ກາງທີ່ທຸກ repository ໃຊ້ຮ່ວມ.

```dart
Future<Response> post({
  required String path,
  String? token,
  Map<String, dynamic>? data,
  bool isForm = false,
}) => _request('POST', path, token: token, data: data, isForm: isForm);
```

- `_request()` ຕັ້ງ header, content-type, ໃສ່ token (ຖ້າມີ), ແລະ ຍິງ request.
- `_handleError()` ແປງ error ຂອງ Dio ເປັນຂໍ້ຄວາມພາສາລາວທີ່ເຂົ້າໃຈງ່າຍ:
  - timeout → "ການເຊື່ອມຕໍ່ໝົດເວລາ"
  - ບໍ່ມີ net → "ບໍ່ມີອິນເຕີເນັດ..."
  - 401 → "ໝົດອາຍຸການເຂົ້າສູ່ລະບົບ"
  - ອື່ນໆ (ເຊັ່ນ 400) → "Server ຜິດພາດ (code): message ຈາກ server"

---

### 2.7 `lib/constants/path_api.dart` — ເກັບ URL endpoints

```dart
class PathApi {
  static const String baseUrl = 'https://dummyjson.com/';
  static const String login = '${baseUrl}auth/login';   // 🌐 endpoint login
}
```
- ເກັບ URL ໄວ້ບ່ອນດຽວ — ປ່ຽນງ່າຍ, ບໍ່ຕ້ອງໄລ່ແກ້ຫຼາຍບ່ອນ.

---

### 2.8 Models — ຮູບແບບຂໍ້ມູນ

**`lib/models/response_api.dart`** — ຮູບແບບກາງຂອງ response ທຸກ API:
```dart
class ResponseApi {
  final String? message;   // ຂໍ້ຄວາມ
  final bool? success;     // ສຳເລັດຫຼືບໍ່
  final dynamic data;      // ຂໍ້ມູນ
}
```

**`lib/models/login_model.dart`** — ຮູບແບບ user ທີ່ dummyjson ສົ່ງຄືນ:
```dart
class LoginModel {
  final String? accessToken;    // token ສຳລັບ auth ຄັ້ງຕໍ່ໄປ
  final String? refreshToken;
  final int? id;
  final String? username, email, firstName, lastName, gender, image;
}
// loginModelFromJson(String) → ແປງ JSON string ເປັນ object LoginModel
```

---

## 3. Flow ການ login ເຕັມ (step-by-step)

```
① ຜູ້ໃຊ້ພິມ username + password → ກົດ "ເຂົ້າສູ່ລະບົບ"
         │
② login_page.dart: _formKey.validate() ກວດວ່າບໍ່ວ່າງ
         │  context.read<LoginLogic>().login(username, password)
         ▼
③ login_logic.dart: login() → authenRepository.login(username, password)
         ▼
④ authen_repository.dart: ສ້າງ {username, password}
         │  services.post(path: PathApi.login, data)
         ▼
⑤ services.dart: Dio ຍິງ POST → https://dummyjson.com/auth/login
         ▼
⑥ 🌐 dummyjson ຕອບກັບ:
         ├─ ສຳເລັດ (200): {accessToken, id, username, ...}
         └─ ຜິດ (400): {message: "Invalid credentials"}
         ▼
⑦ authen_repository: ຫໍ່ເປັນ ResponseApi (success true/false)
         ▼
⑧ login_logic: ກວດ resulf.success
         ├─ true  → ແປງເປັນ LoginModel → state=success
         │          → notifyListeners() → Navigator ໄປ DashboardPage ✅
         └─ false → state=error → notifyListeners() → ຄ້າງຢູ່ໜ້າ login ❌
```

---

## 4. ວິທີ login ໃຫ້ສຳເລັດ (ທົດສອບ)

dummyjson ຮັບສະເພາະ user ຈິງ. ໃຊ້:

| username | password |
|----------|----------|
| `emilys` | `emilyspass` |
| `michaelw` | `michaelwpass` |

> ⚠️ ໃສ່ຊ່ອງທຳອິດເປັນ **username** (`emilys`) ບໍ່ແມ່ນ email.

---

## 5. ສິ່ງທີ່ຄວນປັບປຸງຕໍ່ (ຂໍ້ສັງເກດ)

1. **ຍັງບໍ່ໄດ້ໃຊ້ `LoginStatus.loading`** — ຄວນຕັ້ງ `loading` ກ່ອນຍິງ API ເພື່ອສະແດງ spinner
   ແລະ ປິດປຸ່ມ ກັນກົດຊ້ຳ.
2. **ຍັງບໍ່ສະແດງ error ໃຫ້ຜູ້ໃຊ້ເຫັນ** — ຕອນນີ້ error ພຽງຕັ້ງ state, ຄວນ show SnackBar/dialog.
3. **`BuildContext` across async gap** — ຫຼັງ `await` ຄວນເຊັກ `if (!context.mounted) return;`
   ກ່ອນໃຊ້ `Navigator` (Dart ເຕືອນ lint ຢູ່).
4. **ຊື່ຕົວແປ `resulf`** — ສະກົດຜິດ (ຄວນເປັນ `result`), ບໍ່ມີ bug ແຕ່ຄວນແກ້ໃຫ້ອ່ານງ່າຍ.
5. **ຍັງບໍ່ເກັບ `accessToken`** — ຄວນເກັບ token (ເຊັ່ນ `shared_preferences`) ເພື່ອໃຊ້ຍິງ API
   ຄັ້ງຕໍ່ໄປ ແລະ ຈຳການ login.
```
