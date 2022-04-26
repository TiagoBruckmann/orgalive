// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:math';

class AppGradients {
  static const linear = LinearGradient(colors: [
    Color(0xFF494649),
    Color.fromRGBO(54, 52, 53, 0.695),
    // Color.fromRGBO(130, 87, 229, 0.695),
  ], stops: [
    0.0,
    0.695
  ], transform: GradientRotation(2.13959913 * pi));
}
