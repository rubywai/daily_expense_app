import 'package:daily_expense/ui/screen/save_screen.dart';
import 'package:flutter/material.dart';

class AutoCompleteCategoryList extends StatefulWidget {
  const AutoCompleteCategoryList({
    super.key,
    required this.widget,
    required String? cost,
    required this.onSelect,
  });

  final SaveScreen widget;
  final Function(String) onSelect;

  @override
  State<AutoCompleteCategoryList> createState() =>
      AutoCompleteCategoryListState();
}

class AutoCompleteCategoryListState extends State<AutoCompleteCategoryList> {
  String? cate;
  List<String> expense = [];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: FutureBuilder<List<String>>(
        future: widget.widget.expenseDatabaseHelper.getCategoryList(cate ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            expense = snapshot.data ?? [];
            if (expense.isEmpty || (cate ?? '').isEmpty) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < expense.length; i++)
                      InkWell(
                        onTap: () {
                          widget.onSelect(expense[i]);
                        },
                        child: ListTile(
                          title: Text(expense[i]),
                        ),
                      )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error something wrong ${snapshot.error}'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void reload(String cate) {
    setState(() {
      this.cate = cate;
    });
  }
}
