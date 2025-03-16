import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/providers/checked_items_provider.dart';

final upcomingPurchasesProvider = StateNotifierProvider<
    UpcomingPurchasesNotifier, List<Map<String, dynamic>>>((ref) {
  final groceryList = ref.watch(checkedItemsProvider);
  return UpcomingPurchasesNotifier(groceryList);
});

class UpcomingPurchasesNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  UpcomingPurchasesNotifier(List<dynamic> groceryList)
      : super(
          groceryList
              .where((item) {
                bool isChecked = item.checked == true;
                DateTime now = DateTime.now();
                print(item.name);
                print(isChecked);
                DateTime normalizedNow = DateTime(now.year, now.month, now.day);
                print(normalizedNow);
                DateTime normalizedPickedDate =
                    DateTime(item.date.year, item.date.month, item.date.day);
                print(normalizedPickedDate);
                Duration difference =
                    normalizedPickedDate.difference(normalizedNow);
                print(difference);
                bool isOneDayApart = difference.inDays >= 1;
                print(isOneDayApart);
                return isChecked && isOneDayApart;
              })
              .map((item) => {
                    'id': item.id,
                    'name': item.name,
                    'quantity': item.quantity,
                    'price': item.price,
                    'category': item.category,
                    'date': item.date,
                    'checked': item.checked,
                  })
              .toList(),
        );

  void removeNewItem(int index) {
    state = List.from(state)..removeAt(index);
  }
}
