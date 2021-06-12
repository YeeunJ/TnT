// example viewmodel for the form
import 'dart:typed_data';

import 'package:flutter/services.dart';

const List<String> allRepeats = <String>[
  '월',
  '화',
  '수',
  '목',
  '금',
  '토',
  '일',
];

const List<String> allAlarms = <String>[
  '없음', '5분전', '10분전', '1시간전'
];
const List<String> allAlarmsValues = <String>[
  'N', '5', '10', '1'
];

const List<String> allCalendars = <String>[
  '학교', '직장', '친목', '기타'
];
const List<String> allCalendarsValues = <String>[
  '1', '2', '3', '4'
];

class TimeTableModel {
  String name = "모바일앱 개발 피그마 만들기";
  bool isAllday = true;
  DateTime start = DateTime(2021, 03, 24, 10, 10);
  DateTime end = DateTime(2021, 03, 24, 22, 10);
  List<String> repeats = <String>[
    //'월',
    //'화',
  ];
  String alarm = '5';
  String calendar = 'C';
  int count = 0;


  String type = 'U';
  int age = 7;
  String gender = "F";
  String coatColor = 'D19FE4';
  String maneColor = '273873';
  bool hasSpots = false;
  String spotColor = 'FF5198';
  String description =
      'An intelligent and dutiful scholar with an avid love of learning and skill in unicorn magic such as levitation, teleportation, and the creation of force fields.';
  List<String> hobbies = <String>[
    '월',
    '화',
  ];
}

const List<String> allThemes = <String>[
  'black',
  'grey',
  'yellow',
  'pink',
  'skyblue',
];
const List<String> allThemesValues = <String>[
  'b','g', 'y', 'p','s'
];


class SettingModel {
  String theme = 'g';
}