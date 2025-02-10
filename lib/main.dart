import 'package:flutter/material.dart';
// screens
import 'package:gymlog/screens/log.dart';
// component
import 'package:gymlog/component/top_section.dart'; // 画面上部の時刻を表示するwidget
import 'package:gymlog/component/custom_drawer.dart'; // サイドメニューを表示する
// データベース
import 'package:gymlog/db/db.dart';

// main関数
void main() {
  runApp(const MyApp());
}

// アプリの基本設定
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymLog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

/* HOME画面 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得

    return Scaffold(
      appBar: AppBar(
        title: Text('筋トレ記録アプリ'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      // (1) CustomDrawerクラスのonMenuUpdatedにfetchMenu関数を渡してインスタンス化
      drawer: CustomDrawer(onMenuUpdated: fetchMenu),
      // メニューボタンがAppBarの左端に表示される。
      body: Column(
        children: [
          SizedBox(
            height: screenHeight / 3, // 画面の高さの3分の1の高さ
            child: TopSection(title: 'Hello World!'), // 時刻とトレーニング開始時刻
          ),
          const Divider(),
          Expanded(
            child: MenuList(menuLists: menuLists, isLoading: isLoading),
          ), // 筋トレメニューリスト
        ],
      ),
    );
  }
}

// メニューリスト
class MenuList extends StatefulWidget {
  final List<Map<String, dynamic>> menuLists; // データを受け取る変数
  final bool isLoading;

  // コンストラクタ
  MenuList({super.key, required this.menuLists, required this.isLoading});

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogPage()),
                );
              },
            ),
          );
        });
  }
}
