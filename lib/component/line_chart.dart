import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';

class LineChartSample extends StatefulWidget {
  final int trainingId;

  const LineChartSample({super.key, required this.trainingId});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<FlSpot> avgWeightPoints = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper.instance;
    final records = await dbHelper.getRecord(); // 全レコード取得

    // 日付ごとの総重量とセット数を集計
    Map<String, double> totalWeights = {}; // {日付: 総重量}
    Map<String, int> totalSets = {}; // {日付: セット数}

    for (var record in records) {
      if (record['training_id'] == widget.trainingId) {
        String date = record['date_time'].split(' ')[0]; // "YYYY-MM-DD" だけ取得
        double weight = record['weight'] * record['count'];
        int sets = record['set_number'];

        if (totalWeights.containsKey(date)) {
          totalWeights[date] = totalWeights[date]! + weight * sets;
          totalSets[date] = totalSets[date]! + sets;
        } else {
          totalWeights[date] = weight * sets;
          totalSets[date] = sets;
        }
      }
    }

    // 日付ごとに平均重量を計算
    List<String> dates = totalWeights.keys.toList()..sort();
    List<FlSpot> spots = [];
    for (int i = 0; i < dates.length; i++) {
      double avgWeight = totalWeights[dates[i]]! / totalSets[dates[i]]!;
      spots.add(FlSpot(i.toDouble(), avgWeight));
    }

    setState(() {
      avgWeightPoints = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 300,
        child: LineChart(_buildChart()),
      ),
    );
  }

  LineChartData _buildChart() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              return index < avgWeightPoints.length
                  ? Text(
                      avgWeightPoints[index].x.toString(),
                      style: const TextStyle(fontSize: 12),
                    )
                  : const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: avgWeightPoints.isNotEmpty
          ? (avgWeightPoints.length - 1).toDouble()
          : 1,
      minY: 0,
      maxY: avgWeightPoints.isNotEmpty
          ? (avgWeightPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)) *
              1.1
          : 1,
      lineBarsData: [
        LineChartBarData(
          spots: avgWeightPoints,
          isCurved: true,
          color: Colors.blue,
          barWidth: 4,
          belowBarData:
              BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
        ),
      ],
    );
  }
}
