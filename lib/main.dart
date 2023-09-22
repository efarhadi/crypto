import 'package:flutter/material.dart';
import 'package:test_for_learn_api/screens/home_screen.dart';

void main() {
  runApp(Applications());
}

class Applications extends StatefulWidget {
  Applications({Key? key}) : super(key: key);

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
