import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  // State variables
  double _amountOne = 0;
  double _amountTwo = 0;
  String _currencyOne = "USD";
  String _currencyTwo = "EUR";
  Map<String, double> _currenciesDollarNormalised = {
    "USD": 1.0,
    "EUR": 0.89,
    "GBP": 0.74,
    "JPY": 158.47,
    "NGN": 1344.44,
  };

  // methods
  double get _convertedAmount =>
      _amountOne *
      _currenciesDollarNormalised[_currencyTwo]! /
      _currenciesDollarNormalised[_currencyOne]!;
}
