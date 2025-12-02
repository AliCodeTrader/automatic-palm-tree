// شیت اضافه کردن خرج جدید برای یک گروه — به صورت bottom sheet نمایش داده می‌شود
import 'package:flutter/material.dart';
// مدل گروه و مدل خرج را ایمپورت کردیم تا روی همان داده‌ها کار کنیم
import '../models/group.dart';
import '../models/expense.dart';

// ویجت stateful چون فرم دارد و مقدارهای ورودی تغییر می‌کنند
class AddExpenseSheet extends StatefulWidget {
  final Group group;

  const AddExpenseSheet({super.key, required this.group});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  // کنترلر برای گرفتن عنوان خرج از ورودی
  final _titleController = TextEditingController();
  // کنترلر برای گرفتن مبلغ خرج
  final _amountController = TextEditingController();
  // عضوی که این خرج را پرداخت کرده (از بین اعضای گروه)
  String? _selectedPayer;

  // تنظیم اولیه: اگر گروه عضو دارد، اولین نفر را به‌عنوان payer پیش‌فرض انتخاب می‌کنیم
  @override
  void initState() {
    super.initState();
    if (widget.group.members.isNotEmpty) {
      _selectedPayer = widget.group.members.first;
    }
  }

  // تمیز کردن کنترلرها وقتی شیت بسته می‌شود
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // اعتبارسنجی ورودی‌ها و اضافه کردن خرج جدید به لیست group.expenses
  void _submit() {
    final title = _titleController.text.trim();
    final amount = int.tryParse(_amountController.text) ?? 0;

    // اگر ورودی‌ها درست پر نشده باشند، ارور نشان می‌دهیم و ادامه نمی‌دهیم
    if (title.isEmpty || amount <= 0 || _selectedPayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields correctly')),
      );
      return;
    }

    // ساختن یک شیء Expense و اضافه کردن آن به لیست خرج‌های گروه
    widget.group.expenses.add(
      Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        payer: _selectedPayer!,
        date: DateTime.now(),
      ),
    );

    // بستن bottom sheet بعد از ثبت موفق
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // ساخت UI شیت: فیلد عنوان، مبلغ، انتخاب payer و دکمه ذخیره
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 18,
        right: 18,
        top: 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان شیت
          Text(
            'Add Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Title input
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Expense title',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Amount input
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedPayer,
              underline: const SizedBox(),
              items: widget.group.members
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedPayer = v;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Save button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}