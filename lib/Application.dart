import 'dart:async';
import 'dart:io'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './model.dart';

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    print('inininit');
    init();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  Future<void> init() async {
    await Firebase.initializeApp(); //로그인 옮길거면 옮기구 이거 주석 없애주세여!!ㅎㅎ 앞에서 하길래 일단 빼놨다!!
    print('init');
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _meetingSubscription = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.uid+":schedule")
            .snapshots()
            .listen((snapshot) {
          _meetings = [];
          snapshot.docs.forEach((document) {
            if(document.data()['background'] != null){
              if(document.data()['background'] == 1){
                _meetings.add(
                    Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Color(0xFF0F8644), false, document.data()['recurrenceRule'], document.data()['check'])
                );
                print("check1");
              }
              else if(document.data()['background'] == 2){
                _meetings.add(
                    Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.amberAccent, false, document.data()['recurrenceRule'], document.data()['check'])
                );
                print("check2");
              }
              else if(document.data()['background'] == 3){
                _meetings.add(
                    Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.pinkAccent, false, document.data()['recurrenceRule'], document.data()['check'])
                );
                print("check3");
              }
              else if(document.data()['background'] == 4){
                _meetings.add(
                    Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.yellow, false, document.data()['recurrenceRule'], document.data()['check'])
                );
                print("check4");
              }
            }

            else if(document.data()['from'] != null && document.data()['to'] != null){
              _meetings.add(
                  Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), null, false, document.data()['recurrenceRule'], document.data()['check'])
              );
            }else if(document.data()['from'] != null){
              _meetings.add(
                  Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'], null, false, document.data()['recurrenceRule'], document.data()['check'])
              );
            }else if(document.data()['to'] != null){
              _meetings.add(
                  Meeting(document.id, document.data()['eventName'], document.data()['from'], document.data()['to'].toDate(), null, false, document.data()['recurrenceRule'], document.data()['check'])
              );
            }else{
              _meetings.add(
                  Meeting(document.id, document.data()['eventName'], document.data()['from'], null, null, false, document.data()['recurrenceRule'], document.data()['check'])
              );
            }
          });
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
    });
    notifyListeners();
  }

  StreamSubscription<QuerySnapshot> _meetingSubscription;
  List<Schedule> _todolists = [];
  List<Schedule> get todolist => _todolists;
  List<Schedule> _todolistsWhole = [];
  List<Schedule> get todolistWhole => _todolists;
  List<Meeting> _meetings = [];
  List<Meeting> get meetings => _meetings;
  List<int> _data1 = [30,65,58,87,90];
  List<int> _data2 = [3,7,6,2,9];
  List<List<int>> _data3 = [[1,2,3,4], [0,3,2,4], [1,2,2,1], [1,0,0,4], [5,3,5,2]];

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential credit =
    await FirebaseAuth.instance.signInWithCredential(credential);
    _loginState = ApplicationLoginState.loggedIn;
    return credit;
  }
  List<Meeting> getTodolistsWhole(){
    //addTodoList();
    readAllProducts();
    print(_todolistsWhole);

    return _meetings;
  }

  List<Meeting> readAllProducts() {
    print(FirebaseAuth.instance.currentUser.uid);
    _meetingSubscription = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid+":schedule")
        .snapshots()
        .listen((snapshot) {
      _meetings = [];
      snapshot.docs.forEach((document) {
        if(document.data()['background'] != null){
          if(document.data()['background'] == 1){
          _meetings.add(
          Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Color(0xFF0F8644), false, document.data()['recurrenceRule'], document.data()['check'])
        );
        print("check1");
        }
        else if(document.data()['background'] == 2){
        _meetings.add(
        Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.amberAccent, false, document.data()['recurrenceRule'], document.data()['check'])
        );
        print("check2");
        }
        else if(document.data()['background'] == 3){
        _meetings.add(
        Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.pinkAccent, false, document.data()['recurrenceRule'], document.data()['check'])
        );
        print("check3");
        }
        else if(document.data()['background'] == 4){
        _meetings.add(
        Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.yellow, false, document.data()['recurrenceRule'], document.data()['check'])
        );
        print("check4");
        }
        } else if(document.data()['from'] != null && document.data()['to'] != null){
          _meetings.add(
              Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), null, false, document.data()['recurrenceRule'], document.data()['check'])
          );
        }else if(document.data()['from'] != null){
          _meetings.add(
              Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'], null, false, document.data()['recurrenceRule'], document.data()['check'])
          );
        }else if(document.data()['to'] != null){
          _meetings.add(
              Meeting(document.id, document.data()['eventName'], document.data()['from'], document.data()['to'].toDate(), null, false, document.data()['recurrenceRule'], document.data()['check'])
          );
        }else{
          _meetings.add(
              Meeting(document.id, document.data()['eventName'], document.data()['from'], null, null, false, document.data()['recurrenceRule'], document.data()['check'])
          );
        }
      });
    });

    return _meetings;
  }


  Future<void> readTodoListProducts() async {

    _meetingSubscription = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid)
        .where("background", isNull:true)
        .snapshots()
        .listen((snapshot) {
      _todolists = [];
      snapshot.docs.forEach((document) {
        _todolists.add(
            Schedule(document.id, document.data()['eventName'], document.data()['from'].toDate(), null, null, null, document.data()['check'])
        );
      });
      notifyListeners();
    });
  }

  void deleteSchedule(String id) {
//    if (_loginState != ApplicationLoginState.loggedIn) {
//      throw Exception('Must be logged in');
//    }

    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+":schedule").doc(id).delete();
  }

  //todo
  Future<DocumentReference> addTimeTable(TimeTableModel t) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    var repeats = "";
    var i=0;
    t.repeats.forEach((item){
      if(i==0) repeats = "FREQ=WEEKLY;INTERVAL=1;BYDAY=";
      else repeats += ",";
      if(item=="월")repeats += "MO";
      else if (item=="화")repeats += "TU";
      else if (item=="수")repeats += "WE";
      else if (item=="목")repeats += "TH";
      else if (item=="금")repeats += "FR";
      else if (item=="토")repeats += "SA";
      else if (item=="일")repeats += "SU";
    });
    if(repeats!="") {
      if (t.count == null)
        repeats += ";COUNT=1";
      else
        repeats += ";COUNT=" + t.count.toString();
    }
    final data =
    {
      "background": int.parse(t.calendar),
      "eventName": t.name,
      "isAllDay": t.isAllday,
      "from": t.start,
      "to": t.end,
      "recurrenceRule": repeats,
      "alarm": t.alarm,
      "calendar": t.calendar,
      "timestamp" : FieldValue.serverTimestamp(),
      "editDate": FieldValue.serverTimestamp(),
      "check": false,
    };
    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').add(
        data
    );
  }

  Future<DocumentReference> addTodoList(Meeting item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').add({
      'eventName': item.eventName,
      'from': null,
      'to': item.to,
      'background': null,
      'isAllDay': null,
      'recurrenceRule': null,
      'check': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWholetoToday(Meeting item, DateTime value) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').doc(item.id).update({
      'eventName': item.eventName,
      'from': value,
      'to': item.to,
      'background': item.background,
      'isAllDay': item.isAllDay,
      'recurrenceRule':item.recurrenceRule,
      'check': item.check,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodaytoWhole(Meeting item, DateTime value) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').doc(item.id).update({
      'eventName': item.eventName,
      'from': null,
      'to': item.to,
      'background': item.background,
      'isAllDay': item.isAllDay,
      'recurrenceRule':item.recurrenceRule,
      'check': item.check,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCheck(Meeting item, bool value) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').doc(item.id).update({
      'eventName': item.eventName,
      'from': item.from,
      'to': item.to,
      'background': item.background,
      'isAllDay': item.isAllDay,
      'recurrenceRule':item.recurrenceRule,
      'check': value,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class Schedule {
  Schedule(this.id, this.eventName, this.from, this.to, this.background, this.isAllDay, this.check);
  String id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  bool check;
}


class Meeting {
  Meeting(this.id, this.eventName, this.from, this.to, this.background, this.isAllDay, this.recurrenceRule, this.check);
  String id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String recurrenceRule;
  bool check;
}