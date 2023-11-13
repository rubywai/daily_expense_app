import 'package:flutter/material.dart';

import '../../database/model/expense_model.dart';

class ExpenseListWidget extends StatefulWidget {
  const ExpenseListWidget({
    super.key,
    required Future<List<ExpenseModel>> expenseFuture, this.delete,
  }) : _expenseFuture = expenseFuture;

  final Future<List<ExpenseModel>> _expenseFuture;
  final Function(int)? delete;

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseModel>>(
      future: widget._expenseFuture,
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<ExpenseModel> expenseList = snapshot.data ?? [];
          return ListView.builder(
              key: const PageStorageKey('expense_list'),
              itemCount: expenseList.length,
              itemBuilder: (context,position){
                ExpenseModel expenseModel = expenseList[position];
                DateTime? time = DateTime.tryParse(expenseModel.time ?? '');
                return Column(
                  children: [
                    if(time != null)
                      Text('${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}'),
                    Card(
                      child: ListTile(
                        leading: widget.delete == null ?
                        const Text('') :
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if(expenseModel.id != null && widget.delete != null) {
                              widget.delete!(expenseModel.id!);
                            }
                          },
                        ),
                        title: Text(expenseModel.name ?? ''),
                        subtitle: Text('${expenseModel.cost} S\$'),
                        trailing: Text(expenseModel.category ?? ''),
                      ),
                    ),
                  ],
                );
              });
        }
        else if(snapshot.hasError){
          return Center(child: Text('error ${snapshot.error}'),);
        }
        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}