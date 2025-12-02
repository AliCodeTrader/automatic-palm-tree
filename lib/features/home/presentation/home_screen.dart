// صفحه اصلی (Dashboard) — خلاصه وضعیت حساب‌ها، گروه‌ها و فعالیت‌های اخیر را نشان می‌دهد
import 'package:flutter/material.dart';
// ایمپورت صفحه حساب‌ها، گروه‌ها، داده‌های ساختگی و صفحه ساخت حساب جدید
import 'package:flutter_application_1/features/accounts/presentation/accounts_screen.dart';
import 'package:flutter_application_1/features/groups/presentation/groups_screen.dart';
import 'package:flutter_application_1/features/accounts/data/dummy_accounts.dart';
import 'package:flutter_application_1/features/groups/data/dummy_groups.dart';
import 'package:flutter_application_1/features/accounts/presentation/create_account_screen.dart';

// صفحه Home به صورت Stateless چون داده‌ها را مستقیم از لیست‌های dummy می‌خوانیم
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // محاسبه مجموع موجودی تمام حساب‌ها
    final totalBalance =
        dummyAccounts.fold<int>(0, (sum, acc) => sum + acc.balance);
    // تعداد کل حساب‌ها
    final accountsCount = dummyAccounts.length;
    // تعداد کل گروه‌ها
    final groupsCount = dummyGroups.length;

    // دو حساب اول برای نمایش سریع در Home
    final previewAccounts = dummyAccounts.take(2).toList();
    // دو گروه اول برای نمایش سریع در Home
    final previewGroups = dummyGroups.take(2).toList();

    // ساخت لیست فعالیت‌های اخیر از روی تراکنش‌ها و خرج‌ها
    final List<_ActivityItem> activities = [];
    // اضافه کردن تراکنش‌های حساب‌ها به لیست Activity
    for (final acc in dummyAccounts) {
      for (final t in acc.transactions) {
        activities.add(
          _ActivityItem(
            title: 'Transfer ${t.type}',
            subtitle: '${acc.cardNumber} • ${t.amount}',
            date: t.date,
          ),
        );
      }
    }
    // اضافه کردن خرج‌های گروه‌ها به لیست Activity
    for (final g in dummyGroups) {
      for (final e in g.expenses) {
        activities.add(
          _ActivityItem(
            title: 'Group: ${g.name}',
            subtitle: '${e.payer} paid ${e.amount} for ${e.title}',
            date: e.date,
          ),
        );
      }
    }
    // مرتب‌سازی فعالیت‌ها بر اساس تاریخ (جدیدترین اول)
    activities.sort((a, b) => b.date.compareTo(a.date));
    // فقط ۵ فعالیت آخر را برای نمایش در Home نگه می‌داریم
    final recentActivities = activities.take(5).toList();

    // ساخت اسکفولد اصلی صفحه Dashboard
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // خوشامدگویی ساده به کاربر
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hi, Alireza 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Here is your overview for today',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            // کارت خلاصه: مجموع موجودی + تعداد حساب‌ها و گروه‌ها
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₮ $totalBalance',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('$accountsCount accounts'),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.people,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('$groupsCount groups'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // شورتکات‌ها: انتقال، ساخت حساب جدید و رفتن به گروه‌ها
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Transfer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_card),
                    label: const Text('New Account'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GroupsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.group_add),
                    label: const Text('Groups'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  // بخش نمایش سریع بعضی از حساب‌ها
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Accounts',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountsScreen(),
                            ),
                          );
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // ساخت کارت برای هر حساب پیش‌نمایش
                  ...previewAccounts.map(
                    (acc) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(acc.cardNumber),
                        subtitle: Text('Balance: ${acc.balance}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // بخش نمایش سریع چند گروه اشتراکی
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shared Groups',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // ساخت کارت برای هر گروه پیش‌نمایش
                  ...previewGroups.map(
                    (g) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(g.name),
                        subtitle: Text('${g.members.length} members'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // عنوان بخش فعالیت‌های اخیر
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  // نمایش لیست آخرین فعالیت‌ها (تراکنش‌ها و خرج‌ها)
                  ...recentActivities.map(
                    (a) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(a.title),
                      subtitle: Text(a.subtitle),
                      trailing: Text(
                        '${a.date.month}/${a.date.day}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ورودی ساده برای پروفایل (بعداً می‌توان توسعه داد)
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// مدل داخلی برای نگه‌داشتن اطلاعات هر Activity که در Home نمایش داده می‌شود
class _ActivityItem {
  final String title;
  final String subtitle;
  final DateTime date;

  _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.date,
  });
}