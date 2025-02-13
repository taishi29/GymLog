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
    return Scaffold(
      appBar: AppBar(
        title: Text('筋トレ記録アプリ'),
        backgroundColor: const Color.fromARGB(255, 191, 255, 168),
        centerTitle: true,
      ),
      // (1) CustomDrawerクラスのonMenuUpdatedにfetchMenu関数を渡してインスタンス化
      drawer: CustomDrawer(onMenuUpdated: fetchMenu),
      // メニューボタンがAppBarの左端に表示される。
      body: CustomScrollView(
        slivers: [
          // 上部の `TopSection` を固定する
          SliverPersistentHeader(
            pinned: true, // これを `true` にするとスクロールしても `TopSection` が固定される
            floating: false,
            delegate: _TopSectionDelegate(),
          ),
          // 区切り線を追加
          SliverToBoxAdapter(
            child: const Divider(
              color: Color.fromARGB(255, 112, 112, 112), // 線の色
              thickness: 2, // 線の太さ
              height: 2, // `Divider` の高さ
            ),
          ),
          // `MenuList` のスクロールを有効にする
          SliverFillRemaining(
            child: MenuList(menuLists: menuLists, isLoading: isLoading),
          ),
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

class _TopSectionDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255), // 背景色を白にする
      padding: const EdgeInsets.only(bottom: 8.0),
      child: const TopSection(title: 'Hello! World!'),
    );
  }

  @override
  double get maxExtent => 300; // `TopSection` の高さ
  @override
  double get minExtent => 300; // スクロールしても高さを維持
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
