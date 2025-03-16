import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_picker/currency_picker.dart';

class CurrencyNotifier extends StateNotifier<Currency?> {
  CurrencyNotifier() : super(CurrencyService().findByCode('USD'));

  void setCurrency(Currency currency) {
    state = currency;
  }
}

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, Currency?>((ref) {
  return CurrencyNotifier();
});
