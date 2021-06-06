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
  'S', 'C', 'F', 'E'
];

class TimeTableModel {
  String name = "모바일앱 개발 피그마 만들기";
  bool isAllday = true;
  DateTime start = DateTime(2021, 03, 24, 10, 10);
  DateTime end = DateTime(2021, 03, 24, 22, 10);
  List<String> repeats = <String>[
    '월',
    '화',
  ];
  String alarm = '5';
  String calendar = 'C';



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
  double height = 3.5;
  int weight = 45;
  String style = "MG";
  DateTime showDateTime = DateTime(2010, 10, 10, 20, 30);
  double ticketPrice = 65.99;
  int boxOfficePhone = 18005551212;
  String email = 'me@nowhere.org';
  String password = 'secret1';
  double rating = 0.25;
  Uint8List photo;
  Uint8List video = Uint8List(1024 * 1024 * 15);
  Uint8List audio = Uint8List(1024 * 4);
  Uint8List customFile = Uint8List(4);

  void loadMedia() async {
    photo = (await rootBundle.load('images/logo.png'))
        .buffer
        .asUint8List();
  }
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