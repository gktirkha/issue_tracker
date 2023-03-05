import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../api/donut_chart_api.dart';
import '../model/donut_chart_model.dart';

class DonutChartProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  Map<String, String> _donutChartMap = {};
  int _count = 0;
  int get count {
    _count = 0;
    _donutChartMap.forEach((key, value) {
      _count += int.parse(value);
    });
    return _count;
  }

  void setLoading(bool loadingBool) {
    _isLoading = loadingBool;
    notifyListeners();
  }

  void setError(bool errorBool) {
    _isError = errorBool;
    notifyListeners();
  }

  final List<DonutCharData> _donutChartItemsList = [];
  List<DonutCharData> get donutChartItemsList => [..._donutChartItemsList];
  Map<String, String> get donutChartMap => {..._donutChartMap};

  Future<void> getDonutData(String authToken) async {
    dev.log("getDonutData called", name: "Donut Chart Provider");
    if (!isLoading) setLoading(true);
    if (isError) setError(false);
    final res = await donutChartService(authToken);
    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }
    _donutChartItemsList.clear();
    _donutChartMap.clear();
    _count = 0;
    res.forEach(
      (key, value) {
        _donutChartItemsList.add(
          DonutCharData(
              label: key, value: value, color: donutChartcolors[key]!),
        );
        _donutChartMap[key] = value.toString();
      },
    );
    setLoading(false);
  }
}
