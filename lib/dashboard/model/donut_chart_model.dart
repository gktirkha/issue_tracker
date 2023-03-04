import 'package:flutter/material.dart';

class DonutCharData {
  String label;
  int value;
  Color color;
  DonutCharData(
      {required this.label, required this.value, required this.color});
}

Map<String, Color> donutChartcolors = {
  "unAssignedCount": Colors.red,
  "assignedCount": Colors.blue,
  "inProgressCount": Colors.yellow,
  "completedCount": Colors.green,
};
