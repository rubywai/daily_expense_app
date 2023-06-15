import 'package:daily_expense/database/expense_db.dart';
import 'package:daily_expense/inherited_widget/database_provider.dart';
import 'package:daily_expense/ui/widget/expense_total_cost_widget.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late DatabaseProvider databaseProvider;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    databaseProvider = DatabaseProvider.of(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String,double>>(
        future: _priceMap(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            Map<String,double> priceMap = snapshot.data ?? {};
            return SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: priceMap.entries.map((e){
                      return ListTile(
                        title: Text(e.key),
                        trailing: Text('${e.value.toInt()} Ks' ),
                      );
                    }).toList(),
                  ),
                  Divider(),
                  PieChart(dataMap: priceMap,
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 0,
                    ),)
                ],
              ),
            );

          }
          else if(snapshot.hasError){
            return const Center(child: Text('Something wrong'),);
          }
          return const Center(child: CircularProgressIndicator.adaptive(),);
        },
      )
    );
  }
  Future<Map<String,double>> _priceMap() async{
    Map<String,double> priceMap = {};
    List<Map<String,dynamic>> uniqueCategoryList = await databaseProvider.expenseDatabaseHelper.getUniqueCategory();
    for (var value in uniqueCategoryList) {
      String category = value['category'];
      Map<String,dynamic> totalCostByCategory = await databaseProvider.expenseDatabaseHelper.totalCostByCategory(category);
      print('total cost $totalCostByCategory');
      double price = double.tryParse(totalCostByCategory['SUM(cost)'].toString()) ?? 0;
      priceMap[category] = price;
    }
    return priceMap;
  }
}
