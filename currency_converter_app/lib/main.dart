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
    "CAD": 1.4,
    "CNY": 6.67,
  };

  // methods
  double get _convertedAmount =>
      _amountOne *
      _currenciesDollarNormalised[_currencyTwo]! /
      _currenciesDollarNormalised[_currencyOne]!;

  void _convert() {
    setState(() {
      _amountTwo = _convertedAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _currencyOne,
              items: _currenciesDollarNormalised.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currencyOne = newValue!;
                });
                _convert(); // Automatically convert when the first currency changes
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Input Amount'),
              onChanged: (value) {
                setState(() {
                  _amountOne = double.tryParse(value) ?? 0;
                });
                _convert(); // Automatically convert when the input amount changes
              },
            ),
            DropdownButton<String>(
              value: _currencyTwo,
              items: _currenciesDollarNormalised.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currencyTwo = newValue!;
                  _convert(); // Automatically convert when the second currency changes
                });
              },
            ),
            Text(
              'Conversion Rate: 1 ${_currencyOne} = ${(_currenciesDollarNormalised[_currencyTwo]! / _currenciesDollarNormalised[_currencyOne]!).toStringAsFixed(2)} ${_currencyTwo}',
              style: style,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Converted Amount'),
              readOnly: true,
              controller: TextEditingController(
                text: _amountTwo.toStringAsFixed(2),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String tempCurrency =
                    _currencyTwo; // Placeholder for the first currency
                _currencyTwo = _currencyOne; // Set the first currency to the second currency
                _currencyOne = tempCurrency; // Set the second currency to the first currency
                _convert();
              },
              child: const Text('Swap Currencies'),
            ),
          ],
        ),
      ),
    );
  }
}
