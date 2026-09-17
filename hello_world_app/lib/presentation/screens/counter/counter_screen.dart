import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {

  int clickCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickCounter',
              style: GoogleFonts.rockSalt(
                fontSize: 160,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              "Click${ clickCounter > 1 ? 's' : '' }",
              style: const TextStyle(fontSize: 25),
            ),
          ],
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.plus_one),
          ),
          SizedBox(height: 16),
          CustomButton(
            icon: Icons.remove,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.refresh_outlined),
          ),
        ],
      )
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;

  const CustomButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(icon),
    );
  }
}