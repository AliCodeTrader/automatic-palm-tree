// مدل تراکنش — هر حرکت مالی داخل حساب با این کلاس ذخیره میشه
class TransactionModel {
  // شناسه‌ی یونیک تراکنش
  final String id;
  // نوع تراکنش: واریز، برداشت یا انتقال
  final String type; // deposit, withdraw, transfer
  // مبلغ تراکنش
  final int amount;
  // تاریخ انجام تراکنش
  final DateTime date;
  // توضیح کوتاه برای تراکنش (اختیاری)
  final String? description;

  // سازنده‌ی تراکنش — باید نوع، مبلغ و تاریخ را وارد کنیم
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
  });
}