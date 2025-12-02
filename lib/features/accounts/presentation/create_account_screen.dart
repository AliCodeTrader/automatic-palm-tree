// صفحه ایجاد حساب جدید — از اینجا می‌تونیم یک اکانت بانکی تازه بسازیم
import 'package:flutter/material.dart';
// داده‌های تستی، مدل حساب و مدل تراکنش رو ایمپورت کردیم
import '../data/dummy_accounts.dart';
import '../models/account.dart';
import '../models/transaction.dart';

// این صفحه Stateful هست چون فرم داره و بعد از ساخت حساب باید برگردیم
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // کنترلر برای گرفتن مبلغ اولیه‌ی موجودی از TextField
  final _balanceController = TextEditingController();

  // تمیز کردن کنترلر وقتی صفحه بسته می‌شود
  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  // تولید یک شماره حساب ۱۰ رقمی بر اساس زمان فعلی (فقط برای تست)
  String _generateAccountNumber() {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    return now.substring(now.length - 10); // 10 رقم آخر
  }

  // تولید شماره کارت ۱۶ رقمی شبیه کارت واقعی (به صورت ساختگی)
  String _generateCardNumber() {
    // تبدیل میلی‌ثانیه‌ها به رشته و مطمئن شدن که حداقل ۱۶ رقم داریم
    final base = DateTime.now()
        .millisecondsSinceEpoch
        .toString()
        .padLeft(16, '0');

    // دقیقا 16 رقم آخر
    final s = base.substring(base.length - 16);

    // 4-4-4-4 جداش می‌کنیم
    return "${s.substring(0, 4)} "
        "${s.substring(4, 8)} "
        "${s.substring(8, 12)} "
        "${s.substring(12, 16)}";
  }

  // ساختن یک Account جدید و اضافه کردنش به لیست dummyAccounts
  void _createAccount() {
    // تبدیل متن وارد شده به عدد، اگر خالی بود ۰ در نظر می‌گیریم
    final balance = int.tryParse(_balanceController.text) ?? 0;

    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: _generateCardNumber(),
      accountNumber: _generateAccountNumber(),
      balance: balance,
      transactions: <TransactionModel>[],
    );

    // اضافه کردن حساب جدید به لیست حساب‌های تستی
    dummyAccounts.add(newAccount);

    // برگشت به صفحه قبل بعد از ساخت حساب
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // ساختن UI صفحه ایجاد حساب
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // فیلد ورود موجودی اولیه (اختیاری)
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Balance (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // دکمه ساخت حساب جدید
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}