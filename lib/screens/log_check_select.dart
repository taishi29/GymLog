import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// component
import 'package:gymlog/component/line_chart.dart';
import 'package:gymlog/component/log_check_table.dart'; // 📊 **表のコンポーネント**
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
  bool isLoading = true; // 🔥 ロード状態
  bool isGraphView = false; // 📈 **グラフがデフォルト**
  int dataCount = 10; // 🔥 仮のデータ数（後で動的に変更）

  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    loadTrainingData();
  }

  Future<void> loadTrainingData() async {
    List<Map<String, dynamic>> menuLists = await dbHelper.getMenu();
    List<Map<String, dynamic>> editMenu =
        menuLists.where((menu) => menu['training_id'] == widget.id).toList();

    if (editMenu.isNotEmpty) {
      Map<String, dynamic> menuData = editMenu.first;
      setState(() {
        trainingName = menuData['training_name'];
      });
    }

    int fetchedDataCount = await getDataCountFromChart();
    setState(() {
      dataCount = fetchedDataCount;
      isLoading = false;
    });
  }

  Future<int> getDataCountFromChart() async {
    final chart = LineChartSample(trainingId: widget.id);
    return await chart.getDataCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // 🔥 **少し明るい黒**
      appBar: AppBar(
        title: const Text('記録の確認'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // ✅ **縦スクロールできるように修正**
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trainingName ?? '読み込み中...',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16.0),

              // 📌 **グラフ / 表 切り替えボタン**
              Center(
                child: ToggleButtons(
                  isSelected: [isGraphView, !isGraphView],
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.white,
                  color: Colors.white70,
                  fillColor: Colors.blueAccent,
                  onPressed: (index) {
                    setState(() {
                      isGraphView = index == 0;
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("📈 グラフ"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("📊 表"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // 🔄 **ロード中ならインジケーター**
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.6, // ✅ **高さを適切に設定**
                  child: isGraphView
                      ? SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // 📈 **グラフは横スクロール可**
                          child: SizedBox(
                            width: dataCount * 100,
                            child: InteractiveViewer(
                              boundaryMargin: const EdgeInsets.all(50),
                              minScale: 0.5,
                              maxScale: 2.5,
                              child: LineChartSample(trainingId: widget.id),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF383838), // 🔥 **表の背景色**
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: LogCheckTable(trainingId: widget.id),
                        ), // 📊 **表（横スクロールなし）**
                ),
            ],
          ),
        ),
      ),
    );
  }
}
