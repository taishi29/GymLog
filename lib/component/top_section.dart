import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

// 現在時刻とトレーニング開始時刻を表示するWidget
class TopSection extends StatefulWidget {
  const TopSection({super.key, required this.title});

  final String title;

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  String nowTime = DateFormat('HH:mm:ss').format(DateTime.now()).toString();
  int index = 0;

  @override
  // 時刻を一秒ごとに更新するための関数
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), _onTimer);
  }

  void _onTimer(Timer timer) {
    var newTime = DateFormat('HH:mm:ss').format(DateTime.now());
    setState(() => nowTime = newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 水平方向に中央揃え
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          margin: EdgeInsets.only(top: 80, left: 40), // 上と左に50の余白を追加
          child: Column(
            children: [
              Text("現在の時刻"),
              Text(
                nowTime,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        SizedBox(width: 24), // 横方向の余白
        Container(
          margin: EdgeInsets.only(top: 70, right: 40), // 上と左に50の余白を追加
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {/* ボタンがタップされた時の処理 */},
                child: Text('トレーニング開始'),
              ),
              Text('not depelopment')
            ],
          ),
        ),
      ],
    );
  }
}
