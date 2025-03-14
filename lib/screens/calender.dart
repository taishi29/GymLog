import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:gymlog/db/db.dart';
import 'package:gymlog/component/bottom_var.dart';
import 'package:gymlog/main.dart';
import 'package:gymlog/screens/log_check.dart';

class TrainingCalendarScreen extends StatefulWidget {
  @override
  _TrainingCalendarScreenState createState() => _TrainingCalendarScreenState();
}

class _TrainingCalendarScreenState extends State<TrainingCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {}; // 🔥 トレーニング種目を保存
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchTrainingRecords();
  }

  // BottomNavigationBar のタップ時の処理
  void _bottomNaviTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250), // アニメーション時間
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LogCheck(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250), // アニメーション時間
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // SQLiteからトレーニング記録を取得
  Future<void> _fetchTrainingRecords() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> records =
        await dbHelper.getRecordWithTrainingName();

    Map<DateTime, Set<String>> events = {}; // 🔥 Setを使って重複を防ぐ
    for (var record in records) {
      DateTime date = DateTime.parse(record['date_time']);
      DateTime dayKey = DateTime(date.year, date.month, date.day);
      String exerciseName = record['training_name'];

      if (!events.containsKey(dayKey)) {
        events[dayKey] = {};
      }
      events[dayKey]!.add(exerciseName); // 🔥 Setに追加することで重複を防ぐ
    }

    if (!mounted) return;
    setState(() {
      _events = events.map(
          (key, value) => MapEntry(key, value.toList())); // 🔥 Set → List に変換
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("トレーニングカレンダー")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _events[DateTime(day.year, day.month, day.day)] ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green, // 🔥 マーカーの色を緑にする
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _selectedDay != null &&
                    _events.containsKey(DateTime(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day))
                ? Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // 🔥 リストは左揃えのまま
                    children: [
                      Center(
                        // 🔥 タイトルだけ中央揃え
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "トレーニング種目一覧",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: (_events[DateTime(
                                      _selectedDay!.year,
                                      _selectedDay!.month,
                                      _selectedDay!.day)] ??
                                  [])
                              .map((exercise) => ListTile(
                                    title: Text(exercise), // 🔥 トレーニング種目を表示
                                    leading: Icon(Icons.fitness_center),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : Center(child: Text("トレーニング記録なし")),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1, //太さ
              color: Colors.grey[200]!,
            ),
          ),
        ),
        child: BottomNavBar(
          onItemTapped: _bottomNaviTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
