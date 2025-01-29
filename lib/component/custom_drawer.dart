import 'package:flutter/material.dart';
import 'package:gymlog/screens/log.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Text('メニュー画面'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('トレーニングメニューの設定'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogPage()),
            );
          },
        ),
        ListTile(
          title: Text('記録の確認'),
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
