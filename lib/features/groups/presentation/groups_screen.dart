// صفحه لیست گروه‌ها — نمایش تمام گروه‌های اشتراکی
import 'package:flutter/material.dart';
// داده‌های تستی گروه‌ها + صفحه جزئیات هر گروه
import '../data/dummy_groups.dart';
import 'group_detail_screen.dart';

// این صفحه Stateless هست چون فقط داده‌ها را نمایش می‌دهد
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ساخت UI اصلی صفحه
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Groups')),
      // لیست نمایش گروه‌ها با کارت‌های گرادیانی
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyGroups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // گرفتن مدل گروه فعلی
          final g = dummyGroups[index];
          // ساخت لیست اعضا در قالب یک رشته
          final members = g.members.join(', ');
          // محاسبه مجموع کل هزینه‌های گروه
          final int total = g.expenses.fold<int>(0, (sum, e) => sum + e.amount);

          // کارت لمسی نمایش اطلاعات گروه
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupDetailScreen(group: g),
                ),
              );
            },
            child: Container(
              // پس‌زمینه گرادیانی کارت
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.24),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // آیکن گروه + نام گروه
                      const Icon(Icons.group, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          g.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${g.members.length} members',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // نمایش اعضای گروه (در یک خط)
                  Text(
                    members,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  // نمایش مجموع هزینه‌های گروه
                  Text(
                    'Total expenses: $total',
                    style: Theme.of(context).textTheme.bodyMedium,
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