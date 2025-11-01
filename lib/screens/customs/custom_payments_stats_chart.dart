import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';

class CustomPaymentsStatsChart extends StatefulWidget {
  final Function(String, double) action;
  final List<Map<String, dynamic>> data;
  const CustomPaymentsStatsChart({
    super.key,
    required this.action,
    required this.data,
  });

  @override
  State<CustomPaymentsStatsChart> createState() =>
      _CustomPaymentsStatsChartState();
}

class _CustomPaymentsStatsChartState extends State<CustomPaymentsStatsChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchCallback: (event, response) {
            if (response != null &&
                response.spot != null &&
                event is FlTapUpEvent) {
              final index = response.spot!.touchedBarGroupIndex;
              final month = widget.data[index]["mois"];
              final amount = widget.data[index]["amount"];

              widget.action(month, amount);
            }
          },
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => customBlackColor,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            tooltipHorizontalAlignment: FLHorizontalAlignment.center,
            getTooltipItem: (group, _, rod, __) {
              final val = rod.toY;
              return BarTooltipItem(
                '$val%',
                const TextStyle(fontSize: 12, color: Colors.white),
              );
            },
          ),
        ),

        barGroups: widget.data.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value["val"] as double;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: secondaryColor,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ],
          );
        }).toList(),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, _) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text(
                widget.data[value.toInt()]["mois"].toString(),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ),
        ),

        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFD9D9D9), width: 7),
            left: BorderSide(color: Color(0xFFD9D9D9), width: 7),
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
      ),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutSine,
    );
  }
}
