import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import './Application.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String dropdownValue = 'TODO 수행률(%)';
DateTime now = new DateTime.now();
DateTime date = new DateTime(now.year, now.month, now.day);
final format = DateFormat('MM/dd');
List<Meeting> _meetings = [];

class Data1{
  Data1(this.day, this.todo);
  final DateTime day;
  final double todo;
}

class Data2{
  Data2(this.day, this.todo);
  final DateTime day;
  final double todo;
}

class Data3{
  Data3(this.day, this.sales, this.sales2, this.sales3, this.sales4);
  final DateTime day;
  final double sales;
  final double sales2;
  final double sales3;
  final double sales4;
}


class dataAnalysisPage extends StatefulWidget {

  @override
  _dataAnalysisPageState createState() => _dataAnalysisPageState();
}

class _dataAnalysisPageState extends State<dataAnalysisPage> {


  List<Data1> chartData1 = [
    Data1(date.subtract(Duration(days: 4)), 35),
    Data1(date.subtract(Duration(days: 3)), 65),
    Data1(date.subtract(Duration(days: 2)), 58),
    Data1(date.subtract(Duration(days: 1)), 87),
    Data1(date, 90),
  ];

  List<Data2> chartData2 = [
    Data2(date.subtract(Duration(days: 4)), 3),
    Data2(date.subtract(Duration(days: 3)), 7),
    Data2(date.subtract(Duration(days: 2)), 6),
    Data2(date.subtract(Duration(days: 1)), 2),
    Data2(date, 9),
  ];

  List<Data3> chartData3 = [
    Data3(date.subtract(Duration(days: 4)), 0,0,0,0),
    Data3(date.subtract(Duration(days: 3)), 0,3,2,4),
    Data3(date.subtract(Duration(days: 2)), 1,2,2,1),
    Data3(date.subtract(Duration(days: 1)), 0,0,0,2),
    Data3(date, 5,3,5,2),
  ];

  @override
  Widget build(BuildContext context) {
      Provider.of<ApplicationState>(context, listen: false).addListener(() {
        setState(() {
          _meetings = Provider.of<ApplicationState>(context, listen: false).getTodolistsWhole();
        });
      });
      setState(() {
        _meetings = Provider.of<ApplicationState>(context, listen: false).getTodolistsWhole();
      });
      List<int> d= [0,0,0,0,0];
      List<int> w = [0,0,0,0,0];
      List<List<int>> t = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]];
      for(var meeting in _meetings){
        var from = meeting.from.toString().split(" ")[0];
        var time = meeting.from.toString().split(" ")[1].split(":")[0];
        if(from != null){
          if(from == date.subtract(Duration(days: 4)).toString().split(" ")[0]){
            w[0]++;
            if(meeting.check) d[0]++;
            if(time=="00" || time=="01" || time=="02" || time=="03" || time=="04" || time=="05") t[0][0]++;
            else if(time=="06" || time=="07" || time=="08" || time=="09" || time=="10" || time=="11") t[0][1]++;
            else if(time=="12" || time=="13" || time=="14" || time=="15" || time=="16" || time=="17") t[0][2]++;
            else t[0][3]++;
          }
          else if(from == date.subtract(Duration(days: 3)).toString().split(" ")[0]){
            w[1]++;
            if(meeting.check) d[1]++;
            if(time=="00" || time=="01" || time=="02" || time=="03" || time=="04" || time=="05") t[1][0]++;
            else if(time=="06" || time=="07" || time=="08" || time=="09" || time=="10" || time=="11") t[1][1]++;
            else if(time=="12" || time=="13" || time=="14" || time=="15" || time=="16" || time=="17") t[1][2]++;
            else t[1][3]++;
          }
          else if(from == date.subtract(Duration(days: 2)).toString().split(" ")[0]){
            w[2]++;
            if(meeting.check) d[2]++;
            if(time=="00" || time=="01" || time=="02" || time=="03" || time=="04" || time=="05") t[2][0]++;
            else if(time=="06" || time=="07" || time=="08" || time=="09" || time=="10" || time=="11") t[2][1]++;
            else if(time=="12" || time=="13" || time=="14" || time=="15" || time=="16" || time=="17") t[2][2]++;
            else t[2][3]++;
          }
          else if(from == date.subtract(Duration(days: 1)).toString().split(" ")[0]){
            w[3]++;
            if(meeting.check) d[3]++;
            if(time=="00" || time=="01" || time=="02" || time=="03" || time=="04" || time=="05") t[3][0]++;
            else if(time=="06" || time=="07" || time=="08" || time=="09" || time=="10" || time=="11") t[3][1]++;
            else if(time=="12" || time=="13" || time=="14" || time=="15" || time=="16" || time=="17") t[3][2]++;
            else t[3][3]++;
          }
          else if(from == date.toString().split(" ")[0]){
            w[4]++;
            if(meeting.check) d[4]++;
            if(time=="00" || time=="01" || time=="02" || time=="03" || time=="04" || time=="05") t[4][0]++;
            else if(time=="06" || time=="07" || time=="08" || time=="09" || time=="10" || time=="11") t[4][1]++;
            else if(time=="12" || time=="13" || time=="14" || time=="15" || time=="16" || time=="17") t[4][2]++;
            else t[4][3]++;
          }
        }
      }
      chartData1 = [];
      for(var i = 0 ; i<5; i++){
        if(w[i]==0) chartData1.add(Data1(date.subtract(Duration(days: 4-i)), 0));
        else chartData1.add(Data1(date.subtract(Duration(days: 4-i)), d[i]/w[i]*100));
      }

      chartData2 = [];
      for(var i = 0 ; i<5; i++){
        chartData2.add(Data2(date.subtract(Duration(days: 4-i)), d[i]+.0));
      }

      chartData3 = [];
      for(var i = 0; i<5; i++){
        chartData3.add(Data3(date.subtract(Duration(days: 4-i)), t[i][0]+.0, t[i][1]+.0, t[i][2]+.0, t[i][3]+.0));
      }


    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
      Scaffold(
      appBar: AppBar(
        title: Text('활동 분석'),
        actions: [
          /*
          IconButton(
              icon: Icon(Icons.list),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              })*/
        ],
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              SizedBox( height: 10),
              Container(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) async{
                    //final change = await setState((){
                    setState((){
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['TODO 수행률(%)', 'TODO 달성 갯수', 'TODO 달성시간대']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox( height: 10),
              (dropdownValue =="TODO 수행률(%)") ?
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<Data1, String>(
                        dataSource: chartData1,
                        xValueMapper: (Data1 sales, _) => format.format(sales.day),
                        yValueMapper: (Data1 sales, _) => sales.todo
                    )
                  ]
              ) : Text(""),
              (dropdownValue =="TODO 달성 갯수") ?
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    // Renders line chart
                    ColumnSeries<Data2, String>(
                        dataSource: chartData2,
                        xValueMapper: (Data2 sales, _) => format.format(sales.day),
                        yValueMapper: (Data2 sales, _) => sales.todo
                    )
                  ]
              ) : Text(""),
              (dropdownValue =="TODO 달성시간대") ?
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    StackedColumn100Series<Data3, String>(
                        dataSource: chartData3,
                        xValueMapper: (Data3 sales, _) => format.format(sales.day),
                        yValueMapper: (Data3 sales, _) => sales.sales
                    ),
                    StackedColumn100Series<Data3, String>(
                        dataSource: chartData3,
                        xValueMapper: (Data3 sales, _) => format.format(sales.day),
                        yValueMapper: (Data3 sales, _) => sales.sales2
                    ),
                    StackedColumn100Series<Data3, String>(
                        dataSource: chartData3,
                        xValueMapper: (Data3 sales, _) => format.format(sales.day),
                        yValueMapper: (Data3 sales, _) => sales.sales3
                    ),
                    StackedColumn100Series<Data3, String>(
                        dataSource: chartData3,
                        xValueMapper: (Data3 sales, _) => format.format(sales.day),
                        yValueMapper: (Data3 sales, _) => sales.sales4
                    )
                  ]
              ) : Text(""),
            ],
          )
      ),
    ));
  }
}
