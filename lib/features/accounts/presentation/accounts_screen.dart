// صفحه لیست حساب‌ها — اینجا تمام حساب‌هایی که ساختیم نمایش داده میشن
import 'package:flutter/material.dart';
// داده‌های تستی اکانت‌ها + صفحه جزئیات + صفحه ساخت اکانت
import '../data/dummy_accounts.dart';
import 'account_detail_screen.dart';
import 'create_account_screen.dart';

// این صفحه به‌صورت Stateful هست چون بعد از ساخت اکانت جدید باید رفرش بشه
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // رفتن به صفحه ساخت اکانت و برگشتن بعد از ذخیره
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      // لیست همه حساب‌ها با کارت گرادیانی
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyAccounts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // گرفتن مدل حساب فعلی
          final acc = dummyAccounts[index];
          // گرفتن ۴ رقم آخر کارت برای نمایش زیباتر
          final card = acc.cardNumber;
          final last4 = card.isNotEmpty ? card.substring(card.length - 4) : '****';

          // کارت لمسی هر حساب
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AccountDetailScreen(account: acc),
                ),
              );
            },
            child: Container(
              // بک‌گراند گرادیانی کارت
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.14),
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.28),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // آیکن کارت و شماره کارت ماسک‌شده
                      const Icon(Icons.credit_card, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '•••• $last4',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      // نمایش موجودی حساب
                      Text(
                        '₮ ${acc.balance}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // نمایش شماره حساب بانکی
                  Text(
                    'Account: ${acc.accountNumber}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}