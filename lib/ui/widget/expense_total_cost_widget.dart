import 'package:flutter/material.dart';

class ExpenseTotalCost extends StatelessWidget {
  const ExpenseTotalCost({
    super.key,
    required Future<Map<String, dynamic>> todayCostFuture,
  }) : _todayCostFuture = todayCostFuture;

  final Future<Map<String, dynamic>> _todayCostFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
        future: _todayCostFuture,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Text('Total cost - ${snapshot.data?['SUM(cost)']} Ks',
              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),);
          }
          else if(snapshot.hasError){
            return const Text('Something wrong');
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}