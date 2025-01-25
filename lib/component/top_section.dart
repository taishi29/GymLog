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
  String startTime = '';
  int index = 0;

  @override
  void initState() {
    super.initState();
    // 時刻を一秒ごとに更新するタイマー
    Timer.periodic(const Duration(seconds: 1), _onTimer);
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
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // 外側の円
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              // 内側の円
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("現在の時刻"),
                Text(
                  nowTime,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 24), // 横方向の余白
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ボタンがタップされた時の処理
                    startTime = nowTime;
                  },
                  child: const Text('トレーニング開始'),
                ),
                const SizedBox(height: 10), // 縦方向の余白
                Text(startTime,
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
