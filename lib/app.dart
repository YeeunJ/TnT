import 'package:flutter/material.dart';

import 'main.dart';
import 'login.dart';
import 'addTimeTable.dart';
import 'editTimeTable.dart';
import 'setting.dart';


class TnT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TnT',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor:  Color(0xff636363),
        ),
        home: myCalendar(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => SplashScreen(),
          '/home': (context) => myCalendar(),
          '/addTimeTable': (context) => addTimeTable(),
          '/editTimeTable': (context) => editTimeTable(),
          '/setting': (context) => settingPage(),
        }
    );
  }
}