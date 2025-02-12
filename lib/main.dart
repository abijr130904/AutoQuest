import 'package:flutter/material.dart';
import 'screens/quote_screen.dart';

void main() {
  runApp(const AutoQuestApp());
}

class AutoQuestApp extends StatelessWidget {
  const AutoQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const QuoteScreen(),
    );
  }
}
