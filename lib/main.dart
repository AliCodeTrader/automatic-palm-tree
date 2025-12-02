// فایل اصلی اپ — نقطه شروع اجرای برنامه

// ایمپورت تم اصلی + صفحه لاگین و صفحه هوم
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';

// اجرای اپلیکیشن — اولین تابعی که هنگام استارت اجرا می‌شود
void main() {
  runApp(const BankApp());
}

// ویجت ریشه اپ — اینجا MaterialApp و تنظیمات کلی اپ قرار می‌گیرد
class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ساخت MaterialApp با تم، مسیرها و تنظیمات اصلی
    return MaterialApp(
      title: 'AP Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // مسیر اولیه — اپ همیشه از صفحه لاگین شروع می‌شود
      initialRoute: '/login',
      // تعریف مسیرهای اپ (Navigation Map)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
