import 'package:flutter/material.dart';

class SpendingLimits extends StatefulWidget {
  const SpendingLimits({Key? key}) : super(key: key);

  @override
  _SpendingLimitsState createState() => _SpendingLimitsState();
}

class _SpendingLimitsState extends State<SpendingLimits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Limite de gastos"),
      ),
    );
  }
}
