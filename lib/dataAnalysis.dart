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


  final List<Data1> chartData1 = [
    Data1(date.subtract(Duration(days: 4)), 35),
    Data1(date.subtract(Duration(days: 3)), 65),
    Data1(date.subtract(Duration(days: 2)), 58),
    Data1(date.subtract(Duration(days: 1)), 87),
    Data1(date, 90),
  ];

  final List<Data2> chartData2 = [
    Data2(date.subtract(Duration(days: 4)), 3),
    Data2(date.subtract(Duration(days: 3)), 7),
    Data2(date.subtract(Duration(days: 2)), 6),
    Data2(date.subtract(Duration(days: 1)), 2),
    Data2(date, 9),
  ];

  final List<Data3> chartData3 = [
    Data3(date.subtract(Duration(days: 4)), 1,2,3,4),
    Data3(date.subtract(Duration(days: 3)), 0,3,2,4),
    Data3(date.subtract(Duration(days: 2)), 1,2,2,1),
    Data3(date.subtract(Duration(days: 1)), 1,0,0,4),
    Data3(date, 5,3,5,2),
  ];

  @override
  Widget build(BuildContext context) {
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
