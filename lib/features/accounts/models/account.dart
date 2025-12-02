// مدل اصلی حساب بانکی — اطلاعات هر حساب اینجا نگه داشته میشه
import 'transaction.dart';

// مدل تراکنش‌ها رو ایمپورت کردیم تا داخل حساب لیست تراکنش داشته باشیم

// کلاس Account نماینده‌ی یک حساب بانکی با شماره کارت، شماره حساب و موجودیه
class Account {
  // شناسه‌ی یونیک حساب
  final String id;

  // شماره کارت (مثل 6037...)
  final String cardNumber;

  // شماره حساب بانک
  final String accountNumber;

  // موجودی حساب (قابل تغییر)
  int balance;

  // لیست تراکنش‌های انجام‌شده روی این حساب
  final List<TransactionModel> transactions;

  // سازنده‌ی کلاس — باید همه چیز رو موقع ساخت حساب وارد کنیم
  Account({
    required this.id,
    required this.cardNumber,
    required this.accountNumber,
    required this.balance,
    required this.transactions,
  });
}