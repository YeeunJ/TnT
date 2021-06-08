import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:tnt/speech_api.dart';

class SpeechPage extends StatefulWidget {
  @override
  _SpeechPageState createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  String text = 'Press the button and start speaking';
  bool isListening = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
              showAlertDialog(context);
            }),
      ],
    ),
    body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(30).copyWith(bottom: 150),
        child: Column(
          children: [
            Text(
                '일정 추가 형식'
            ),
            Text(
              '시작일 (YY년 M월 D일 H시 M분)'
            ),
            Text(
                '종료일 (YY년 M월 D일 H시 M분)'
            ),
            Text(
                '반복 요일 (월,화,수,목,금)'
            ),
            Text(
                '일정이름'
            ),
            Text(
                '종일 여부(예, 아니요)'
            ),

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
        onPressed: toggleRecording,
      ),
    ),
  );

  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() => this.isListening = isListening);
    },
  );

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정을 추가하시겠습니까?'),
          content: Text("Select button you want"),
          actions: <Widget>[
            FlatButton(
              child: Text('추가'),
              onPressed: () {
                Navigator.pop(context, "OK");
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
