import 'package:flutter/material.dart';

class FutureReleases extends StatefulWidget {
  const FutureReleases({Key? key}) : super(key: key);

  @override
  _FutureReleasesState createState() => _FutureReleasesState();
}

class _FutureReleasesState extends State<FutureReleases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lançamentos futuros"),
      ),
    );
  }
}
