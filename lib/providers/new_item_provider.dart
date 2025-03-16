import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/models/grocery_item.dart';

class NewItemNotifier extends StateNotifier<List<GroceryItem>> {
  NewItemNotifier() : super([]);
  void addNewItem(GroceryItem newItem) {
    state = [...state, newItem];
  }

  void removeNewItem(int index) {
    state = List.from(state)..removeAt(index);
  }

  void updateItem(int index, GroceryItem updatedItem) {
    state = state
        .asMap()
        .map((i, item) => MapEntry(i, i == index ? updatedItem : item))
        .values
        .toList();
  }

  void clearNewItems() {
    state = [];
  }

  void switchChecked(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return GroceryItem(
          id: item.id,
          name: item.name,
          quantity: item.quantity,
          price: item.price,
          category: item.category,
          date: item.date,
          checked: !item.checked,
        );
      }
      return item;
    }).toList();
  }
}

final newItemProvider =
    StateNotifierProvider<NewItemNotifier, List<GroceryItem>>((ref) {
  return NewItemNotifier();
});
