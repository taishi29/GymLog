import 'package:flutter/material.dart';
// DateTimeクラスパッケージ
import 'package:intl/intl.dart';

import 'dart:async';

// main関数
void main() {
  runApp(const MyApp());
}

// アプリの基本設定
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymLog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// 一番最初に表示される画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('筋トレ記録')),
      body: Column(
        children: [
          TopSection(title: 'Hello World!'), // 時刻とトレーニング開始時刻
          Expanded(
            child: MenuList(),
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
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("現在の時刻"),
            Text(
              nowTime,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {/* ボタンがタップされた時の処理 */},
              child: Text('トレーニング開始'),
            ),
            Text('not depelopment')
          ],
        )
      ],
    );
  }
}

// メニューリスト
class MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('チェストプレス'),
        Text('チェストプレス'),
        Text('チェストプレス'),
        Text('チェストプレス'),
        Text('チェストプレス'),
        Text('チェストプレス'),
        Text('チェストプレス'),
      ],
    );
  }
}
