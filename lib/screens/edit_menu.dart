import 'package:flutter/material.dart';
// component
import 'package:gymlog/component/menu_list.dart';
// screen
import 'package:gymlog/screens/edit_menu_select.dart';
// データベース
import 'package:gymlog/db/db.dart';

class EditMenu extends StatefulWidget {
  final VoidCallback onMenuUpdated;

  const EditMenu({super.key, required this.onMenuUpdated});

  @override
  EditMenuState createState() => EditMenuState();
}

class EditMenuState extends State<EditMenu> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final GlobalKey<MenuListState> menuListKey = GlobalKey<MenuListState>();

  List<Map<String, dynamic>> menuLists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEditMenu();
  }

  // fetchMenu()：データを取得して UI を更新する関数
  Future<void> fetchEditMenu() async {
    List<Map<String, dynamic>> fetchedEditMenu = await dbHelper.getMenu();
    if (mounted) {
      setState(() {
        menuLists = fetchedEditMenu;
        isLoading = false;
      });
    }
  }

  // onItemTap(): メニューリストのタップ時の処理
  void onItemTap(BuildContext context, int id, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditMenuSelect(
                id: id,
                index: index,
                onMenuUpdated: widget.onMenuUpdated,
                onEditMenuUpdated: fetchEditMenu,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トレーニングメニュー編集'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "設定を編集したいメニューを選択してください。",
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
    );
  }
}
