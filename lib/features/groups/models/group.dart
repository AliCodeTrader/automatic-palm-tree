// مدل گروه — هر گروه شامل اعضا و لیست خرج‌های مربوط به خودش است
import 'expense.dart';
// مدل خرج‌ها را ایمپورت کردیم تا داخل گروه استفاده کنیم

// کلاس Group نماینده یک گروه مشترک هزینه است (مثل سفر، مهمانی، پروژه و ...)
class Group {
  // شناسه‌ی یونیک گروه
  final String id;
  // نام گروه (مثلاً سفر شمال، شام دوستانه و ...)
  final String name;
  // اعضای گروه — هر عضو با اسمش ذخیره می‌شود
  final List<String> members;
  // لیست خرج‌هایی که اعضای گروه انجام داده‌اند
  final List<Expense> expenses;

  // سازنده‌ی گروه — برای ساخت یک گروه جدید استفاده می‌شود
  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
  });
}