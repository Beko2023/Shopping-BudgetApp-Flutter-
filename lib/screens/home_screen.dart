import 'package:flutter/material.dart';
import 'package:shopping_cart/screens/budget_screen.dart';
import 'package:shopping_cart/screens/spending_screen.dart';
import 'package:shopping_cart/screens/reminder_screen.dart';
import 'package:shopping_cart/widgets/shopping_list.dart';
import 'package:shopping_cart/widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  var currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReminderScreen()));
              },
              icon: const Icon(
                Icons.alarm,
                size: 30,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      drawer: const Drawer(child: SideBar()),
      body: const ShoppingCart(),
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
