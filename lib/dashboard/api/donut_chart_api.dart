import 'package:dio/dio.dart';
import 'dart:developer' as dev;
import '../../static_data.dart';

Future<Map<String, dynamic>?> donutChartService(String authToken) async {
  Map<String, dynamic> _donutChartItemsMap = {};
  dev.log("DonutChartApi called", name: "Donut Chart API");
  try {
    final res = await Dio().get(
      "$host/api/statusFilterCount",
      data: {"token": authToken},
    );
    final Map donutChartMap = res.data["data"];
    dev.log(res.statusCode.toString(), name: "donut resCode");
    if (res.statusCode != 201) throw Exception("Invalid Status Code");
    if (res.data["success"] != true) throw Exception("Invalid Status Code");
    _donutChartItemsMap.clear();
    donutChartMap.forEach((key, value) {
      _donutChartItemsMap[key.toString()] = value;
    });
    return {...donutChartMap};
  } catch (e) {
    dev.log(e.toString(), name: "Donut Chart Exception");
    return null;
  }
}
