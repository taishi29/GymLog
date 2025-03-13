import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onItemTapped; // 親Widgetに選択イベントを通知
  final int currentIndex; // 選択中のタブを親から受け取る

  const BottomNavBar({
    Key? key,
    required this.onItemTapped,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: widget.currentIndex, // 現在の選択中インデックス
      onTap: widget.onItemTapped, // タップ時の処理
      selectedItemColor: Colors.greenAccent, // 選択されたアイテムの色
      unselectedItemColor: Colors.black, // 非選択時のアイテムの色（少し薄めの白）
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_add, color: Colors.black),
          label: '記録登録',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_stories, color: Colors.black),
          label: '記録確認',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month, color: Colors.black),
          label: 'カレンダー',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
