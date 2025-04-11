import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BaseConverterApp());

class BaseConverterApp extends StatelessWidget {
  const BaseConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18),
        ),
      ),
      home: const BaseConverterScreen(),
    );
  }
}

class BaseConverterScreen extends StatefulWidget {
  const BaseConverterScreen({super.key});

  @override
  State<BaseConverterScreen> createState() => _BaseConverterScreenState();
}

class _BaseConverterScreenState extends State<BaseConverterScreen> {
  int fromBase = 10;
  int toBase = 16;
  final inputController = TextEditingController();
  String result = 'Result number';

  final bases = {2: 'binary', 8: 'octal', 10: 'decimal', 16: 'hex'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: const Text(
            'Base Conversion',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Enter number',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _reset,
                ),
              ),
              keyboardType:
                  fromBase == 16 ? TextInputType.text : TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(_getRegexForBase(fromBase)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildBaseSelector('From Base', true),
            const SizedBox(height: 20),
            _buildBaseSelector('To base', false),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _convert,
                  child: const Text(
                    '= Convert',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 50),
                    backgroundColor: Colors.red[300],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _reset,
                  child: const Text(
                    '× Reset',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 50),
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _swapBases,
                  child: const Text(
                    '⇄ Swap',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaseSelector(String label, bool isFromBase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: isFromBase ? fromBase : toBase,
          isExpanded: true,
          items:
              bases.keys.map((base) {
                return DropdownMenuItem(
                  value: base,
                  child: Text('$base (${bases[base]})'),
                );
              }).toList(),
          onChanged:
              (value) => setState(() {
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

  String _getRegexForBase(int base) {
    switch (base) {
      case 2:
        return r'^[0-1]*$';
      case 8:
        return r'^[0-7]*$';
      case 10:
        return r'^[0-9]*$';
      case 16:
        return r'^[0-9a-fA-F]*$';
      default:
        return '';
    }
  }

  void _convert() {
    final input = inputController.text;
    if (input.isEmpty) {
      setState(() => result = 'Please enter a number');
      return;
    }

    try {
      final decimalValue = int.parse(input, radix: fromBase);
      setState(() {
        result = decimalValue.toRadixString(toBase).toUpperCase();
      });
    } catch (e) {
      setState(() => result = 'Invalid input');
    }
  }

  void _reset() {
    setState(() {
      inputController.clear();
      result = 'Result number';
    });
  }

  void _swapBases() {
    setState(() {
      final temp = fromBase;
      fromBase = toBase;
      toBase = temp;
    });
  }
}
