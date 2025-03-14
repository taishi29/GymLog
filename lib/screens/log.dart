import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';

class LogPage extends StatefulWidget {
  final int id;

  LogPage({super.key, required this.id});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  int? seatHeight;
  int? armPosition;
  String? trainingName;
  late int training_id;
  DateTime date = DateTime.now();
  int minutes = 0;

  int? set_number;
  int? weight;
  int? count;

  Map<String, dynamic>? menuLists;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    training_id = widget.id;
    logSelectMenu(training_id);
  }

  Future<void> logSelectMenu(int id) async {
    Map<String, dynamic>? selectMenu =
        await DatabaseHelper.instance.getSelectMenu(id);

    if (selectMenu == null) {
      print("データが見つかりませんでした (id: $id)");
      return;
    }

    if (mounted) {
      setState(() {
        menuLists = selectMenu;
        isLoading = false;
        trainingName = selectMenu['training_name'];
        seatHeight = selectMenu['seat_height'];
        armPosition = selectMenu['arm_position'];
      });
    }
  }

  Map<String, dynamic> insertValue(int training_id, int? set_number,
      int? weight, int? count, int? minutes, DateTime date) {
    return {
      'training_id': training_id,
      'set_number': set_number ?? 0,
      'weight': weight ?? 0,
      'count': count ?? 0,
      'minutes': minutes ?? 0,
      'date_time': date.toIso8601String(),
    };
  }

  // 日付選択ダイアログを表示
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2024), // 過去の制限
      lastDate: DateTime(2030), // 未来の制限
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked; // 選択した日付をセット
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            trainingName ?? "トレーニング",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 日付選択フォーム
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "日付: ${date.year}/${date.month}/${date.day}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text("日付を選択"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Divider(
            thickness: 2,
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('何セット目？',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 8.0),
                  DropdownButton<int?>(
                    value: set_number,
                    hint: const Text("数値を選択してください。"),
                    onChanged: (int? selectedValue) {
                      setState(() => set_number = selectedValue);
                    },
                    items: [
                      const DropdownMenuItem(value: null, child: Text("なし")),
                      ...List.generate(
                        20,
                        (index) => DropdownMenuItem(
                            value: index + 1, child: Text("${index + 1}")),
                      ),
                    ],
                  ),
                  const Text('重さは何kg？',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 8.0),
                  DropdownButton<int?>(
                    value: weight,
                    hint: const Text("数値を選択してください。"),
                    onChanged: (int? selectedValue) {
                      setState(() => weight = selectedValue);
                    },
                    items: [
                      const DropdownMenuItem(value: null, child: Text("なし")),
                      ...List.generate(
                        200,
                        (index) => DropdownMenuItem(
                            value: index + 1, child: Text("${index + 1}")),
                      ),
                    ],
                  ),
                  const Text('回数は？',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 8.0),
                  DropdownButton<int?>(
                    value: count,
                    hint: const Text("数値を選択してください。"),
                    onChanged: (int? selectedValue) {
                      setState(() => count = selectedValue);
                    },
                    items: [
                      const DropdownMenuItem(value: null, child: Text("なし")),
                      ...List.generate(
                        100,
                        (index) => DropdownMenuItem(
                            value: index + 1, child: Text("${index + 1}")),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  // 保存ボタン
                  Center(
                    child: ElevatedButton.icon(
                      label: const Text('保存'),
                      onPressed: () async {
                        try {
                          Map<String, dynamic> row = insertValue(training_id,
                              set_number, weight, count, minutes, date);
                          await dbHelper.insertRecord(row);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.greenAccent,
                              content: Text('追加しました！'),
                              margin: EdgeInsets.only(
                                  left: 23, right: 23, bottom: 23),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          String errorMessage = e.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text('エラーが発生しました: $errorMessage'),
                              margin: const EdgeInsets.only(
                                  left: 23, right: 23, bottom: 23),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.upload, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 140, 127),
                        minimumSize: const Size(110, 50),
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
