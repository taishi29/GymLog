import 'package:flutter/material.dart';
import 'package:gymlog/screens/add_menu.dart';
import 'package:gymlog/screens/calender.dart';
import 'package:gymlog/screens/edit_menu.dart';
import 'package:gymlog/screens/form.dart';
import 'package:gymlog/screens/log_check.dart';
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddMenu(onMenuUpdated: onMenuUpdated)),
                  );
                },
              ),
              ListTile(
                title: Text('トレーニングメニューの編集'),
                leading: Icon(Icons.edit),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditMenu(onMenuUpdated: onMenuUpdated)),
                  );
                },
              ),
              ListTile(
                title: Text('トレーニングメニューの削除'),
                leading: Icon(Icons.delete),
                onTap: () async {
                  await Navigator.push(
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
            leading: Icon(Icons.auto_stories),
            title: Text(
              '記録の確認',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogCheck()),
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
                MaterialPageRoute(
                    builder: (context) => TrainingCalendarScreen()),
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
              // 何も動作しないようにする
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LogPage()),
              // );
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
                MaterialPageRoute(builder: (context) => ContactFormScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
