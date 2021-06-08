import 'package:flutter/material.dart';

import 'main.dart';
import 'login.dart';
import 'addTimeTable.dart';
import 'editTimeTable.dart';
import 'setting.dart';
import 'dataAnalysis.dart';
import 'global.dart' as global;


class TnT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TnT',
        theme: ThemeData(
          primaryColor: global.primary,
          accentColor:  global.accent,
        ),
        home: myCalendar(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => SplashScreen(),
          '/home': (context) => myCalendar(),
          '/addTimeTable': (context) => addTimeTable(),
          '/editTimeTable': (context) => editTimeTable(),
          '/setting': (context) => settingPage(),
          '/dataAnalysis': (context) => dataAnalysisPage(),
        }
    );
  }
}