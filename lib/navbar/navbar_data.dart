import 'package:flutter/material.dart';

class NavBarData {
  String title;
  Image icon;
  bool isSelcted;

  NavBarData({
    required this.title,
    this.isSelcted = false,
    required this.icon,
  });
}

List<NavBarData> userButtonData(bool isAdmin) => [
      NavBarData(
        title: "Dash Board",
        icon: Image.asset(
          "assets/icons/dashboard.png",
          color: iconColor,
          height: iconSize.height,
          width: iconSize.width,
        ),
      ),
      NavBarData(
        title: "Assigned To Me",
        icon: Image.asset(
          "assets/icons/assigned_to_me.png",
          color: iconColor,
          height: iconSize.height,
          width: iconSize.width,
        ),
      ),
      NavBarData(
        title: "Created By Me",
        icon: Image.asset(
          "assets/icons/created_by_me.png",
          color: iconColor,
          height: iconSize.height,
          width: iconSize.width,
        ),
      ),
      NavBarData(
        title: "All Issues",
        icon: Image.asset(
          "assets/icons/all_issues.png",
          color: iconColor,
          height: iconSize.height,
          width: iconSize.width,
        ),
      ),
      if (isAdmin)
        NavBarData(
          title: "Admin",
          icon: Image.asset(
            "assets/icons/admin.png",
            color: iconColor,
            height: iconSize.height,
            width: iconSize.width,
          ),
        ),
    ];

Color iconColor = Colors.white;
Size iconSize = const Size(24, 24);
