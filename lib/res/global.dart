import 'dart:math';
import 'package:flutter/material.dart';

/// Generate unique from time
String generateUniqueNumber() {
  DateTime now = DateTime.now();
  return "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}";
}

/// Generate random Color
Color randomColor({double opacity = 0.75}) {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(opacity);
}

/// DB Name
const String dbName = "database.db";

/// DB Table Name
const String dbTableName = "MyTable1";
