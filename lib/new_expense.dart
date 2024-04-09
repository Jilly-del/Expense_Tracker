import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpenses});
  final void Function(Expense expense) onAddExpenses;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // text editing controller is used to manage user input auntomatically by flutter instead of managing it manually with onchanged

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1, now.month, now.day);
    // ShowDatepicker is a used to show a calendar
    // The reason async and await are used is because in the future the function would receive some value so we had to make flutter
    final pickedDate = await showDatePicker(
        context: context,
        // initial date is the date that shows up immediately
        initialDate: now,
        // firstDate is/are the previous that would show up
        firstDate: firstDate,
        lastDate: now);
    setState(
      () {
        _selectedDate = pickedDate;
      },
    );
  }

  void _submitExpenseData() {
    // double.try parse is used to take a string and change it to a number
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // trim is used to remove white space before and after a text
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Show Dialog is used to display a message
      showDialog(
        context: context,
        // alert Dialog is used to show an alert message
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );

      return;
    }
    widget.onAddExpenses(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          // Text field is like an Input Field where the user gets to type in somethings
          TextField(
            // controller is used to called the texteditingcontroller variable
            controller: _titleController,
            decoration: const InputDecoration(
              // hintMaxline is the number of characters that can be assigned to the textfield
              hintMaxLines: 50,
              // label is used to name the text field
              label: Text('Title'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    // This a text  that is put on the screen during production
                    prefixText: '\$',
                    label: Text('Amount'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              // expanded is used so a widget take up space its needs only
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date Selected'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),

          Row(
            children: [
              DropdownButton(
                // the value below is what is value the onchanged would receive from flutter
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                // The value for the unchanged is gotten from the value choosen in the dropdown
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectedCategory = value;
                    },
                  );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Naivigator.pop is used to close a current screen and return to a previous screen
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expenses'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
