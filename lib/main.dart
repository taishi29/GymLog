import 'package:flutter/material.dart';
// DateTimeクラスパッケージ
import 'package:intl/intl.dart';
import 'dart:async';
// ListViewのアニメーション
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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

// メニューリスト
class MenuList extends StatelessWidget {
  final List<String> menu = [
    'チェストプレス',
    'ラットプルダウン',
    'スクワット',
    'デッドリフト',
    'ショルダープレス',
    '腹筋',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: menu.length, // リストの長さを指定
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              tileColor: const Color.fromARGB(255, 255, 255, 255),
              title: Text(
                menu[index],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ), // リストの各項目を表示
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(
                  color: Colors.black, // 枠線の色
                  width: 2, // 枠線の太さ
                ),
              ),
            ),
          );
        });
  }
}
