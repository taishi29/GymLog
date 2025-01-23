import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // ListViewのアニメーション

// screens
import 'package:gymlog/screens/log.dart';
// component
import 'package:gymlog/component/top_section.dart';

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 50, 47, 47)),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogPage()),
                );
              },
            ),
          );
        });
  }
}
