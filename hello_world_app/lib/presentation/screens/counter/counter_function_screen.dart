import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- Paquete para usar la fuente Caslon

class CounterFunctionScreen extends StatefulWidget {
  const CounterFunctionScreen({super.key});

  @override
  State<CounterFunctionScreen> createState() =>
      _CounterFunctionScreenState();
}

class _CounterFunctionScreenState extends State<CounterFunctionScreen> {
  int clickCounter = 0;

  // Método helper para determinar el color según el valor del contador
  Color _getCounterColor() {
    if (clickCounter > 0) {
      return Colors.green;
    } else if (clickCounter < 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Counter Screen',
            style: GoogleFonts.libreCaslonText(), // <-- Caslon aplicada al título
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                setState(() {
                  clickCounter = 0;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$clickCounter',
                style: GoogleFonts.libreCaslonText( // <-- Caslon aplicada al número
                  fontSize: 160,
                  fontWeight: FontWeight.w100,
                  color: _getCounterColor(),
                ),
              ),
              Text(
                'Click${clickCounter == 1 || clickCounter == -1 ? '' : 's'}',
                style: GoogleFonts.libreCaslonText( // <-- Caslon aplicada al texto 'Clicks'
                  fontSize: 25,
                  color: _getCounterColor(),
                ),
              ),
            ],
          ),
        ),
          
        // Botones para sumar y restar
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              FloatingActionButton(
              shape: const StadiumBorder(),
              onPressed: () {
                setState(() {
                  clickCounter = 0;
                });
              },
              child: const Icon(Icons.refresh_outlined),
            ),
          
            // Botón para sumar
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  clickCounter++;
                });
              },
              child: const Icon(Icons.plus_one),
            ),

            const SizedBox(height: 10),

            // Botón para restar
            FloatingActionButton(
              shape: const 
              onPressed: () {
                setState(() {
                  clickCounter--;
                });
              },
              child: const Icon(Icons.exposure_minus_1),
            ),
          ],
        ),
      ),
    );
  }
}