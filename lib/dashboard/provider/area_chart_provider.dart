import 'package:flutter/material.dart';

class AreaChartProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  final List<CharData> _list = [
    CharData(label: "mon", value: 10),
    CharData(label: "tue", value: 10),
    CharData(label: "wed", value: 30),
    CharData(label: "thu", value: 20),
    CharData(label: "fri", value: 10),
    CharData(label: "sat", value: 60),
    CharData(label: "sun", value: 10),
  ];

  List<CharData> get data => [..._list];
  void getAreaData(String authToken) {
    _list.add(CharData(label: "mon", value: 10));
    _list.add(CharData(label: "tue", value: 10));
    _list.add(CharData(label: "wed", value: 30));
    _list.add(CharData(label: "thu", value: 20));
    _list.add(CharData(label: "fri", value: 10));
    _list.add(CharData(label: "sat", value: 60));
    _list.add(CharData(label: "sun", value: 10));
    notifyListeners();
  }
}

class CharData {
  String label;
  int value;
  CharData({required this.label, required this.value});
}
