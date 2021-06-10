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
              _meetings.add(
                  Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.blueGrey, false, document.data()['recurrenceRule'], document.data()['check'])
              );            } else if(document.data()['from'] != null && document.data()['to'] != null){
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
          _meetings.add(
          Meeting(document.id, document.data()['eventName'], document.data()['from'].toDate(), document.data()['to'].toDate(), Colors.blueGrey, false, document.data()['recurrenceRule'], document.data()['check'])
          );
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

  void deleteTodoList(String id) {
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

  Future<void> updateWholetoToday(Meeting item) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.uid+':schedule').doc(item.id).update({
      'eventName': item.eventName,
      'from': FieldValue.serverTimestamp(),
      'to': item.to,
      'background': item.background,
      'isAllDay': item.isAllDay,
      'recurrenceRule':item.recurrenceRule,
      'check': item.check,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodaytoWhole(Meeting item) async {
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