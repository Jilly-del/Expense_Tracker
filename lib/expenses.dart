import 'package:expense_tracker/chart.dart';
import 'package:expense_tracker/new_expense.dart';
import 'package:flutter/material.dart';
import './model/expense.dart';
import './expense_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 15,
        date: DateTime.now(),
        category: Category.leisure)
  ];
  void _openAddExpenseOverlay() {
    // modal bottom sheet is used to create a page that contains stuffs that
    //would appear on a screen onces its being called and disappears once the backgroud is clicked
    showModalBottomSheet(
        // isControlled is used to make show modal bottom sheet cover the whole screen
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpenses: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

// is used to clear all scaffold message before another one drops
    ScaffoldMessenger.of(context).clearSnackBars();

    // scafoldmessenger is used to show a message at the bottom of your screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                _registeredExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found, start adding some!.'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        // Actions is used to add a button to the app bar
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
