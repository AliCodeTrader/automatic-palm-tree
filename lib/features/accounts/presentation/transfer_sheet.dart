// شیت انتقال پول — کاربر از اینجا می‌تونه بین حساب‌ها انتقال انجام بده
import 'package:flutter/material.dart';
// مدل حساب، داده‌های تستی و مدل تراکنش رو وارد کردیم
import '../models/account.dart';
import '../data/dummy_accounts.dart';
import '../models/transaction.dart';

// این شیت به صورت bottom sheet باز می‌شود و روی یک حساب خاص کار می‌کند
class TransferSheet extends StatefulWidget {
  final Account account;

  const TransferSheet({super.key, required this.account});

  @override
  State<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<TransferSheet> {
  // حساب مقصدی که پول قرار است به آن منتقل شود
  Account? selectedAccount;
  // کنترلر برای گرفتن مبلغ از ورودی
  final _amountController = TextEditingController();
  // نوع انتقال (عادی، بین بانکی، شبا)
  String transferType = "normal";

  @override
  Widget build(BuildContext context) {
    // ساخت UI شیت انتقال
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Transfer Money",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // انتخاب حساب مقصد (به غیر از حساب فعلی)
          DropdownButton<Account>(
            isExpanded: true,
            value: selectedAccount,
            hint: const Text("Select Destination Account"),
            items: dummyAccounts
                .where((a) => a.id != widget.account.id)
                .map((acc) {
              return DropdownMenuItem(
                value: acc,
                child: Text(acc.cardNumber),
              );
            }).toList(),
            onChanged: (newAcc) {
              setState(() {
                selectedAccount = newAcc;
              });
            },
          ),

          const SizedBox(height: 15),

          // انتخاب نوع انتقال و تعیین سقف مجاز
          DropdownButton<String>(
            isExpanded: true,
            value: transferType,
            items: const [
              DropdownMenuItem(value: "normal", child: Text("Normal Transfer (limit: 5,000,000)")),
              DropdownMenuItem(value: "same_bank", child: Text("Same Bank (limit: 20,000,000)")),
              DropdownMenuItem(value: "sheba", child: Text("Sheba Transfer (limit: 50,000,000)")),
            ],
            onChanged: (v) {
              setState(() {
                transferType = v!;
              });
            },
          ),

          const SizedBox(height: 15),

          // ورودی مبلغ انتقال
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // دکمه انجام انتقال
          ElevatedButton(
            onPressed: submitTransfer,
            child: const Text("Transfer"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // اجرای منطق انتقال پول و اعتبارسنجی‌ها
  void submitTransfer() {
    // بررسی اینکه حساب مقصد انتخاب شده باشد
    if (selectedAccount == null) {
      showError("Please select destination account");
      return;
    }

    // بررسی معتبر بودن مبلغ وارد شده
    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      showError("Invalid amount");
      return;
    }

    // تعیین سقف مجاز بر اساس نوع انتقال
    int limit = 5000000;
    if (transferType == "same_bank") limit = 20000000;
    if (transferType == "sheba") limit = 50000000;

    if (amount > limit) {
      showError("Amount exceeds limit for this transfer type");
      return;
    }

    // بررسی کافی بودن موجودی حساب مبدا
    if (amount > widget.account.balance) {
      showError("Insufficient balance");
      return;
    }

    // انجام انتقال: کم کردن از حساب مبدا و اضافه کردن به مقصد
    setState(() {
      widget.account.balance -= amount;
      selectedAccount!.balance += amount;

      // ثبت تراکنش برداشت برای حساب مبدا
      widget.account.transactions.add(
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: "withdraw",
          amount: amount,
          date: DateTime.now(),
          description: "Transfer to ${selectedAccount!.cardNumber}",
        ),
      );

      // ثبت تراکنش واریز برای حساب مقصد
      selectedAccount!.transactions.add(
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: "deposit",
          amount: amount,
          date: DateTime.now(),
          description: "Received from ${widget.account.cardNumber}",
        ),
      );
    });

    // بستن شیت بعد از انتقال موفق
    Navigator.pop(context);
  }

  // نمایش پیام خطا داخل SnackBar
  void showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}