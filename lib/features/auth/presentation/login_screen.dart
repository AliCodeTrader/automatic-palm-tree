// صفحه لاگین اپ — کاربر از اینجا وارد سیستم بانک می‌شود
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets_imports.dart';
import 'package:flutter_application_1/features/auth/presentation/register_screen.dart';
import 'package:flutter_application_1/services/bank_api_service.dart';

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

  // سرویس ارتباط با سرور جاوا
  final _api = BankApiService();

  // وقتی صفحه بسته می‌شود، کنترلرها را تمیز می‌کنیم
  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // هندل کردن کلیک روی دکمه لاگین و ارسال درخواست به سرور
  Future<void> _onLogin() async {
    setState(() {
      _loading = true;
    });

    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    try {
      final ok = await _api.login(username, password);

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      if (ok) {
        // لاگین موفق → رفتن به صفحه هوم
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // لاگین ناموفق
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('نام کاربری یا رمز اشتباه است')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      // برای دیباگ: چاپ ارور در کنسول تا بفهمیم مشکل دقیقا چیه
      // ignore: avoid_print
      print('Login error: $e');

      // خطا در اتصال به سرور
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در اتصال به سرور')),
      );
    }
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
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