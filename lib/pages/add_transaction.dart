import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/static.dart' as Static;

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 12),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(13.0),
          children: <Widget>[
            const Text(
              "Add transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 31.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Static.primaryColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    Icons.attach_money,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "0",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 30.0),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {}
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Static.primaryColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    Icons.attach_money,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Note on transaction",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                    // maxLength: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Static.primaryColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    Icons.abc,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text("Income",
                      style: TextStyle(
                          fontSize: 16.0,
                          color:
                              type == "Income" ? Colors.white : Colors.black)),
                  selectedColor: Static.primaryColor,
                  selected: type == "Income" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Expense",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: type == "Expense" ? Colors.white : Colors.black),
                  ),
                  selected: type == "Expense" ? true : false,
                  selectedColor: Static.primaryColor,
                  onSelected: (val) {
                    print(val);
                    if (val) {
                      setState(() {
                        type = "Expense";
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Static.primaryColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(
                        Icons.date_range,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "${selectedDate.day} ${months[selectedDate.month - 1]}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  if (amount != null && note.isNotEmpty) {
                    DbHelper dbHelper = DbHelper();
                    dbHelper.addData(amount!, selectedDate, note, type);
                    Navigator.of(context).pop();
                  } else {
                    print("Not all values provided");
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
