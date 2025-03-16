import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/data/categories.dart';
import 'package:shopping_cart/models/category.dart';
import 'package:shopping_cart/models/grocery_item.dart';
import 'package:shopping_cart/providers/new_item_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class NewItemScreen extends ConsumerStatefulWidget {
  const NewItemScreen({super.key, this.itemToEdit, this.itemIndex});

  final GroceryItem? itemToEdit;
  final int? itemIndex;

  @override
  ConsumerState<NewItemScreen> createState() => _NewItemState();
}

class _NewItemState extends ConsumerState<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  var _enteredName = "";
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.other]!;
  var _selectedDate = DateTime.now();
  double _inputPrice = 0.0;

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      _enteredName = widget.itemToEdit!.name;
      _enteredQuantity = widget.itemToEdit!.quantity;
      _selectedCategory = widget.itemToEdit!.category;
      _selectedDate = widget.itemToEdit!.date;
      _inputPrice = widget.itemToEdit!.price;
      _nameController.text = _enteredName;
      _quantityController.text = _enteredQuantity.toString();
      _priceController.text = _inputPrice.toString();
      _dateController.text = DateFormat('MMMM d, y').format(_selectedDate);
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final item = GroceryItem(
        id: widget.itemToEdit?.id ?? uuid.v4(),
        name: _enteredName,
        quantity: _enteredQuantity,
        price: _inputPrice,
        category: _selectedCategory,
        date: _selectedDate,
        checked: widget.itemToEdit?.checked ?? false,
      );

      if (widget.itemIndex != null) {
        ref.read(newItemProvider.notifier).updateItem(widget.itemIndex!, item);
      } else {
        ref.read(newItemProvider.notifier).addNewItem(item);
      }

      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + 2, now.month, now.day),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM d, y').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color.fromARGB(255, 117, 146, 170).withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                Colors.orange.withValues(alpha: 0.0),
                const Color.fromARGB(255, 117, 146, 170).withValues(alpha: 0.1),
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  controller: _nameController,
                  maxLength: 18,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    labelText: "What are you buying?",
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return "Please enter a valid input";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    labelText: "Enter quantity (optional)",
                    alignLabelWithHint: true,
                  ),
                  onSaved: (value) {
                    _enteredQuantity =
                        value == null || value.isEmpty ? 1 : int.parse(value);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    labelText: "Unit Price (optional)",
                    alignLabelWithHint: true,
                  ),
                  onSaved: (value) {
                    _inputPrice = value == null || value.isEmpty
                        ? 0.0
                        : double.parse(value);
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    labelText: 'Category (optional)',
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                  items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.value,
                        child: Text(category.value.title),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    labelText: 'Replenishment date (optional)',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime.now();
                              _dateController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 0.1,
                        ),
                        minimumSize: const Size(120, 50),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          minimumSize: const Size(120, 50)),
                      onPressed: _saveItem,
                      child: const Text("Save Item"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
