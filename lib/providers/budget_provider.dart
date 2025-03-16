import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetNotifier extends StateNotifier<double> {
  BudgetNotifier() : super(0.0);

  void updateValue(double newValue) {
    state = newValue;
  }
}

final budgetNotifierProvider = StateNotifierProvider<BudgetNotifier, double>(
  (ref) => BudgetNotifier(),
);
