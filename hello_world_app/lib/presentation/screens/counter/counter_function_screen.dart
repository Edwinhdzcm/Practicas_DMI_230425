import 'package:flutter/material.dart';

class CounterFunctionScreen extends StatefulWidget {
  const CounterFunctionScreen({super.key});

  @override
  State<CounterFunctionScreen> createState() =>
      _CounterFunctionScreenState();
}

class _CounterFunctionScreenState extends State<CounterFunctionScreen> {
  int clickCounter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter Screen'),
          leading: IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$clickCounter',
                style: const TextStyle(
                  fontSize: 160,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Text(
                'Click${clickCounter == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),

        // Botones para sumar y restar
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
              onPressed: () {
                setState(() {
                  if (clickCounter > 0) {
                    clickCounter--;
                  }
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
