import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/helpers/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:cash_compass/helpers/db.dart';

class RenderIncomeExpense extends StatefulWidget {
  final List<Transaction> transactions;

  const RenderIncomeExpense({super.key, required this.transactions});

  @override
  State<RenderIncomeExpense> createState() => _RenderIncomeExpenseState();
}

class _RenderIncomeExpenseState extends State<RenderIncomeExpense> {
  @override
  Widget build(BuildContext context) {
    List<CurrencyTransactions> currencyWise =
        groupTransactionsByCurrency(widget.transactions);

    return ListTile(
      title: Row(
        children: <Widget>[
          BorderedItem(
            currencyWise: currencyWise,
            type: incomeConstant,
            color: customColorPrimary,
            backgroundColor: lightBlue!,
          ),
          const SizedBox(
            width: 12,
          ),
          BorderedItem(
              currencyWise: currencyWise,
              type: expensConstant,
              color: orange,
              backgroundColor: orange.withAlpha(50)),
        ],
      ),
    );
  }
}

class BorderedItem extends StatelessWidget {
  final List<CurrencyTransactions> currencyWise;
  final String type;
  final Color color;
  final Color backgroundColor;

  const BorderedItem({
    super.key,
    required this.currencyWise,
    required this.type,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    
    double summaryTotalAmount = 0.0;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Your background color
          border:
              Border.all(color: color, width: 1), // Your border color and width
          borderRadius: BorderRadius.circular(10), // Your border radius
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12.0, vertical: 8.0), // Your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(color: color, fontSize: 14),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 6,
              ),
              ...currencyWise.map((currency) {
                double totalAmount = (type == incomeConstant
                        ? currency.income
                        : currency.expense)
                    .fold(
                        0.0,
                        (previousValue, element) =>
                            previousValue + element.amount);

                String currencySymbol = currencies.firstWhere(
                  (element){
                    if(element['currency'] == currencies[1]['currency']){
                      summaryTotalAmount = (totalAmount * 15900) + summaryTotalAmount;
                    } else if(element['currency'] == currencies[2]){
                      summaryTotalAmount = (totalAmount * 16800) + summaryTotalAmount;
                    }
                    return element['currency'] == currency.currency;
                  },
                  orElse: () => {'symbol': currency.currency},
                )['symbol'];

                return Text(
                  '$currencySymbol  ${totalAmount.toInt()}',
                  style: TextStyle(
                      color: color, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                );
              }).toList(),
              const SizedBox(
                height: 8,
              ),
              Text(
                  'Total : Rp.${summaryTotalAmount.toInt()}',
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.start,
              )
            ],
          ),
        ),
      ),
    );
  }
}
