import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BaseConverterApp());

// BaseConverterApp is the root widget of the application.
class BaseConverterApp extends StatelessWidget {
  const BaseConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Converter', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the primary color to blue
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Large, bold text for headings
          bodyLarge: TextStyle(fontSize: 18), // Standard body text
        ),
      ),
      home: const BaseConverterScreen(), // Set the home screen to BaseConverterScreen
    );
  }
}

// BaseConverterScreen is a StatefulWidget to handle dynamic changes in user input and selected bases.
class BaseConverterScreen extends StatefulWidget {
  const BaseConverterScreen({super.key});

  @override
  State<BaseConverterScreen> createState() => _BaseConverterScreenState();
}

// _BaseConverterScreenState manages the state of BaseConverterScreen
class _BaseConverterScreenState extends State<BaseConverterScreen> {
  int fromBase = 10; // Default 'from' base is decimal
  int toBase = 16; // Default 'to' base is hexadecimal
  final inputController = TextEditingController(); // Controller for the input field
  String result = 'Result number'; // Default result message

  // A map to describe base names
  final bases = {2: 'binary', 8: 'octal', 10: 'decimal', 16: 'hex'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: const Text(
            'Base Conversion', // Title of the app bar
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true, // Center the title in the app bar
        toolbarHeight: 70, // Set height of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around the body content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the content to fill the screen width
          children: [
            const SizedBox(height: 20),
            // Input field to enter the number for conversion
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Enter number', // Label for the input field
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear), // Clear button to reset input field
                  onPressed: _reset, // Reset the input field when pressed
                ),
              ),
              // Set keyboard type based on the 'fromBase'
              keyboardType: fromBase == 16 ? TextInputType.text : TextInputType.number,
              inputFormatters: [
                // Allow only valid characters based on selected base
                FilteringTextInputFormatter.allow(
                  RegExp(_getRegexForBase(fromBase)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Selector to choose 'From Base'
            _buildBaseSelector('From Base', true),
            const SizedBox(height: 20),
            // Selector to choose 'To Base'
            _buildBaseSelector('To base', false),
            const SizedBox(height: 40),
            // Buttons to perform actions (Convert, Reset, Swap)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    backgroundColor: Colors.green[300], // Green background
                    foregroundColor: Colors.black, // Black text
                  ),
                  onPressed: _convert, // Call the _convert function when pressed
                  child: const Text(
                    '= Convert', // Button label
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 50),
                    backgroundColor: Colors.red[300], // Red background
                    foregroundColor: Colors.black, // Black text
                  ),
                  onPressed: _reset, // Call the _reset function when pressed
                  child: const Text(
                    '× Reset', // Button label
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 50),
                    backgroundColor: Colors.grey[300], // Grey background
                    foregroundColor: Colors.black, // Black text
                  ),
                  onPressed: _swapBases, // Call the _swapBases function when pressed
                  child: const Text(
                    '⇄ Swap', // Button label
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Display the result of the conversion
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Grey border around the result
                borderRadius: BorderRadius.circular(4), // Rounded corners for the result box
              ),
              child: Text(
                result, // Show the result text
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center, // Center-align the result text
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the base selector dropdown for choosing 'From Base' or 'To Base'
  Widget _buildBaseSelector(String label, bool isFromBase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // Label for the dropdown
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: isFromBase ? fromBase : toBase, // Choose the value based on 'From Base' or 'To Base'
          isExpanded: true,
          items:
              bases.keys.map((base) {
                return DropdownMenuItem(
                  value: base,
                  child: Text('$base (${bases[base]})'), // Show base value and its name (binary, decimal, etc.)
                );
              }).toList(),
          onChanged:
              (value) => setState(() {
                // Update the corresponding base when a new value is selected
                if (isFromBase) {
                  fromBase = value!;
                } else {
                  toBase = value!;
                }
              }),
        ),
      ],
    );
  }

  // Function to return the regex pattern based on the selected base
  String _getRegexForBase(int base) {
    switch (base) {
      case 2:
        return r'^[0-1]*$'; // Binary: Only 0 and 1 allowed
      case 8:
        return r'^[0-7]*$'; // Octal: Only digits 0-7 allowed
      case 10:
        return r'^[0-9]*$'; // Decimal: Only digits 0-9 allowed
      case 16:
        return r'^[0-9a-fA-F]*$'; // Hexadecimal: Digits 0-9 and letters A-F allowed
      default:
        return ''; // Default: No input allowed
    }
  }

  // Function to perform the conversion from 'fromBase' to 'toBase'
  void _convert() {
    final input = inputController.text; // Get the input from the user
    if (input.isEmpty) {
      setState(() => result = 'Please enter a number'); // Display error if input is empty
      return;
    }

    try {
      // Convert the input to a decimal number based on 'fromBase'
      final decimalValue = int.parse(input, radix: fromBase);
      setState(() {
        // Convert the decimal number to the desired 'toBase' and display the result in uppercase
        result = decimalValue.toRadixString(toBase).toUpperCase();
      });
    } catch (e) {
      setState(() => result = 'Invalid input'); // Display error if conversion fails
    }
  }

  // Function to reset the input and result
  void _reset() {
    setState(() {
      inputController.clear(); // Clear the input field
      result = 'Result number'; // Reset the result text
    });
  }

  // Function to swap 'fromBase' and 'toBase'
  void _swapBases() {
    setState(() {
      final temp = fromBase;
      fromBase = toBase;
      toBase = temp; // Swap the values of 'fromBase' and 'toBase'
    });
  }
}
