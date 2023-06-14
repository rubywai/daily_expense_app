import 'package:daily_expense/database/expense_db.dart';
import 'package:daily_expense/ui/screen/all_expense_list_screen.dart';
import 'package:daily_expense/ui/screen/home.dart';
import 'package:daily_expense/ui/screen/setting_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final ExpenseDatabaseHelper expenseDatabaseHelper;
  const MainScreen({Key? key, required this.expenseDatabaseHelper}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget _body = Home(expenseDatabaseHelper: widget.expenseDatabaseHelper);
  late List<Widget> _bodyList;
  int _selectNavigationInex = 0;
  @override
  void initState() {
    super.initState();
    _bodyList = [Home(expenseDatabaseHelper: widget.expenseDatabaseHelper),
     AllExpenseList(expenseDatabaseHelper: widget.expenseDatabaseHelper),
     SettingScreen(expenseDatabaseHelper: widget.expenseDatabaseHelper,)];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectNavigationInex,
        onDestinationSelected: (index){
          setState(() {
            _body = _bodyList[index];
            _selectNavigationInex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list), label: 'All Expense'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
