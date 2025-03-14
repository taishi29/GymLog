import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';
import 'package:intl/intl.dart';

class LineChartSample extends StatefulWidget {
  final int trainingId;

  const LineChartSample({super.key, required this.trainingId});

  Future<int> getDataCount() async {
    final dbHelper = DatabaseHelper.instance;
    final records = await dbHelper.getRecord();
    return records.where((r) => r['training_id'] == trainingId).length;
  }

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<FlSpot> avgWeightPoints = [];
  List<String> dates = [];
  bool isGraphReady = false; // ✅ **データ準備フラグ**

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isGraphReady = false; // 🔄 **データロード開始**
    });

    final dbHelper = DatabaseHelper.instance;
    final records = await dbHelper.getRecord();

    Map<String, double> totalWeights = {};
    Map<String, int> setCounts = {};

    for (var record in records) {
      if (record['training_id'] == widget.trainingId) {
        String date = record['date_time'].split(' ')[0];
        double weight = (record['weight'] as num).toDouble() *
            (record['count'] as num).toDouble(); // 変換

        if (totalWeights.containsKey(date)) {
          totalWeights[date] = totalWeights[date]! + weight;
          setCounts[date] = setCounts[date]! + 1;
        } else {
          totalWeights[date] = weight;
          setCounts[date] = 1;
        }
      }
    }

    List<String> sortedDates = totalWeights.keys.toList()..sort();

    List<FlSpot> spots = [];
    for (int i = 0; i < sortedDates.length; i++) {
      if (setCounts[sortedDates[i]]! > 0) {
        double avgWeight =
            totalWeights[sortedDates[i]]! / setCounts[sortedDates[i]]!;
        spots.add(FlSpot(i.toDouble(), avgWeight.toDouble()));
      }
    }

    await Future.delayed(const Duration(milliseconds: 200)); // ✅ **軽い遅延**
    if (mounted) {
      setState(() {
        avgWeightPoints = spots;
        dates = sortedDates;
        isGraphReady = true; // ✅ **データ準備完了**
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(10),
      child: isGraphReady
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800,
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 2.0,
                  child: LineChart(_buildChart()),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  LineChartData _buildChart() {
    return LineChartData(
      backgroundColor: const Color(0xFF1E1E1E),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white.withOpacity(0.2),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.white.withOpacity(0.2),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}kg',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: (dates.length / 4).ceil().toDouble(),
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < dates.length) {
                DateTime parsedDate = DateTime.parse(dates[index]);
                String formattedDate = DateFormat('MM/dd').format(parsedDate);

                return SideTitleWidget(
                  meta: meta,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.blueAccent],
          ),
          barWidth: 4,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withOpacity(0.3),
                Colors.blueAccent.withOpacity(0.1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
