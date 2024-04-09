import 'package:expense_tracker/expense_item.dart';

import './model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // item count is used to determine how many values will be passed into the listview
      itemCount: expenses.length,
      itemBuilder: (ctx, index) =>
          // Dismissible is a widget that allows you to delete a widget by swipping left or right
          Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(.75),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        // Key makes widget uniquely identify a widget and the data that is associated with it
        key: ValueKey(
          expenses[index],
        ),
        // on dismissed is called when the dismissed has left the screen
        onDismissed: (direction) => onRemoveExpense(expenses[index]),
        // the child is the item that can be swiped away
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
