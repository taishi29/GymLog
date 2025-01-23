import 'package:flutter/material.dart';

// component
import 'package:gymlog/component/top_section.dart'; // 新しいファイルをインポート

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

class Log extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello! World!'),
    );
  }
}
