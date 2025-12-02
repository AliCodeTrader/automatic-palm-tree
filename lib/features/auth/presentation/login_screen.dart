// صفحه لاگین اپ — کاربر از اینجا وارد سیستم بانک می‌شود
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets_imports.dart';

// ویجت‌های آماده (فیلد و دکمه) را از پوشه widgets ایمپورت کردیم

// صفحه لاگین به صورت Stateful چون فرم و حالت لودینگ دارد
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // کنترلرهای فیلد نام کاربری و رمز عبور
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // وضعیت لودینگ برای زمانی که در حال لاگین هستیم
  bool _loading = false;

  // وقتی صفحه بسته می‌شود، کنترلرها را تمیز می‌کنیم
  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // هندل کردن کلیک روی دکمه لاگین
  Future<void> _onLogin() async {
    setState(() => _loading = true);

    // شبیه‌سازی تأخیر درخواست شبکه (فعلاً فیک)
    await Future.delayed(const Duration(milliseconds: 700)); // فیک

    // فعلاً بدون اعتبارسنجی، کاربر را مستقیماً به صفحه Home می‌بریم
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // ساختن UI صفحه لاگین
  @override
  Widget build(BuildContext context) {
    // اسکفولد اصلی صفحه با SafeArea برای فاصله از نوار بالا
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // آیکن بالای صفحه (لوگو بانک)
                  const Icon(Icons.account_balance, size: 60),
                  const SizedBox(height: 16),
                  // عنوان اپلیکیشن
                  Text(
                    'AP Bank',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  // فیلد وارد کردن نام کاربری
                  AppTextField(
                    controller: _usernameCtrl,
                    label: 'Username',
                  ),
                  const SizedBox(height: 12),
                  // فیلد وارد کردن رمز عبور (به صورت مخفی)
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  // دکمه اصلی لاگین با حالت لودینگ
                  PrimaryButton(
                    label: 'Login',
                    loading: _loading,
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: 12),
                  // دکمه‌ای برای رفتن به صفحه ساخت اکانت جدید (بعداً پیاده‌سازی می‌شود)
                  TextButton(
                    onPressed: () {
                      // بعداً: صفحه Register
                    },
                    child: const Text('Create new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}