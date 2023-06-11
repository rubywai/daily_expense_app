import 'package:daily_expense/database/expense_db.dart';
import 'package:daily_expense/ui/screen/expense_list_detail_screen.dart';
import 'package:daily_expense/ui/widget/expense_total_cost_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllExpenseList extends StatefulWidget {
  const AllExpenseList({Key? key, required this.expenseDatabaseHelper})
      : super(key: key);
  final ExpenseDatabaseHelper expenseDatabaseHelper;

  @override
  State<AllExpenseList> createState() => _AllExpenseListState();
}

class _AllExpenseListState extends State<AllExpenseList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: widget.expenseDatabaseHelper.getDateList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> dateList = snapshot.data ?? [];
            return Column(
              children: [
                AppBar(),
                Text('${dateList.length} days'),
                ExpenseTotalCost(todayCostFuture: widget.expenseDatabaseHelper.totalCost()),
                Expanded(
                  child: ListView.builder(
                      itemCount: dateList.length,
                      itemBuilder: (context, position) {
                        String date = dateList[position];
                        return InkWell(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder:  (_) =>
                                    ExpenseListDetailScreen(
                                        todayCostFuture: widget.expenseDatabaseHelper.totalCostOfToday(date),
                                        todayExpenseFuture: widget.expenseDatabaseHelper.getAllExpenseByDate(date),
                                        date: date)));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(date),
                              trailing: ExpenseTotalCost(todayCostFuture: widget.expenseDatabaseHelper.totalCostOfToday(date),),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
          else if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'),);
          }
          return const Center(child: CircularProgressIndicator.adaptive(),);
        });
  }
}
