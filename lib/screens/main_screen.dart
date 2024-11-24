import 'package:cash_compass/components/transaction/render_income_expense.dart';
import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/helpers/db.dart';
import 'package:cash_compass/helpers/transaction_helpers.dart';
import 'package:cash_compass/screens/crud_transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    var dbHelper = DatabaseHelper();
    transactions = await dbHelper.getTransactions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final months = getMonths();

    return DefaultTabController(
      length: months.length,
      initialIndex: months.length - 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 25.0,
                width: 25.0,
              ),
              const SizedBox(width: 8.0),
              const Text('CashCompass',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ],
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: months.map((month) {
              // Formats the date as "Month Year"
              String monthYear = DateFormat('MMMM yyyy').format(month);
              return Tab(text: monthYear.toUpperCase());
            }).toList(),
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: months.map((month) {
            // Get the transactions for the month
            List<Transaction> monthTransactions =
                transactions.where((transaction) {
              DateTime transactionDate = DateTime.parse(transaction.date);
              return transactionDate.month == month.month &&
                  transactionDate.year == month.year;
            }).toList();

            // if there are no transactions for the month, render a message
            if (monthTransactions.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No transactions for this month',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Start adding transactions by clicking the +',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }

            // Group transactions by date
            Map<String, List<Transaction>> groupedTransactions =
                groupTransactionsByDate(monthTransactions);

            return ListView.builder(
              itemCount: groupedTransactions.length + 1,
              padding: const EdgeInsets.only(
                top: 12,
              ),
              itemBuilder: (BuildContext context, int index) {
                // Render total income and expense in the first row

                double incomeTotal = 0.0;
                double expenseTotal = 0.0;
                monthTransactions.forEach((transaction){
                  if(transaction.type == incomeConstant){
                    var summaryTotalAmount = 0.0;
                    if(transaction.currency == currencies[1]['currency']){
                      print("DOLLAR");
                      summaryTotalAmount = (transaction.amount * 15900) + summaryTotalAmount;
                    } else if(transaction.currency == currencies[2]['currency']){
                      summaryTotalAmount = (transaction.amount * 16800) + summaryTotalAmount;
                    } else {
                      summaryTotalAmount = transaction.amount;
                    }
                    incomeTotal = incomeTotal + summaryTotalAmount;
                  }

                  if(transaction.type == expensConstant){
                    var summaryTotalAmount = 0.0;
                    if(transaction.currency == currencies[1]['currency']){
                      print("DOLLAR");
                      summaryTotalAmount = (transaction.amount * 15900) + summaryTotalAmount;
                    } else if(transaction.currency == currencies[2]['currency']){
                      summaryTotalAmount = (transaction.amount * 16800) + summaryTotalAmount;
                    } else {
                      summaryTotalAmount = transaction.amount;
                    }
                    expenseTotal = expenseTotal + summaryTotalAmount;
                  }
                });
                print("INCOME -> ${incomeTotal}");
                print("EXPENSE -> ${expenseTotal}");

                if(index == 0){
                  var income = (incomeTotal/ (incomeTotal+expenseTotal) * 100);
                  var expense = (expenseTotal/ (incomeTotal+expenseTotal) * 100);

                  PieChartData pieChartData = PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: income.truncateToDouble(),
                        color: customColorPrimary,
                        titleStyle: TextStyle(color: Colors.white),
                        title: "${income.toStringAsFixed(0)}%"
                      ),
                      PieChartSectionData(
                        value: expense.truncateToDouble(),
                        color: orange,
                        titleStyle: TextStyle(color: Colors.white),
                        title: "${expense.toStringAsFixed(0)}%"
                      )
                    ],
                  );
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text("Summary", style: TextStyle( fontSize: 24)),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: PieChart(pieChartData),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        RenderIncomeExpense(transactions: monthTransactions)
                    ],
                  );
                }

                String date = groupedTransactions.keys.elementAt(index - 1);
                List<Transaction> transactionsForDate =
                    groupedTransactions[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.0, // 100% of the width
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 12,
                          bottom: 4,
                        ),
                        color: lightBlue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            DateFormat('d MMMM yyyy')
                                .format(DateTime.parse(date)),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // txns
                    ...transactionsForDate.map((transaction) {
                      Color color = transaction.type == incomeConstant
                          ? customColorPrimary
                          : orange;

                      String currencySymbol = currencies.firstWhere(
                        (element) =>
                            element['currency'] == transaction.currency,
                        orElse: () => {'symbol': transaction.currency},
                      )['symbol'];

                      IconData icon = (transactionTypes.firstWhere(
                        (element) => element['name'] == transaction.type,
                      )['categories'] as List)
                          .firstWhere(
                        (element) => element['name'] == transaction.category,
                        orElse: () => {'icon': Icons.category},
                      )['icon'];

                      return ListTile(
                        leading: Icon(icon, color: color, size: 36.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.category,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0)),

                            // If the transaction has a note, render it
                            if (transaction.note != '')
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  transaction.note,
                                  style: const TextStyle(fontSize: 14.0),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          '$currencySymbol ${transaction.amount.toInt()}',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        onTap: () {
                          // your tap handling logic here, for example:
                          debugPrint('Transaction ${transaction.id} tapped');
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => CrudTransaction(
                                transaction: transaction,
                              ),
                            ),
                          )
                              .then((_) {
                            // Fetch the transactions again after returning from the CrudTransaction page
                            fetchTransactions();
                          });
                        },
                      );
                    }).toList(),
                  ],
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => const CrudTransaction(),
              ),
            )
                .then((_) {
              // Fetch the transactions again after returning from the CrudTransaction page
              fetchTransactions();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}


List<PieChartSectionData> groupTransactionsByType(List<Transaction> transactions, CurrecyCategory type, double totalAmount) {
  List<String> allCategory = [];
  List<PieChartSectionData> listPieChartSectionData = [];

  for (var transaction in transactions) {
    if (!allCategory.contains(transaction.category)) {
      allCategory.add(transaction.category);
    }
  }
  
  int index = 0;
  for (var category in allCategory) {
    List<Transaction> transactionData;

    if (type == CurrecyCategory.ALL) {
      transactionData = transactions
          .toList();
    } else if (type == CurrecyCategory.INCOME) {
      transactionData = transactions
          .where((transaction) => transaction.type == incomeConstant && transaction.category == category)
          .toList();
    } else if (type == CurrecyCategory.EXPENSE) {
      transactionData = transactions
          .where((transaction) => transaction.type == expensConstant && transaction.category == category)
          .toList();
    } else {
      transactionData = []; // Default empty if type doesn't match
    }

    double summaryTotalAmount = 0.0;

    print("INDEXXXX ${index}");

    for (var transaction in transactionData) {
      if(transaction.currency == currencies[1]['currency']){
        summaryTotalAmount = (transaction.amount * 15900) + summaryTotalAmount;
      } else if(transaction.currency == currencies[2]['currency']){
        summaryTotalAmount = (transaction.amount * 16800) + summaryTotalAmount;
      } else {
        summaryTotalAmount = transaction.amount;
      }

      print("tr amount ${summaryTotalAmount}");
      print("total amount $totalAmount");
      print("akhir ${(summaryTotalAmount / totalAmount) * 100}");

      listPieChartSectionData.add(PieChartSectionData(
        value: ((summaryTotalAmount / totalAmount) * 100).truncateToDouble(),
        color: getRandomColor()
      ));
      
      index++;
    }
  }

  return listPieChartSectionData;
}


enum CurrecyCategory { ALL, INCOME, EXPENSE }
