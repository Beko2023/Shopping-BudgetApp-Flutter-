import 'package:shopping_cart/models/category.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price,
      required this.category,
      required this.date,
      required this.checked});

  final String id;
  final String name;
  final int quantity;
  final double price;
  final Category category;
  final DateTime date;
  final bool checked;
}
