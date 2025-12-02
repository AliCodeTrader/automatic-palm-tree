// مدل خرج برای گروه‌ها — هر هزینه‌ای که داخل یک گروه ثبت می‌شود با این کلاس ذخیره می‌شود
class Expense {
  // شناسه‌ی یونیک خرج
  final String id;
  // عنوان خرج (مثلاً خرید غذا، کرایه، نان و ...)
  final String title;
  // مبلغ خرج
  final int amount;
  // اسم کسی که این خرج رو پرداخت کرده
  final String payer;
  // تاریخ ثبت خرج
  final DateTime date;

  // سازنده‌ی کلاس خرج — اطلاعات خرج را دریافت و ذخیره می‌کند
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.payer,
    required this.date,
  });
}