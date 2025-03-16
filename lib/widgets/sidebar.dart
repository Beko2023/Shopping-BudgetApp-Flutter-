import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/providers/theme_provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:shopping_cart/providers/currency_picker.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  void _showCurrencyPicker() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        ref.read(currencyProvider.notifier).setCurrency(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final selectedCurrency = ref.watch(currencyProvider);

    return ListView(
      children: [
        SizedBox(
          height: 70,
          child: DrawerHeader(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Text(
                  'Configuration',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 0, 0),
          child: Row(
            children: [
              const Text("Dark Mode"),
              const SizedBox(width: 10),
              Switch(
                value: isDark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Select Currency: "),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _showCurrencyPicker,
                child: Text(selectedCurrency?.code ?? ''),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        isDark
            ? Image.asset('assets/images/moon.png', height: 200, width: 200)
            : Image.asset('assets/images/sun.png', height: 200, width: 200),
      ],
    );
  }
}
