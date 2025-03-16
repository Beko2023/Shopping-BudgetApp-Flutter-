import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/models/category.dart';
import 'package:shopping_cart/providers/checked_items_provider.dart';

final categoryCostsProvider = Provider<Map<String, dynamic>>((ref) {
  final groceryList = ref.watch(checkedItemsProvider);

  final Map<Category, double> categoryCosts = {};
  double totalSpent = 0.0;

  for (var item in groceryList) {
    if (item.checked == true) {
      final totalNewItemCost = item.price * item.quantity;
      if (categoryCosts.containsKey(item.category)) {
        categoryCosts[item.category] =
            categoryCosts[item.category]! + totalNewItemCost;
      } else {
        categoryCosts[item.category] = totalNewItemCost;
      }
      totalSpent += totalNewItemCost;
    }
  }

  return {
    'categoryCosts': categoryCosts.entries.map((entry) {
      return {
        'category': entry.key,
        'totalCost': entry.value,
        'emojis': entry.key.emojis,
        'color': entry.key.color,
      };
    }).toList(),
    'totalSpending': totalSpent,
  };
});
