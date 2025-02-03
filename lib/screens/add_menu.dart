import 'package:flutter/material.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  AddMenuState createState() => AddMenuState();
}

class AddMenuState extends State<AddMenu> {
  int? seatHeight;
  int? armPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('トレーニングメニュー追加'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0), // 余白を追加,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左寄せにする
          children: [
            // トレーニング名
            Text(
              'トレーニング名',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 太字
                fontSize: 16.0, // 文字サイズ（適宜調整）
              ),
            ),
            SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
            TextField(
              decoration: InputDecoration(
                labelText: 'トレーニング名',
                hintText: 'チェストプレス',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),

            SizedBox(height: 24.0), // テキストとTextFieldの間に余白を追加

            // シートの高さ
            Text(
              'シートの高さ',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 太字
                fontSize: 16.0, // 文字サイズ（適宜調整）
              ),
            ),
            SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
            DropdownButton<int?>(
              value: seatHeight,
              hint: Text("数値を選択してください。"),
              onChanged: (int? selectedValue) {
                setState(() {
                  seatHeight = selectedValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text("なし"),
                ),
                ...List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1, // 各選択肢の値
                    child: Text("${index + 1}"), // 選択肢の表示
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.0), // テキストとTextFieldの間に余白を追加

            // アームの位置
            Text(
              'アームの位置',
              style: TextStyle(
                fontWeight: FontWeight.bold, // 太字
                fontSize: 16.0, // 文字サイズ（適宜調整）
              ),
            ),
            SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
            DropdownButton<int>(
              value: armPosition,
              hint: Text("数値を選択してください。"),
              onChanged: (int? selectedValue) {
                setState(() {
                  armPosition = selectedValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text("なし"),
                ),
                ...List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1, // 各選択肢の値
                    child: Text("${index + 1}"), // 選択肢の表示
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
