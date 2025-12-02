// دکمه اصلی اپ — برای اکشن‌های مهم مثل لاگین، ساخت حساب و ثبت اطلاعات
import 'package:flutter/material.dart';

// این ویجت یک دکمه آماده است که متن، اکشن و حالت لودینگ می‌گیرد
class PrimaryButton extends StatelessWidget {
  // متنی که روی دکمه نمایش داده می‌شود
  final String label;
  // تابعی که بعد از کلیک کاربر اجرا می‌شود
  final VoidCallback onPressed;
  // اگر true باشد، دکمه غیرفعال شده و لودینگ نشان می‌دهد
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  // ساخت خود دکمه با استایل یکسان در کل اپ
  @override
  Widget build(BuildContext context) {
    // اگر در حالت لودینگ باشیم، دکمه غیرفعال می‌شود
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        // شکل دکمه: گوشه‌های گرد و اندازه بزرگ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      // اگر لودینگ باشد، اسپینر نشان می‌دهیم؛ در غیر این صورت متن دکمه
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}