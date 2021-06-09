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
    //await Firebase.initializeApp(); //로그인 옮길거면 옮기구 이거 주석 없애주세여!!ㅎㅎ 앞에서 하길래 일단 빼놨다!!
    print('init');
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _meetingSubscription = FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.uid)
            .snapshots()
            .listen((snapshot) {
          _timetables = [];
          _todolists = [];
          snapshot.docs.forEach((document) {
            if(document.data()['background'] != null){
              print(document.data()['eventName']+" timetable");
              _timetables.add(
                  Meeting(document.data()['eventName'], document.data()['from'], document.data()['to'], document.data()['background'], document.data()['isAllDay'])
              );
            }else{
              //print(document.data()['eventName']+" todolist");
              _todolists.add(
                  Schedule(document.id, document.data()['eventName'], document.data()['from'], null, null, null, document.data()['check'])
              );
            }
          });
        });
        notifyListeners();
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }

      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot> _meetingSubscription;
  List<Schedule> _todolists = [];
  List<Schedule> get todolist => _todolists;
  List<Schedule> _todolistsWhole = [];
  List<Schedule> get todolistWhole => _todolists;
  List<Meeting> _timetables = [];
  List<Meeting> get timetables => _timetables;
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
  Future<void> readAllProducts() async {
    print(FirebaseAuth.instance.currentUser.uid);
    _meetingSubscription = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.uid+":schedule")
        .snapshots()
        .listen((snapshot) {
      _timetables = [];
      _todolists = [];
      snapshot.docs.forEach((document) {
        if(document.data()['background'] != null){
          print(document.data()['eventName']+" timetable");
          _timetables.add(
              Meeting(document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), document.data()['background'], document.data()['isAllDay'])
          );
        }else{
          if(document.data()['from'] != null){
            print(document.data()['eventName']+" todolist");
            _todolists.add(
                Schedule(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), null, null, document.data()['check'])
            );
          }else{
            print(document.data()['eventName']+" todolistWhole");
            _todolistsWhole.add(
                Schedule(document.id, document.data()['eventName'], document.data()['from'], document.data()['to'].toDate(), null, null, document.data()['check'])
            );
          }
        }
      });
      notifyListeners();
    });
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

  void deleteTodoList(String id, String uid) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    if(uid != FirebaseAuth.instance.currentUser.uid){
      throw Exception('You can only erase what you write.');
    }

    FirebaseFirestore.instance.collection(uid).doc(id).delete();
  }

  //todo
  Future<DocumentReference> addTimeTable(TimeTableModel t) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    var repeats = "";
    t.repeats.forEach((item){
      repeats+= item;
      repeats+= "@";
    });
    final data =
    {
      "name": t.name,
      "isAllday": t.isAllday,
      "start": t.start,
      "end": t.end,
      "repeats": repeats,
      "alarm": t.alarm,
      "calendar": t.calendar,
      "regDate" : DateTime.now().millisecondsSinceEpoch,
      "editDate": DateTime.now().millisecondsSinceEpoch,
    };
    FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid).add(
        data
    );
  }

  Future<DocumentReference> addTodoList(Schedule item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid).add({
      'eventName': item.eventName,
      'from': null,
      'to': item.to,
      'background': null,
      'isAllDay': null,
      'check': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWholetoToday(Schedule item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection('product').doc(item.id).update({
      'eventName': item.eventName,
      'from': FieldValue.serverTimestamp(),
      'to': item.to,
      'background': null,
      'isAllDay': null,
      'check': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodaytoWhole(Schedule item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection('product').doc(item.id).update({
      'eventName': item.eventName,
      'from': null,
      'to': item.to,
      'background': null,
      'isAllDay': null,
      'check': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCheck(Schedule item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection('product').doc(item.id).update({
      'eventName': item.eventName,
      'from': item.from,
      'to': item.to,
      'background': null,
      'isAllDay': null,
      'check': true,
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}