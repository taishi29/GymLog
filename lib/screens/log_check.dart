import 'package:flutter/material.dart';
// component
import 'package:gymlog/component/menu_list.dart';
import 'package:gymlog/component/bottom_var.dart';
import 'package:gymlog/screens/calender.dart';
//screen
import 'package:gymlog/screens/log_check_select.dart';
import 'package:gymlog/main.dart';
import 'package:gymlog/screens/calender.dart';
// データベース
import 'package:gymlog/db/db.dart';

class LogCheck extends StatefulWidget {
  const LogCheck({super.key});

  @override
  LogCheckState createState() => LogCheckState();
}

class LogCheckState extends State<LogCheck> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final GlobalKey<MenuListState> menuListKey = GlobalKey<MenuListState>();

  List<Map<String, dynamic>> menuLists = [];
  bool isLoading = true;

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchLogCheckMenu(); // training_menuテーブルのデータを取得する関数
  }

  // fetchMenu()：データを取得して UI を更新する関数
  Future<void> fetchLogCheckMenu() async {
    List<Map<String, dynamic>> fetchedMenu = await dbHelper.getMenu();
    if (mounted) {
      setState(() {
        menuLists = fetchedMenu;
        isLoading = false;
      });
    }
  }

  // onItemTap(): メニューリストのタップ時の処理
  void onItemTap(BuildContext context, int id, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LogCheckSelect(
                id: id,
                index: index,
                onEditMenuUpdated: fetchLogCheckMenu,
              )),
    );
  }

  // BottomNavigationBar のタップ時の処理
  void _bottomNaviTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250), // アニメーション時間
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              TrainingCalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250), // アニメーション時間
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録の確認'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "記録を確認したいメニューを選択してください。",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Expanded(
              child: MenuList(
                menuLists: menuLists,
                onItemTap: onItemTap,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1, //太さ
              color: Colors.grey[200]!,
            ),
          ),
        ),
        child: BottomNavBar(
          onItemTapped: _bottomNaviTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
