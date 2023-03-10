import 'dart:developer';

import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<Map<String, int>?> areaChart(String token) async {
  Map<String, int> barChartMap = {};
  try {
    final res = await Dio().get(
      "$host/barChart",
      options: Options(
        headers: {
          "Authorization": token,
        },
      ),
    );

    if (res.statusCode != 200) throw Exception("AreaChart Exception");
    final Map myMap = res.data["data"];
    barChartMap.clear();
    myMap.forEach((key, value) {
      barChartMap[key] = value;
    });

    return barChartMap;
  } catch (e) {
    log(e.toString(), name: "Area Chart Exception");
    return null;
  }
}
