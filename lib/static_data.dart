import 'package:flutter/material.dart';

String host = "http://localhost:4000/api";

String get HIGH_PRIORITY => "HIGH";
String get LOW_PRIORITY => "LOW";
String get MEDIUM_PRIORITY => "MEDIUM";

List<String> priorityList = [HIGH_PRIORITY, MEDIUM_PRIORITY, LOW_PRIORITY];

Color priorityColor(String priority) {
  Color color = Colors.green;
  switch (priority) {
    case "HIGH":
      color = Colors.red;
      break;
    case "MEDIUM":
      color = Colors.yellow[800]!;
      break;

    case "LOW":
      color = Colors.green;
      break;
  }
  return color;
}

Map<String, int> priorityMap = {
  HIGH_PRIORITY: 2,
  MEDIUM_PRIORITY: 1,
  LOW_PRIORITY: 0,
};

String get UNASSIGNED => "unAssigned";
String get ASSIGNED => "Assigned";
String get IN_PROGRESS => "inProgress";
String get COMPLETED => "Completed";

List<String> statusList = [UNASSIGNED, ASSIGNED, IN_PROGRESS, COMPLETED];

String get CREATION_DATE => "CREATION_DATE";
String get UPDATE_DATE => "UPDATE_DATE";
String get CREATED_BY => "CREATED_BY";
String get PRIORITY => "PRIORITY";
String get STATUS => "STATUS";

Map<String, int> statusMap = {
  UNASSIGNED: 3,
  ASSIGNED: 2,
  IN_PROGRESS: 1,
  COMPLETED: 0
};

Color statusColor(String status) {
  Color color = Colors.green;
  switch (status) {
    case "unAssigned":
      color = Colors.red;
      break;
    case "inProgress":
      color = Colors.yellow[800]!;

      break;

    case "Assigned":
      color = Colors.blue[800]!;
      break;

    case "Completed":
      color = Colors.green;
      break;
  }
  return color;
}

List<String> departmentList = ['React', 'Node', 'Flutter', 'Java'];
