import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/models/grocery_item.dart';
import 'package:shopping_cart/providers/new_item_provider.dart';

class CheckedItemsProvider extends StateNotifier<List<GroceryItem>> {
  CheckedItemsProvider(this.ref) : super([]) {
    ref.listen<List<GroceryItem>>(newItemProvider, (previous, next) {
      var updatedState = List<GroceryItem>.from(state);

      updatedState = updatedState.where((checkedItem) {
        print(checkedItem);
        print(next);
        return !next.any((item) => item.id == checkedItem.id) ||
            next.any((item) => item.id == checkedItem.id && item.checked);
      }).toList();

      for (final item in next) {
        if (item.checked) {
          final existingItemIndex = updatedState
              .indexWhere((checkedItem) => checkedItem.id == item.id);
          if (existingItemIndex > -1) {
            updatedState[existingItemIndex] = item;
          } else {
            updatedState.add(item);
          }
        }
      }

      state = updatedState;
    });
  }

  final Ref ref;

  void clearCheckedItems() {
    state = [];
  }
}

final checkedItemsProvider =
    StateNotifierProvider<CheckedItemsProvider, List<GroceryItem>>((ref) {
  return CheckedItemsProvider(ref);
});
