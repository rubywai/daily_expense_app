import 'package:daily_expense/database/expense_db.dart';
import 'package:daily_expense/database/model/expense_model.dart';
import 'package:daily_expense/ui/screen/save_screen.dart';
import 'package:daily_expense/utils/date_time_utils.dart';
import 'package:flutter/material.dart';

import '../widget/expense_list_detail_widget.dart';
import '../widget/expense_list_widget.dart';
import '../widget/expense_total_cost_widget.dart';
//sqflite
//drift (ORM)
//dictionary

//firestore (mongo db)
//postgres sql (supabase)

class Home extends StatefulWidget {
  const Home({Key? key, required this.expenseDatabaseHelper}) : super(key: key);
  final ExpenseDatabaseHelper expenseDatabaseHelper;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 late  Future<List<ExpenseModel>> _todayExpenseFuture = widget.expenseDatabaseHelper.getAllExpenseByDate(todayDate());
 late Future<Map<String,dynamic>> _todayCostFuture = widget.expenseDatabaseHelper.totalCostOfToday(todayDate());
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Daily Expanse(Today ${todayDate()})'),
      centerTitle: true,),
      body: ExpenseListDetailWidget(todayCostFuture: _todayCostFuture, todayExpenseFuture: _todayExpenseFuture),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          String? dialogResult =  await showDialog(
              context: context,
               builder: (context){
                  return  AlertDialog(
                    title: const Text('Enter your expense'),
                    content: SaveScreen(expenseDatabaseHelper: widget.expenseDatabaseHelper,),
                  );
               });
         if(dialogResult == "inserted"){
           setState(() {
             _todayExpenseFuture = widget.expenseDatabaseHelper.getAllExpenseByDate(todayDate());
             _todayCostFuture = widget.expenseDatabaseHelper.totalCostOfToday(todayDate());
           });
         }
        },
      ),
    );
  }
}






