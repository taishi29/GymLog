import 'package:flutter/material.dart';

// component
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
    training_id = widget.id; // `initState()` 内で `widget.id` をセット
    logSelectMenu(training_id);
  }

  // fetchMenu()：データを取得して UI を更新する関数
  Future<void> logSelectMenu(int id) async {
    Map<String, dynamic>? selectMenu =
        await DatabaseHelper.instance.getSelectMenu(id);

    if (selectMenu == null) {
      print("データが見つかりませんでした (id: $id)");
      return; // ここで処理を中断
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

  // レコードを挿入するための Map を作成
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記録'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            trainingName ?? "トレーニング",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "アームの位置",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("${armPosition ?? '-'}",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Text(
                    "シートの高さ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("${seatHeight ?? '-'}",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),
          const SizedBox(height: 12), // ラインの上にスペース
          Divider(
            thickness: 2, // 線の太さ
            color: Colors.grey, // 線の色
            indent: 16, // 左側の余白
            endIndent: 16, // 右側の余白
          ),
          const SizedBox(height: 12), // ラインの下にスペース
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '何セット目？',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
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
                          value: index + 1,
                          child: Text("${index + 1}"),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '重さは何kg？',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
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
                          value: index + 1,
                          child: Text("${index + 1}"),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '回数は？',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
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
                          value: index + 1,
                          child: Text("${index + 1}"),
                        ),
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
                              margin: EdgeInsets.only(
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
