import 'package:flutter/material.dart';
import 'package:gymlog/screens/log.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogPage()),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogPage()),
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
