// صفحه جزئیات گروه — نمایش خلاصه گروه، بالانس اعضا و لیست خرج‌ها
import 'package:flutter/material.dart';
// مدل گروه، مدل خرج و شیت اضافه‌کردن خرج را ایمپورت کردیم
import '../models/group.dart';
import '../models/expense.dart';
import 'add_expense_sheet.dart';

// این صفحه به صورت Stateless نمایش داده می‌شود چون داده‌ها از خود group تامین می‌شود
class GroupDetailScreen extends StatelessWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  // محاسبه اینکه هر عضو چقدر باید بپردازد یا دریافت کند
  Map<String, int> _calculateBalances(Group g) {
    // مجموع کل خرج‌های گروه
    final int total = g.expenses.fold(0, (sum, e) => sum + e.amount);
    if (g.members.isEmpty) return {};

    // سهم هر نفر از کل خرج‌ها
    final int share = (total / g.members.length).round();

    // ثبت اینکه هر نفر تا الان چقدر پرداخت کرده است
    final Map<String, int> paid = {for (var m in g.members) m: 0};

    // جمع کردن مبلغ‌هایی که هر عضو پرداخت کرده
    for (final Expense e in g.expenses) {
      paid[e.payer] = (paid[e.payer] ?? 0) + e.amount;
    }

    // موجودی نهایی: پرداخت شده - سهم هر نفر
    final Map<String, int> balance = {};
    for (final m in g.members) {
      balance[m] = (paid[m] ?? 0) - share;
    }
    return balance;
  }

  // محاسبه مجموع کل هزینه‌ها (برای نمایش در کارت بالا)
  int _total(Group g) => g.expenses.fold(0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    // ساخت UI اصلی صفحه
    final balances = _calculateBalances(group);
    final total = _total(group);

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      // دکمه اضافه کردن خرج جدید به گروه
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddExpenseSheet(group: group),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // کارت خلاصه‌ی گروه: نام، تعداد اعضا و مجموع هزینه‌ها
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          group.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${group.members.length} members',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total expenses: $total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // کارت وضعیت بالانس اعضا (چه کسی باید بدهد، چه کسی باید بگیرد)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Members balance',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...group.members.map((m) {
                      final bal = balances[m] ?? 0;
                      String text;
                      Color color;

                      if (bal > 0) {
                        text = '+$bal (should receive)';
                        color = Colors.green;
                      } else if (bal < 0) {
                        text = '$bal (should pay)';
                        color = Colors.red;
                      } else {
                        text = 'settled';
                        color = Colors.grey;
                      }

                      // نمایش وضعیت هر عضو بر اساس بالانس
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            m.isNotEmpty ? m[0].toUpperCase() : '?',
                          ),
                        ),
                        title: Text(m),
                        trailing: Text(
                          text,
                          style: TextStyle(color: color),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // عنوان لیست خرج‌ها
            Text(
              'Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // نمایش لیست خرج‌های ثبت‌شده در گروه
            ...group.expenses.map(
              (e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(e.title),
                  subtitle: Text('${e.payer} • ${e.amount}'),
                  trailing: Text(
                    '${e.date.month}/${e.date.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}