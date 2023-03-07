import 'package:brd_issue_tracker/dashboard/api/bar_chart_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AreaChartProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  final List<CharData> _list = [];

  bool get isLoading => _isLoading;
  bool get isError => _isError;
  List<CharData> get data => [..._list];

  void _setError(bool errorBool) {
    _isError = errorBool;
    notifyListeners();
  }

  void _setLoading(loadingBool) {
    _isLoading = loadingBool;
    notifyListeners();
  }

  void getAreaData(String authToken) async {
    if (!_isLoading) {
      _setLoading(true);
    }
    final Map<String, int>? areaMap = await areaChart(authToken);
    if (areaMap == null) {
      _list.clear();
      _isLoading = false;
      _isError = true;
      notifyListeners();
      return;
    }
    final keysList = areaMap.keys;
    _list.clear();

    for (var element in keysList) {
      _list.add(CharData(label: getName(element), value: areaMap[element]!));
    }

    _setLoading(false);
  }
}

class CharData {
  String label;
  int value;
  CharData({required this.label, required this.value});
}

String getName(String date) {
  int no = int.parse(date.substring(date.length - 1)) - 1;
  final todaysDate = DateTime.now();
  final requiredDate = todaysDate.subtract(Duration(days: no));
  return DateFormat("E").format(requiredDate);
}
