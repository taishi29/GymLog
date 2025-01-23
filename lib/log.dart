import 'package:flutter/material.dart';
// DateTimeクラスパッケージ
import 'package:intl/intl.dart';
import 'dart:async';

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    return Scaffold(
      appBar: AppBar(
        title: Text('筋トレ記録アプリ'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight / 3, // 画面の高さの3分の1の高さ
            child: TopSection(title: 'Hello World!'), // 時刻とトレーニング開始時刻
          ),
          Expanded(
            child: Log(),
          ), // 筋トレメニューリスト
        ],
      ),
    );
  }
}

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

class Log extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello! World!'),
    );
  }
}
