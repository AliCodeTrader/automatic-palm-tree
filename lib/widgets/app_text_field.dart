// ویجت تکس‌فیلد شخصی‌سازی‌شده — برای ورودی‌های فرم در کل اپ استفاده می‌کنیم
import 'package:flutter/material.dart';

// این یک StatelessWidget هست چون فقط ورودی می‌گیرد و خودش وضعیت ندارد
class AppTextField extends StatelessWidget {
  // کنترلر برای مدیریت متن ورودی
  final TextEditingController controller;
  // لیبل که بالای فیلد نمایش داده می‌شود
  final String label;
  // اگر true باشد متن به صورت رمز (••••) نمایش داده می‌شود
  final bool obscure;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
  });

  // ساخت UI تکس‌فیلد با استایل یکسان در کل اپ
  @override
  Widget build(BuildContext context) {
    // خود فیلد اصلی ورودی
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        // استایل دور فیلد — گوشه‌های گرد
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}