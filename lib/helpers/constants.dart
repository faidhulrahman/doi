import 'dart:math';

import 'package:flutter/material.dart';

String expensConstant = 'Expense';
String incomeConstant = 'Income';
const Color customColorPrimary = Color(0xFF4335A7);
const Color lightBlue = Color(0xFFE3F2FD);
const Color orange = Color(0xFFFF7F3E);
const Color customDangerColor = Colors.red;

List expenseCategories = [
  {
    'name': 'Food',
    'icon': Icons.fastfood,
  },
  {
    'name': 'Transport',
    'icon': Icons.directions_car,
  },
  {
    'name': 'Shopping',
    'icon': Icons.shopping_bag,
  },
  {
    'name': 'Entertainment',
    'icon': Icons.movie,
  },
  {
    'name': 'Health',
    'icon': Icons.local_hospital,
  },
  {
    'name': 'Education',
    'icon': Icons.school,
  },
  {
    'name': 'Travel',
    'icon': Icons.flight,
  },
  {
    'name': 'Other',
    'icon': Icons.category,
  }
];

List incomeCategories = [
  {
    'name': 'Salary',
    'icon': Icons.work,
  },
  {
    'name': 'Business',
    'icon': Icons.business,
  },
  {
    'name': 'Gifts',
    'icon': Icons.card_giftcard,
  },
  {
    'name': 'Investments',
    'icon': Icons.attach_money,
  },
  {
    'name': 'Other',
    'icon': Icons.category,
  }
];

List transactionTypes = [
  {
    'name': incomeConstant,
    'icon': Icons.attach_money,
    'color': customColorPrimary,
    'categories': incomeCategories
  },
  {
    'name': expensConstant,
    'icon': Icons.shopping_cart,
    'color': orange,
    'categories': expenseCategories
  }
];

List currencies = [
  {'currency': 'IDR', 'symbol': 'Rp'},
  {'currency': 'USD', 'symbol': '\$'},
  {'currency': 'EUR', 'symbol': '€'}
];

List<Color> chartColor = [
  Colors.amber,
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.amberAccent,
  Colors.black,
  Colors.white,
];

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255, // Opasitas penuh
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
  );
}
