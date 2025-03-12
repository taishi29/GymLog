import 'package:flutter/material.dart';
// component
import 'package:gymlog/component/menu_list.dart';
// データベース
import 'package:gymlog/db/db.dart';

class DeleteMenu extends StatefulWidget {
  final VoidCallback onMenuUpdated;

  const DeleteMenu({super.key, required this.onMenuUpdated});

  @override
  DeleteMenuState createState() => DeleteMenuState();
}

class DeleteMenuState extends State<DeleteMenu> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final GlobalKey<MenuListState> menuListKey = GlobalKey<MenuListState>();

  List<Map<String, dynamic>> menuLists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenu(); // training_menuテーブルのデータを取得する関数
  }

  // fetchMenu()：データを取得して UI を更新する関数
  Future<void> fetchMenu() async {
    List<Map<String, dynamic>> fetchedMenu = await dbHelper.getMenu();
    if (mounted) {
      setState(() {
        menuLists = fetchedMenu;
        isLoading = false;
      });
    }
  }

  // onItemTap(): メニューリストのタップ時の処理
  void onItemTap(BuildContext context, int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("本当に削除しますか？"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "削除をすると、このメニューの記録及びデータが全て削除されます。",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              Text(
                "二度と復元できません。",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () async {
                await dbHelper.deleteMenu(id);
                await fetchMenu();
                widget.onMenuUpdated();
                Navigator.of(context).pop();
              },
              child: const Text(
                "削除",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トレーニングメニュー削除'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "削除したいメニューを選択してください。",
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
