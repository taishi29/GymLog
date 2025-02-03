import 'package:flutter/material.dart';

class AddMenu extends StatefulWidget {
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  int? _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('トレーニングメニュー追加'),
          backgroundColor: const Color.fromARGB(255, 191, 255, 168),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0), // 余白を追加,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 左寄せにする
              children: [
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
                SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
                Text(
                  'シートの高さ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // 太字
                    fontSize: 16.0, // 文字サイズ（適宜調整）
                  ),
                ),
                SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
                DropdownButton<int>(
                  value: null,
                  onChanged: (int? seatHeight) {
                    setState(() {
                      _selectedValue = seatHeight;
                    });
                  },
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1, // 各選択肢の値
                      child: Text("${index + 1}"), // 選択肢の表示
                    ),
                  ),
                ),
                SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
                Text(
                  'アームの位置',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // 太字
                    fontSize: 16.0, // 文字サイズ（適宜調整）
                  ),
                ),
                SizedBox(height: 8.0), // テキストとTextFieldの間に余白を追加
                DropdownButton<int>(
                  value: null,
                  onChanged: (int? armPosition) {
                    setState(() {
                      _selectedValue = armPosition;
                    });
                  },
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1, // 各選択肢の値
                      child: Text("${index + 1}"), // 選択肢の表示
                    ),
                  ),
                ),
              ],
            )));
  }
}
