import 'package:flutter/material.dart';

class ScreenSize{
  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}