import 'package:flutter/material.dart';

// メニューリスト
class MenuList extends StatefulWidget {
  // データを受け取る変数
  final List<Map<String, dynamic>> menuLists;
  // メニューリストのタップ処理を格納する変数
  final void Function(BuildContext context, int id, int index) onItemTap;
  final bool isLoading;

  // コンストラクタ
  MenuList(
      {super.key,
      required this.menuLists,
      required this.onItemTap,
      required this.isLoading});

  @override
  MenuListState createState() => MenuListState();
}

class MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: widget.menuLists.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            tileColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              widget.menuLists[index]["training_name"],
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
              int id = widget.menuLists[index]['training_id'];
              widget.onItemTap(context, id, index);
            },
          ),
        );
      },
    );
  }
}
