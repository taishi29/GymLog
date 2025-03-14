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
  List<String> dates = []; // 🔥 クラス内で `dates` を定義！

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper.instance;
    final records = await dbHelper.getRecord();

    print("取得したレコード: $records"); // デバッグ

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
    print("ソート済みの日付リスト: $sortedDates");

    List<FlSpot> spots = [];
    for (int i = 0; i < sortedDates.length; i++) {
      if (setCounts[sortedDates[i]]! > 0) {
        double avgWeight =
            totalWeights[sortedDates[i]]! / setCounts[sortedDates[i]]!;
        spots.add(FlSpot(i.toDouble(), avgWeight.toDouble())); // 🔥 double に統一
      }
    }

    print("生成されたデータポイント: $spots");

    if (mounted) {
      // 🔥 setState() の前に mounted チェック
      setState(() {
        avgWeightPoints = spots;
        dates = sortedDates; // 🔥 `dates` を更新！
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E), // 🔥 背景色をダークに
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 🔥 横スクロール可能に
        child: SizedBox(
          width: 800, // 🔥 グラフが広くなりすぎないよう調整
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 2.0,
            child: LineChart(_buildChart()),
          ),
        ),
      ),
    );
  }

  LineChartData _buildChart() {
    return LineChartData(
      backgroundColor: const Color(0xFF1E1E1E), // 🔥 背景色をダークに
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white.withOpacity(0.2), // 🔥 グリッド線を暗く
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.white.withOpacity(0.2), // 🔥 グリッド線を暗く
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 5), // 🔥 余白追加で見やすく
                child: Text(
                  '${value.toInt()}kg', // Y軸のラベル
                  style: const TextStyle(
                    fontSize: 14, // 🔥 サイズ大きく
                    color: Colors.white, // 🔥 色を白に変更
                    fontWeight: FontWeight.bold, // 🔥 視認性UP
                  ),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50, // 🔥 余白増やして見やすく
            interval: (dates.length / 4).ceil().toDouble(),
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < dates.length) {
                DateTime parsedDate = DateTime.parse(dates[index]);
                String formattedDate = DateFormat('MM/dd').format(parsedDate);

                print('X軸ラベル: $formattedDate'); // 🔥 デバッグ用

                return SideTitleWidget(
                  meta: meta,
                  child: Transform.rotate(
                    angle: -0.5, // 🔥 斜め表示にして見やすく
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14, // 🔥 サイズUP
                        color: Colors.white, // 🔥 色を白に
                        fontWeight: FontWeight.bold, // 🔥 視認性UP
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // 🔥 `null` を返さず非表示
              }
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 🔥 上側のラベルを非表示
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 🔥 右側のラベルを非表示
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
          gradient: LinearGradient(
            // 🔥 グラデーション追加
            colors: [Colors.cyan, Colors.blueAccent],
          ),
          barWidth: 4,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              // 🔥 グラデーション追加（背景部分）
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
