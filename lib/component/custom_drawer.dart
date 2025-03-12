import 'package:flutter/material.dart';
import 'package:gymlog/screens/add_menu.dart';
import 'package:gymlog/screens/log.dart';
import 'package:gymlog/screens/delete_menu.dart';

class CustomDrawer extends StatelessWidget {
  // 関数を代入できる変数
  final VoidCallback onMenuUpdated; // fetchMenu関数が入る変数

  const CustomDrawer({super.key, required this.onMenuUpdated});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text(
            'トレーニングメニューの設定',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Icon(Icons.settings),
          children: [
            ListTile(
              title: Text('トレーニングメニューの追加'),
              leading: Icon(Icons.add),
              onTap: () async {
                // add_menu画面に遷移する。
                final result = await Navigator.push(
                  context,
                  // (2) AddMenuにonMenuUpdated(fetchMenu関数)を渡し、AddMenu画面に遷移する。
                  MaterialPageRoute(
                      builder: (context) =>
                          AddMenu(onMenuUpdated: onMenuUpdated)),
                );
              },
            ),
            ListTile(
              title: Text('トレーニングメニューの編集'),
              leading: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogPage()),
                );
              },
            ),
            ListTile(
              title: Text('トレーニングメニューの削除'),
              leading: Icon(Icons.delete),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DeleteMenu(onMenuUpdated: onMenuUpdated)),
                );
              },
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.fitness_center),
          title: Text(
            '記録の確認',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.calendar_month),
          title: Text(
            'カレンダー',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text(
            'ヘルプ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback),
          title: Text(
            'お問い合わせ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogPage()),
            );
          },
        ),
      ],
    ));
  }
}
