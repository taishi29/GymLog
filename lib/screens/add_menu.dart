import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';

class AddMenu extends StatefulWidget {
  final VoidCallback onMenuUpdated;

  const AddMenu({super.key, required this.onMenuUpdated});

  @override
  AddMenuState createState() => AddMenuState();
}

class AddMenuState extends State<AddMenu> {
  int? seatHeight;
  int? armPosition;
  String? trainingName;
  // Form全体を管理。このキーを配置したWidgetの状態(今回はForm)に、同じ State クラス内のどこからでもアクセスできる。
  final _formKey = GlobalKey<FormState>();
  // TextEditingController は TextFormField を管理し、テキストの変更・取得・クリアを制御できる。
  final TextEditingController trainingNameController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トレーニングメニュー追加'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Column全体の外側に余白ができる。
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // childrenにある要素を、左寄せにする。
          children: [
            // トレーニング名
            const Text(
              'トレーニング名',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Form(
              key: _formKey, // このFormの状態を管理する。
              child: TextFormField(
                // このTextFormFieldの値を制御できる。
                controller: trainingNameController,
                decoration: const InputDecoration(
                  // TextFormFieldの見た目を変更するクラス
                  labelText: 'トレーニング名',
                  hintText: 'チェストプレス',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                // onChangedはTextFieldに入力されたときに呼ばれる関数。valueには入力したての内容が渡される。
                // (引数) => 処理内容
                onChanged: (value) => trainingName = value,
                // 備考：onChangedとvalidatorの引数は、任意の名前でOK! それぞれ、関数ごとに変数は独立している。
                validator: (value) {
                  // このvalueはフォームの現在の入力値
                  if (value == null || value.isEmpty) {
                    // isEmptyはStringやListなどの変数が、空かどうかを判定するプロパティ
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
                  // _formKey.currentState を取得し、その FormState が null でないことを保証して .validate() を実行する
                  // そして、validate() は validator で定義したルールに従っていたら、nullを返す。
                  if (_formKey.currentState!.validate()) {
                    try {
                      // training_menuテーブルの要素を取得
                      List<Map<String, dynamic>> menuLists =
                          await dbHelper.getMenu();
                      // trainingNameと重複しているかチェック
                      bool isDuplicate = menuLists.any((menuList) =>
                          menuList['training_name'] == trainingName);

                      // 追加しようとしているトレーニング名がすでに登録されていたら、エラーメッセージをだして中断
                      if (isDuplicate) {
                        // すでにある場合はエラーメッセージを表示して処理を中断
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('このトレーニング名はすでに登録されています。もう一度、やり直してください。'),
                            margin: EdgeInsets.only(
                                left: 23, right: 23, bottom: 23),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      Map<String, dynamic> row =
                          insertValue(trainingName, seatHeight, armPosition);
                      await dbHelper.insertMenu(row);

                      // Formをクリアする。
                      setState(() {
                        trainingNameController.clear(); // 入力欄をクリア
                        seatHeight = null; // ドロップダウンの選択値をリセット
                        armPosition = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.greenAccent,
                          content: Text('追加しました！'),
                          margin:
                              EdgeInsets.only(left: 23, right: 23, bottom: 23),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      // (3) fetchMenu()が実行される。
                      widget.onMenuUpdated();
                    } catch (e) {
                      String errorMessage = e.toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('エラーが発生しました: $errorMessage'),
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

Map<String, dynamic> insertValue(
    String? trainingName, int? seatHeight, int? armPosition) {
  return {
    "training_name": trainingName,
    "seat_height": seatHeight,
    "arm_position": armPosition,
  };
}
