import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// screen
// component
import 'package:gymlog/component/line_chart.dart';
// DB
import 'package:gymlog/db/db.dart';

class LogCheckSelect extends StatefulWidget {
  final int id;
  final int index;
  final VoidCallback onEditMenuUpdated;

  LogCheckSelect({
    super.key,
    required this.id,
    required this.index,
    required this.onEditMenuUpdated,
  });

  @override
  LogCheckSelectState createState() => LogCheckSelectState();
}

class LogCheckSelectState extends State<LogCheckSelect> {
  String? trainingName;

  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    loadTrainingData();
  }

  Future<void> loadTrainingData() async {
    // データベースから該当するトレーニングデータを取得
    List<Map<String, dynamic>> menuLists = await dbHelper.getMenu();
    List<Map<String, dynamic>> editMenu =
        menuLists.where((menu) => menu['training_id'] == widget.id).toList();

    if (editMenu.isNotEmpty) {
      Map<String, dynamic> menuData = editMenu.first;
      setState(() {
        trainingName = menuData['training_name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録の確認'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'トレーニング名',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            LineChartSample(trainingId: widget.id),
          ],
        ),
      ),
    );
  }
}
