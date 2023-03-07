import 'package:flutter/material.dart';

class NavBarData {
  String title;
  IconData icon;
  bool isSelcted;

  NavBarData({
    required this.title,
    this.isSelcted = false,
    required this.icon,
  });
}

List<NavBarData> get userButtonData => [
      NavBarData(title: "Dash Board", icon: Icons.dashboard),
      NavBarData(title: "Assigned To Me", icon: Icons.dashboard),
      NavBarData(title: "Created By Me", icon: Icons.dashboard),
      NavBarData(title: "All Issues", icon: Icons.all_inbox),
    ];
