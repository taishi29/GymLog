import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';

class EditMenuSelect extends StatefulWidget {
  final int id;
  final int index;
  final VoidCallback onMenuUpdated;
  final VoidCallback onEditMenuUpdated;

  EditMenuSelect({
    super.key,
    required this.id,
    required this.index,
    required this.onMenuUpdated,
    required this.onEditMenuUpdated,
  });

  @override
  EditMenuSelectState createState() => EditMenuSelectState();
}

class EditMenuSelectState extends State<EditMenuSelect> {
  int? seatHeight;
  int? armPosition;
  String? trainingName;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController trainingNameController = TextEditingController();
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
        seatHeight = menuData['seat_height'];
        armPosition = menuData['arm_position'];
        trainingNameController.text = trainingName ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トレーニングメニュー編集'),
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
            Form(
              key: _formKey,
              child: TextFormField(
                controller: trainingNameController,
                decoration: const InputDecoration(
                  labelText: 'トレーニング名',
                  hintText: 'チェストプレス',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onChanged: (value) => trainingName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'トレーニング名を入力してください。';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // シートの高さ
            const Text(
              'シートの高さ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButton<int?>(
              value: seatHeight,
              hint: const Text("数値を選択してください。"),
              onChanged: (int? selectedValue) {
                setState(() => seatHeight = selectedValue);
              },
              items: [
                const DropdownMenuItem(value: null, child: Text("なし")),
                ...List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("${index + 1}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // アームの位置
            const Text(
              'アームの位置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButton<int?>(
              value: armPosition,
              hint: const Text("数値を選択してください。"),
              onChanged: (int? selectedValue) {
                setState(() => armPosition = selectedValue);
              },
              items: [
                const DropdownMenuItem(value: null, child: Text("なし")),
                ...List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("${index + 1}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),

            // 保存ボタン
            Center(
              child: ElevatedButton.icon(
                label: const Text('保存'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Map<String, dynamic> row = {
                        "training_name": trainingName,
                        "seat_height": seatHeight,
                        "arm_position": armPosition,
                      };
                      await dbHelper.updateMenu(widget.id, row);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.greenAccent,
                          content: Text('変更しました！'),
                          margin:
                              EdgeInsets.only(left: 23, right: 23, bottom: 23),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      // メニューリストの更新を通知
                      widget.onEditMenuUpdated();
                      widget.onMenuUpdated();

                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('エラーが発生しました: $e'),
                          margin:
                              EdgeInsets.only(left: 23, right: 23, bottom: 23),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.upload, size: 20),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 249, 85, 85);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return const Color.fromARGB(255, 249, 80, 80);
                      }
                      return const Color.fromARGB(255, 255, 140, 127);
                    },
                  ),
                  minimumSize: WidgetStateProperty.all(const Size(110, 50)),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
