import 'package:flutter/material.dart';
import 'package:shopping_cart/providers/budget_provider.dart';
import 'package:shopping_cart/providers/checked_items_provider.dart';
import 'package:shopping_cart/providers/currency_picker.dart';
import 'package:shopping_cart/providers/new_item_provider.dart';
import 'package:shopping_cart/providers/spending_provider.dart';
import 'package:shopping_cart/screens/home_screen.dart';
import 'package:shopping_cart/screens/new_budget_screen.dart';
import 'package:shopping_cart/screens/spending_screen.dart';
import 'package:shopping_cart/widgets/budget_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/widgets/sidebar.dart';
import 'package:shopping_cart/widgets/timeline_painter.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

void _openAddItemForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: const NewBudgetScreen(),
      );
    },
  );
}

void resetData(WidgetRef ref) {
  ref.read(budgetNotifierProvider.notifier).updateValue((0));
  ref.read(checkedItemsProvider.notifier).clearCheckedItems();
  ref.read(newItemProvider.notifier).clearNewItems();
}

Future<void> _showMyDialog(context, WidgetRef ref) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete All Data'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Image.asset('assets/images/warningPenguin.png',
                  height: 150, width: 150),
              const Text(
                  'This will reset all spending and cannot be reversed. Are you sure?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              resetData(ref);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final selectedCurrency = ref.watch(currencyProvider);
    final costsProvider = ref.watch(categoryCostsProvider);
    final budgetProvider = ref.watch(budgetNotifierProvider);
    final totalCost = costsProvider['totalSpending'] as double;
    final double totalBudget = budgetProvider;
    final double currentSpending = totalCost;
    final String difference =
        (totalBudget - currentSpending).toStringAsFixed(2);
    int currentPageIndex = 2;
    DateTime now = DateTime.now();
    int currentDay = now.day;
    String currentMonth = DateFormat('MMMM').format(now);
    int totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
    double todayPosition = (currentDay - 1) / (totalDaysInMonth - 1);
    String todayDate = DateFormat('MMMM d').format(now);
    int daysRemaining = totalDaysInMonth - currentDay;
    String dailyAllowance =
        ((totalBudget - currentSpending) / daysRemaining).toStringAsFixed(2);

    Widget content = Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
              child: CustomPaint(
                painter: TimelinePainter(
                    lineColor: Theme.of(context).colorScheme.onSurface,
                    todayPosition: todayPosition,
                    todayDate: todayDate,
                    triangleColor: const Color.fromARGB(255, 197, 125, 18)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text("Balance for $currentMonth",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        const SizedBox(height: 25),
        BudgetChart(currentSpending: currentSpending, totalBudget: totalBudget),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total Spending: ",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              "${selectedCurrency?.symbol} $totalCost",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Remaining funds: ",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              "${selectedCurrency?.symbol} $difference",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Daily budget until end of $currentMonth: ",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              "${selectedCurrency?.symbol} $dailyAllowance",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Container(
        padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
        child: Row(
          mainAxisAlignment:
              costsProvider['totalSpending'] != 0.0 || budgetProvider != 0.0
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
          children: [
            if (costsProvider['totalSpending'] != 0.0 || budgetProvider != 0.0)
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _showMyDialog(context, ref),
                  label: const Text("Reset Data"),
                  icon: const Icon(
                    Icons.warning_amber,
                    size: 30,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            FloatingActionButton.extended(
              onPressed: () => _openAddItemForm(context),
              icon: const Icon(
                Icons.wallet,
                color: Color.fromARGB(255, 240, 152, 20),
              ),
              label: const Text(
                'Set Budget',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Budget Overview'),
      ),
      drawer: const Drawer(child: SideBar()),
      body: Container(
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
                ]),
          ),
          child: Center(child: content)),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SpendingScreen()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BudgetScreen()));
          }
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          const NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined), label: 'Spending'),
          const NavigationDestination(
              icon: Icon(Icons.balance), label: 'Budget'),
        ],
        selectedIndex: currentPageIndex,
      ),
    );
  }
}
