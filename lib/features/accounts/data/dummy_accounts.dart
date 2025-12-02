// یه لیست ساختگی از حساب‌ها برای تست و نمایش داخل اپ
import '../models/account.dart';
import '../models/transaction.dart';

// مدل اکانت و تراکنش رو ایمپورت کردیم تا بتونیم نمونه بسازیم

// اینجا داریم دو تا حساب تستی می‌سازیم، هر کدوم با تراکنش‌هاش
final List<Account> dummyAccounts = [
  Account(
    // حساب اول: کارت ملت با چند تا تراکنش مختلف
    id: '1',
    cardNumber: '6037 9921 4456 3311',
    accountNumber: '1234567890',
    balance: 12500000,
    // لیست تراکنش‌های این حساب
    transactions: [
      // تراکنش: واریز حقوق
      TransactionModel(
        id: 't1',
        type: 'deposit',
        amount: 3000000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Salary',
      ),
      // تراکنش: برداشت از ATM
      TransactionModel(
        id: 't2',
        type: 'withdraw',
        amount: 500000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'ATM withdrawal',
      ),
      // تراکنش: انتقال پول به علی
      TransactionModel(
        id: 't3',
        type: 'transfer',
        amount: 1000000,
        date: DateTime.now().subtract(const Duration(hours: 10)),
        description: 'Sent to Ali',
      ),
    ],
  ),
  Account(
    // حساب دوم: کارت صادرات با یه تراکنش
    id: '2',
    cardNumber: '5022 2910 8845 1290',
    accountNumber: '9098765432',
    balance: 7800000,
    transactions: [
      // تراکنش: واریز پروژه
      TransactionModel(
        id: 't4',
        type: 'deposit',
        amount: 2200000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Project payment',
      ),
    ],
  ),
];