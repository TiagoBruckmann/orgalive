import 'package:flutter/material.dart';

class Releases extends StatefulWidget {
  const Releases({Key? key}) : super(key: key);

  @override
  _ReleasesState createState() => _ReleasesState();
}

class _ReleasesState extends State<Releases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lançamentos"),
      ),
    );
  }
}
