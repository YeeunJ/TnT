import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:tnt/speech_api.dart';
import 'package:provider/provider.dart';
import './Application.dart';
import './model.dart';

class SpeechPage extends StatefulWidget {
  @override
  _SpeechPageState createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  bool speakStatus = false;
  String errorMsg = '음성 인식을 해주세요!!';
  String text = '아래의 마이크 버튼을 누르고 말하기를 시작하세요😊';
  bool isListening = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _allDayKey = GlobalKey<FormState>();
  bool _isPlan = false;
  Meeting plan;


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('음성 인식 일정 추가'),
      actions: [
        IconButton(
            icon: Icon(Icons.add_circle),
            color: Color(0xff636363),
            iconSize: 28,
            onPressed: () {
              if(!_isPlan)
                parsePlan();
              else  parseTodo();

              if(speakStatus)
                showAlertDialog(context);
              else
                showErrorDialog(context);
            }),
      ],
    ),
    body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(30).copyWith(bottom: 150),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30,),
                Text(
                    '일정',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                ),
                Switch(
                  value: _isPlan,
                  onChanged: (value) {
                    setState(() {
                      _isPlan = value;
                    });
                  },
                  // activeTrackColor: Colors.lightGreenAccent,
                  // activeColor: Colors.green,
                ),
                Text(
                  '할일',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                ),
                SizedBox(width: 30,),
              ],
            ),
            SizedBox(height: 25,),
            // _isPlan ?
            // Text(
            //   '일정을 음성으로 입력해주세요!',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            // ):
            // Text(
            //     '할일을 음성으로 입력해주세요!',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            // ),
            Text(
                '아래 예시와 동일한 형식으로 입력해주세요',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            SizedBox(height: 10,),
            _isPlan ?
            Text(
                '''(ex) 프로젝트 파이널 영상 찍기
(ex) 6월 13일 오후 3시 30분까지 프로젝트 파이널 영상 찍기
                ''',
              textAlign: TextAlign.center,
            ):
            Text(
                '''(ex) 6월 13일 오후 3시 30분부터 
6월 15일 오후 4시 30분까지 
파이널 프로젝트 영상 찍기''',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20,),
            Divider(color: Colors.black38,),
            SizedBox(height: 20,),
            Text(
                text,
                style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                )
            )
          ],
        )

    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: AvatarGlow(
      animate: isListening,
      endRadius: 75,
      glowColor: Theme.of(context).primaryColor,
      child: FloatingActionButton(
        child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
        onPressed: () {
          setState(() {
            speakStatus = true;
          });
          toggleRecording();
        },
      ),
    ),
  );

  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() {
        this.isListening = isListening;
      });
    },
  );

  void parseTodo() {

    if(text.contains('까지')) {
      print(text.split('까지'));
      List<String> parse = text.split('까지');
      print(parse[0].trim());
      print(parse[1].trim());
      String date = parse[0].trim();
      String eventName = parse[1].trim();

      bool pm = true;
      String real = "";
      if(date.contains('오전')) {
        pm = false;
        date = date.replaceFirst('오전 ', '');
      } else {
        date = date.replaceFirst('오후 ', '');
      }

      var parsedate = date.split(' ');
      print(parsedate);

      if(int.parse(parsedate[0].replaceFirst('월','').trim()) < 10) {
        real = '2021-0'+parsedate[0].replaceFirst('월','').trim();
      }else {
        real = '2021-' + parsedate[0].replaceFirst('월', '').trim();
      }
      if(int.parse(parsedate[1].replaceFirst('일','').trim()) < 10) {
        real += '-0'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }else {
        real += '-'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }
      if(pm) {
        print(parsedate[2].replaceFirst('시', '').trim());
        int hour = int.parse(parsedate[2].replaceFirst('시', '').trim()) + 12;
        real += hour.toString()+":";
      } else {
        real += parsedate[2].replaceFirst('시', '').trim()+":";
      }
      if(date.contains('분'))
        real += parsedate[3].replaceFirst('분', '').trim();

      DateTime to = DateTime.parse(real);
      print(to); // 2020-01-02 03:04:05.000

      plan = Meeting(null, eventName, null, to, null,null, null, false);

    } else {
      print(text);
      String eventName = text;
      plan = Meeting(null, eventName, null, null, null,null, null, false);
    }
  }

  void parsePlan() {
    if(text.contains('부터') && text.contains('까지') && text.contains('월') && text.contains('일')) {

      // from date 만들기
      List<String> parse = text.split('부터');
      print(parse[0].trim());
      print(parse[1].trim());
      String date = parse[0].trim();

      bool pm = true;
      String real = "";
      if(date.contains('오전')) {
        pm = false;
        date = date.replaceFirst('오전 ', '');
      } else {
        date = date.replaceFirst('오후 ', '');
      }

      var parsedate = date.split(' ');
      print(parsedate);
      if(int.parse(parsedate[0].replaceFirst('월','').trim()) < 10) {
        real = '2021-0'+parsedate[0].replaceFirst('월','').trim();
      }else {
        real = '2021-' + parsedate[0].replaceFirst('월', '').trim();
      }
      if(int.parse(parsedate[1].replaceFirst('일','').trim()) < 10) {
        real += '-0'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }else {
        real += '-'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }
      if(pm) {
        print(parsedate[2].replaceFirst('시', '').trim());
        int hour = int.parse(parsedate[2].replaceFirst('시', '').trim()) + 12;
        real += hour.toString()+":";
      } else {
        real += parsedate[2].replaceFirst('시', '').trim()+":";
      }
      if(date.contains('분'))
        real += parsedate[3].replaceFirst('분', '').trim();

      DateTime from = DateTime.parse(real);

      // to date 만들기
      var subDate = parse[1].split('까지');
      print(subDate);
      date = subDate[0].trim();
      String eventName = subDate[1].trim();
      print(date);

      pm = true;
      real = "";
      if(date.contains('오전')) {
        pm = false;
        date = date.replaceFirst('오전 ', '');
      } else {
        date = date.replaceFirst('오후 ', '');
      }
      parsedate = date.split(' ');
      print(parsedate);
      if(int.parse(parsedate[0].replaceFirst('월','').trim()) < 10) {
        real = '2021-0'+parsedate[0].replaceFirst('월','').trim();
      }else {
        real = '2021-' + parsedate[0].replaceFirst('월', '').trim();
      }
      if(int.parse(parsedate[1].replaceFirst('일','').trim()) < 10) {
        real += '-0'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }else {
        real += '-'+parsedate[1].replaceFirst('일', '').trim()+'T';
      }
      if(pm) {
        print(parsedate[2].replaceFirst('시', '').trim());
        int hour = int.parse(parsedate[2].replaceFirst('시', '').trim()) + 12;
        real += hour.toString()+":";
      } else {
        real += parsedate[2].replaceFirst('시', '').trim()+":";
      }
      if(date.contains('분'))
        real += parsedate[3].replaceFirst('분', '').trim();

      DateTime to = DateTime.parse(real);

      plan = Meeting(null, eventName, from, to, null,null, null, false);
      print(plan.to);
      print(plan.from);
      print(plan.eventName);


    } else {
      print('형식 안맞음');
      setState(() {
        errorMsg = '형식에 맞춰서 말해주세요!';
        speakStatus = false;
      });
    }
  }

  void showErrorDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              errorMsg
          ),
          // content: Text('음성 인식을 해주세요!'),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: _isPlan ?
          Text(
            '할일을 추가하시겠습니까?'
          ):
          Text(
              '일정을 추가하시겠습니까?'
          ),
          content: !_isPlan ?
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('일정 이름: '+plan.eventName),
              SizedBox(height: 7,),
              Text('시작일: '+plan.from.toString()),
              SizedBox(height: 7,),
              Text('종료일: '+plan.to.toString()),
            ],
          ):
          plan.to == null ?
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('일정 이름: '+plan.eventName),
            ],
          ):
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('일정 이름: '+plan.eventName),
              SizedBox(height: 7,),
              Text('종료일: '+plan.to.toString()),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('추가'),
              onPressed: () {
                print(_isPlan);
                if(_isPlan)
                  Provider.of<ApplicationState>(context, listen: false).addTodoList(Meeting(null, plan.eventName, null, DateTime.parse(plan.to.toString()), null,null, null, false));
                else{
                  TimeTableModel _timetableModel = TimeTableModel();
                  _timetableModel.name = plan.eventName;
                  _timetableModel.start=plan.from;
                  _timetableModel.end=plan.to;
                  _timetableModel.calendar = '4';
                  Provider.of<ApplicationState>(context, listen: false).addTimeTable(_timetableModel);
                }
                //else로 일정 add 추가
                Navigator.pop(context, "OK");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }
}
