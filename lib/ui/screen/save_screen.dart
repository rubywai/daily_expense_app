import 'package:daily_expense/database/expense_db.dart';
import 'package:flutter/material.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key, required this.expenseDatabaseHelper}) : super(key: key);
  final ExpenseDatabaseHelper expenseDatabaseHelper;

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _name,_cost,_category;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (name){
                if(name == null || name.isEmpty){
                  return 'Please enter your name';
                }
              return null;
              },
              onSaved: (name){
                _name = name;
              },
              decoration: const InputDecoration(
                labelText: 'Name'
              ),
            ),
            TextFormField(

              validator: (cost){
                if(cost == null || cost.isEmpty){
                  return 'Please enter your cost';
                }
                return null;
              },
              onSaved: (cost){
                _cost = cost;
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Cost'
              ),
            ),
            TextFormField(
              validator: (category){
                if(category == null || category.isEmpty){
                  return 'Please enter your category';
                }
                return null;
              },
              onSaved: (category){
                _category = category;
              },
              decoration: const InputDecoration(
                  labelText: 'Category'
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cancel')),
            ElevatedButton(onPressed: () async{
              _formKey.currentState?.save();
              if(_formKey.currentState?.validate() ??false){
                DateTime now = DateTime.now();
                double? cost = double.tryParse(_cost!);
                if(cost != null) {
                  await widget.expenseDatabaseHelper.insertExpense(name: _name!, cost: cost, time: now.toString(), category: _category!);
                  if(mounted) {
                    Navigator.pop(context,"inserted");
                    ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Successfully Save')));
                  }
                }
              }
            }, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
