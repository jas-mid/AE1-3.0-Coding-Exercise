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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 31, 58, 95),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 242, 243, 240),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 31, 58, 95),
          foregroundColor: Colors.white,
        ),
      ),
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
  // Stating variables

  // Initial values for the amounts and currencies
  double _amountOne = 0;
  double _amountTwo = 0;
  String _currencyOne = "USD";
  String _currencyTwo = "EUR";
  // Normalised currency values to USD for conversion
  final Map<String, double> _currenciesDollarNormalised = {
    "USD": 1.0,
    "EUR": 0.89,
    "GBP": 0.74,
    "JPY": 158.47,
    "NGN": 1344.44,
    "CAD": 1.4,
    "CNY": 6.67,
  };
  //Controller to update the input box value on reset
  final TextEditingController _inputController = TextEditingController();

  // Methods

  // Working out the output amount based on the input amount and currencies
  double get _convertedAmount =>
      _amountOne *
      _currenciesDollarNormalised[_currencyTwo]! /
      _currenciesDollarNormalised[_currencyOne]!;

  // Converts the output variable to the calculated amount
  void _convert() {
    setState(() {
      _amountTwo = _convertedAmount;
    });
  }

  // Building the UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(34.0),
        // Start of page formatting
        child: Column(
          children: [
            // Row for the first currency selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text labelling selector box
                Text('Convert from:'),
                SizedBox(width: 10),
                // Dropdown selector to choose currency
                DropdownButton<String>(
                  value: _currencyOne,
                  focusColor: Colors.transparent,
                  items: _currenciesDollarNormalised.keys.map((
                    String currency,
                  ) {
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
              ],
            ),
            // Input for the amount to convert
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(labelText: 'Input Amount'),
              onChanged: (value) {
                setState(() {
                  _amountOne = (double.tryParse(value) ?? 0)
                      .clamp(0, double.infinity)
                      .toDouble();
                });
                _convert(); // Automatically convert when the input amount changes
              },
            ),
            SizedBox(height: 20),
            // Row for second currency select
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text labelling selector box
                Text('Convert to:'),
                SizedBox(width: 10),
                // Dropdown selector to choose output currency
                DropdownButton<String>(
                  value: _currencyTwo,
                  focusColor: Colors.transparent,
                  items: _currenciesDollarNormalised.keys.map((
                    String currency,
                  ) {
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
              ],
            ),
            SizedBox(height: 10),
            // Label displaying the conversion rate
            Text(
              'Conversion Rate: 1 $_currencyOne = ${(_currenciesDollarNormalised[_currencyTwo]! / _currenciesDollarNormalised[_currencyOne]!).toStringAsFixed(2)} $_currencyTwo',
              style: style,
            ),
            // Output field displaying the converted amount
            TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Converted Amount:',
                border: InputBorder.none,
                floatingLabelAlignment: FloatingLabelAlignment.center,
              ),
              readOnly: true,
              controller: TextEditingController(
                text: _amountTwo.toStringAsFixed(2),
              ),
            ),
            SizedBox(height: 20),
            // Row containing the swap and reset buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Swap currencies button
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
                // Reset button to reset the currencies and amounts to default values
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _currencyOne = "USD";
                    _currencyTwo = "EUR";
                    _amountOne = 0;
                    _inputController.clear(); // Clear the input field
                    _convert();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
