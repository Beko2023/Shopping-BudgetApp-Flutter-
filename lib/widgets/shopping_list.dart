import 'package:flutter/material.dart';
import 'package:shopping_cart/models/grocery_item.dart';
import 'package:shopping_cart/screens/new_item_screen.dart';
import 'package:shopping_cart/providers/new_item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCart extends ConsumerStatefulWidget {
  const ShoppingCart({super.key});

  @override
  ConsumerState<ShoppingCart> createState() => _ShoppingCartState();
}

int currentPageIndex = 0;

class _ShoppingCartState extends ConsumerState<ShoppingCart> {
  void _addItem() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );
  }

  void _editItem(BuildContext context, GroceryItem item, int index) async {
    final updatedItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewItemScreen(
          itemToEdit: item,
          itemIndex: index,
        ),
      ),
    );

    if (updatedItem != null) {
      ref.read(newItemProvider.notifier).updateItem(index, updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<GroceryItem> groceryItems = ref.watch(newItemProvider);

    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return const Color.fromRGBO(175, 219, 255, 1);
    }

    Widget content = Container(
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
          ],
        ),
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/penguin.png',
            width: 150,
            height: 200,
          ),
          const SizedBox(height: 10),
          const Text(
            "You haven't added any items yet...",
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );

    if (groceryItems.isNotEmpty) {
      content = Container(
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
                const Color.fromARGB(220, 255, 166, 0).withValues(alpha: 0.1)
              ]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(groceryItems[index]),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      minLeadingWidth: 0,
                      onTap: () =>
                          _editItem(context, groceryItems[index], index),
                      tileColor: const Color.fromARGB(255, 223, 242, 255),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      leading: Checkbox(
                          checkColor: const Color.fromARGB(255, 0, 0, 0),
                          fillColor: WidgetStateProperty.resolveWith(getColor),
                          value: groceryItems[index].checked,
                          onChanged: (bool? value) {
                            setState(() {
                              ref
                                  .read(newItemProvider.notifier)
                                  .switchChecked(groceryItems[index].id);
                            });
                          }),
                      title: Row(
                        children: [
                          Text(
                            groceryItems[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  decoration: groceryItems[index].checked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('x ${groceryItems[index].quantity.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    decoration: groceryItems[index].checked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  )),
                          const SizedBox(width: 10),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                              'Category: ${groceryItems[index].category.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    decoration: groceryItems[index].checked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  )),
                          const SizedBox(width: 10),
                          Text(
                              groceryItems[index].price == 0 &&
                                      groceryItems[index].checked
                                  ? "(Update Price)"
                                  : "",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13))
                        ],
                      ),
                      trailing: Text(groceryItems[index].category.emojis,
                          style: const TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                onDismissed: (direction) {
                  ref.read(newItemProvider.notifier).removeNewItem(index);
                },
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,

        icon: Image.asset('assets/images/shopping_cart_flat.png',
            width: 30, height: 30, fit: BoxFit.cover),
        label: const Text(
          'Add Item',
          style: TextStyle(fontSize: 14),
        ), // Text label
      ),
    );
  }
}
