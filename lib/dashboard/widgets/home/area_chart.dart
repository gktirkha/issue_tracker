import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/area_chart_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class AreaChart extends StatefulWidget {
  const AreaChart({super.key, required this.authToken});
  final String authToken;
  @override
  State<AreaChart> createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AreaChartProvider>(
      builder: (context, value, child) => value.isLoading
          ? const SpinKitFadingCube(color: Colors.deepOrange, size: 50)
          : value.isError
              ? const Text("Error Occured")
              : SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                  ),
                  primaryXAxis: CategoryAxis(title: AxisTitle(text: "Day")),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: "Cases")),
                  title: ChartTitle(text: "This Week Issues"),
                  series: [
                    SplineAreaSeries<CharData, String>(
                      dataSource: value.data,
                      xValueMapper: (datum, index) => datum.label,
                      yValueMapper: (datum, index) => datum.value,
                      cardinalSplineTension: 0.9,
                      enableTooltip: true,
                      name: "Issues",
                      gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topLeft,
                        colors: [
                          Colors.blue,
                          Colors.deepOrange,
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}
