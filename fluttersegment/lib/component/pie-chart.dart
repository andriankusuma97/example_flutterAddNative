import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../contex/chart-data.dart';



class PieChart extends StatefulWidget {
  const PieChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<ChartData, String>(
            dataSource: widget.chartData,
            pointColorMapper: (ChartData data, _) => data.color,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            radius: '100%',
            innerRadius: '50%',
            explodeOffset: '5%',
            explode: true,
            strokeWidth: 1,
            strokeColor: Colors.white,
            enableTooltip: true,
          )
        ]);
  }
}
