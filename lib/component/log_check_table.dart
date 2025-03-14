import 'package:flutter/material.dart';
import 'package:gymlog/db/db.dart';
import 'package:intl/intl.dart';

class LogCheckTable extends StatefulWidget {
  final int trainingId;

  const LogCheckTable({super.key, required this.trainingId});

  @override
  State<LogCheckTable> createState() => _LogCheckTableState();
}

class _LogCheckTableState extends State<LogCheckTable> {
  List<Map<String, dynamic>> records = [];
  bool isLoading = true; // 🔥 ロード状態管理

  final DatabaseHelper dbHelper = DatabaseHelper.instance; // 🔥 DB インスタンス

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// **データをロード**
  Future<void> _loadData() async {
    final fetchedRecords = await dbHelper.getRecord();

    // `trainingId` に該当するデータをフィルタリング
    List<Map<String, dynamic>> filteredRecords = fetchedRecords
        .where((record) => record['training_id'] == widget.trainingId)
        .toList();

    // 📅 **日付を降順でソート**
    filteredRecords.sort((a, b) => DateTime.parse(b['date_time'])
        .compareTo(DateTime.parse(a['date_time'])));

    setState(() {
      records = filteredRecords;
      isLoading = false;
    });
  }

  /// **削除処理**
  Future<void> _deleteRecord(int recordId) async {
    bool confirm = await _showDeleteConfirmation(); // 🔥 確認ダイアログを表示
    if (!confirm) return; // キャンセルされたら処理を中断

    await dbHelper.deleteRecord(recordId); // 🔥 DB から削除
    setState(() {
      records.removeWhere(
          (record) => record['record_id'] == recordId); // 🔥 UIから削除
    });
  }

  /// **削除確認ダイアログ**
  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("削除確認"),
            content: const Text("この記録を削除しますか？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // ❌ キャンセル
                child: const Text("キャンセル"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // ✅ 削除
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("削除"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // 🔥 `LogCheckSelect` と統一
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.cyan, // 🔥 ローディングアイコン
              ),
            )
          : records.isEmpty
              ? const Center(
                  child: Text(
                    "データがありません",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📌 **ヘッダー**
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade800, // 🔥 ヘッダー背景色
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text("日付",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("重さ (kg)",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("セット数",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("回数",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("削除",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold)), // **削除ボタンのヘッダー**
                        ],
                      ),
                    ),

                    // 📌 **データリスト**
                    Expanded(
                      child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.white24, width: 1), // 🔥 区切り線
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  DateFormat("MM/dd").format(
                                      DateTime.parse(record['date_time'])),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(record['weight'].toString(),
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text(record['set_number'].toString(),
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Text(record['count'].toString(),
                                    style:
                                        const TextStyle(color: Colors.white70)),

                                // 🔥 **削除ボタン**
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _deleteRecord(record['record_id']),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
