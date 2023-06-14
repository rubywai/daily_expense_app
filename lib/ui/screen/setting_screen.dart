import 'package:daily_expense/database/expense_db.dart';
import 'package:daily_expense/ui/widget/expense_total_cost_widget.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  final ExpenseDatabaseHelper expenseDatabaseHelper;
  const SettingScreen({Key? key, required this.expenseDatabaseHelper}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Map<String,dynamic>>>(
              future: widget.expenseDatabaseHelper.getUniqueCategory(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<Map<String,dynamic>> uniQueCategoryList = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.builder(
                        itemCount: uniQueCategoryList.length,
                        itemBuilder: (context,position){
                          Map<String,dynamic> category = uniQueCategoryList[position];
                          return ListTile(
                            title: Text(category['category'] ?? ''),
                            trailing: ExpenseTotalCost(
                              todayCostFuture: widget.expenseDatabaseHelper.totalCostByCategory(category['category'] ?? ''),
                            ),
                          );
                        }),
                  );
                }
                else if(snapshot.hasError){
                  return const Center(child: Text('Something wrong'),);
                }
                return const Center(child: CircularProgressIndicator(),);
              })
        ],
      ),
    );
  }
}
