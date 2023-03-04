import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/donut_chart_model.dart';
import '../../provider/donut_chart_provider.dart';

class DonutChart extends StatefulWidget {
  final String authToken;

  const DonutChart({super.key, required this.authToken});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DonutChartProvider>(
      builder: (context, value, child) {
        return Center(
          child: value.isLoading
              ? const SpinKitFadingCube(color: Colors.deepOrange, size: 50)
              : value.isError
                  ? const Text("Error Occured, Please retry")
                  : SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      title: ChartTitle(
                        text: "Issues Insights",
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: [
                        DoughnutSeries<DonutCharData, String>(
                          dataSource: value.donutChartItemsList,
                          xValueMapper: (datum, index) => datum.label,
                          yValueMapper: (datum, index) => datum.value,
                          pointColorMapper: (datum, index) => datum.color,
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
