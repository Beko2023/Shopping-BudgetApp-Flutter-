import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/providers/upcoming_purchases_provider.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedItem = ref.watch(upcomingPurchasesProvider);

    Widget content = Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Set a restock date for your shopping list items if you wish to have a reminder for them.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14)),
          Image.asset(
            'assets/images/madagascar.png',
            height: 300,
            width: 300,
          )
        ],
      ),
    );

    if (purchasedItem.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: purchasedItem.length,
            itemBuilder: (context, index) {
              final item = purchasedItem[index];

              return Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                    color: item['category'].color,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 223, 242, 255),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  title: Text(
                    'Shop for "${item['name']}" in ${DateFormat('MMM d, yyyy').format(item["date"]).toString()}',
                    style: const TextStyle(
                        color: Color.fromARGB(223, 253, 254, 255),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  subtitle: Row(
                    children: [
                      Text('Category: ${item['category'].title}',
                          style: const TextStyle(
                              color: Color.fromARGB(223, 253, 254, 255),
                              fontWeight: FontWeight.w200,
                              fontSize: 12)),
                    ],
                  ),
                  trailing: GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onTap: () => ref
                        .read(upcomingPurchasesProvider.notifier)
                        .removeNewItem(index),
                  ),
                ),
              );
            }),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.alarm, size: 30),
            SizedBox(width: 10),
            Text('Reminders'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color.fromARGB(220, 255, 166, 0).withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                const Color.fromARGB(220, 255, 166, 0).withValues(alpha: 0.1),
              ]),
        ),
        child: Center(child: content),
      ),
    );
  }
}
