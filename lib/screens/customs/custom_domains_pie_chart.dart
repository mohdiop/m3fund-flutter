import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomDomainsPieChart extends StatefulWidget {
  const CustomDomainsPieChart({super.key});

  @override
  State<CustomDomainsPieChart> createState() => _CustomDomainsPieChartState();
}

class _CustomDomainsPieChartState extends State<CustomDomainsPieChart> {
  int? touchedIndex;

  final List<Map<String, dynamic>> data = [
    {'label': 'Éducation', 'value': 25.0, 'color': Colors.teal},
    {'label': 'Santé', 'value': 30.0, 'color': Colors.lightBlue},
    {'label': 'Agriculture', 'value': 45.0, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    setState(() {
                      touchedIndex = null;
                    });
                    return;
                  }
                  setState(() {
                    touchedIndex = response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: _buildSections(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(data.length, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 100 : 90;

      return PieChartSectionData(
        color: data[index]['color'],
        value: data[index]['value'],
        title: isTouched
            ? '${data[index]['label']}\n${data[index]['value']}%'
            : '${data[index]['value']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 15 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      spacing: 20,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: item['color']),
            const SizedBox(width: 6),
            Text(item['label']),
          ],
        );
      }).toList(),
    );
  }
}
