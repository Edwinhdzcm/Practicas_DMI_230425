import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterFunctionScreen extends StatefulWidget {
  const CounterFunctionScreen({super.key});

  @override
  State<CounterFunctionScreen> createState() =>
      _CounterFunctionScreenState();
}

class _CounterFunctionScreenState extends State<CounterFunctionScreen> {
  int clickCounter = 0;

  // Método para determinar el color según el valor del contador
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
            style: GoogleFonts.libreCaslonText(),
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

        // Contenido principal
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$clickCounter',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 160,
                  fontWeight: FontWeight.w100,
                  color: _getCounterColor(),
                ),
              ),
              Text(
                "Click${clickCounter > 1 ? 's' : ''}",
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),

        // Botones flotantes
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: () {
                setState(() {
                  clickCounter += 1;
                });
              },
              icon: Icons.plus_one,
            ),

            const SizedBox(height: 16),

            CustomButton(
              icon: Icons.exposure_minus_1,
              onPressed: () {
                setState(() {
                  clickCounter -= 1;
                });
              },
            ),

            const SizedBox(height: 16),

            CustomButton(
              onPressed: () {
                setState(() {
                  clickCounter = 0;
                });
              },
              icon: Icons.refresh_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}