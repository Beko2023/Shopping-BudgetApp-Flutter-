import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/providers/currency_picker.dart';
import 'package:shopping_cart/providers/spending_provider.dart';
import 'package:shopping_cart/screens/budget_screen.dart';
import 'package:shopping_cart/screens/home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shopping_cart/widgets/sidebar.dart';

class SpendingScreen extends ConsumerStatefulWidget {
  const SpendingScreen({super.key});

  @override
  ConsumerState<SpendingScreen> createState() => _FutureListState();
}

class _FutureListState extends ConsumerState<SpendingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    final groceryCosts = ref.watch(categoryCostsProvider);
    final selectedCurrency = ref.watch(currencyProvider);
    final categoryCosts =
        groceryCosts['categoryCosts'] as List<Map<String, dynamic>>;

    final List<PieChartSectionData> pieChartSections =
        categoryCosts.map((item) {
      final category = item['category'];
      return PieChartSectionData(
        color: item['color'],
        value: item['totalCost'] ?? 0,
        title: '${category.title}',
        radius: 50,
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
        ),
        titlePositionPercentageOffset: 1.6,
      );
    }).toList();

    final allValuesZero =
        pieChartSections.every((section) => section.value == 0);

    if (allValuesZero) {
      pieChartSections.add(
        PieChartSectionData(
          color: const Color.fromARGB(255, 184, 143, 97),
          value: 1,
          title: 'No spending found',
          radius: 40,
          titleStyle: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    Widget content = SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Breakdown",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: pieChartSections,
                centerSpaceRadius: 40,
                sectionsSpace: 0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Category Allocation",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 5),
          allValuesZero
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 184, 143, 97),
                          borderRadius: BorderRadius.circular(10)),
                      child: const ListTile(
                        title: Text(
                          "No Spending Found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromARGB(223, 253, 254, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryCosts.length,
                  itemBuilder: (context, index) {
                    final category = categoryCosts[index];
                    final categoryEnum = categoryCosts[index]['category'];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          color: categoryEnum.color,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(
                          categoryEnum.title,
                          style: const TextStyle(
                              color: Color.fromARGB(223, 253, 254, 255),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        trailing: Text(
                          '${selectedCurrency?.symbol} ${category['totalCost'].toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Color.fromARGB(223, 253, 254, 255),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
        automaticallyImplyLeading: false,
        title: const Text("Spending"),
        centerTitle: true,
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
            ],
          ),
        ),
        child: content,
      ),
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
