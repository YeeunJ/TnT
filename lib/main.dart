import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import './addTimeTable.dart';
import './app.dart';
import 'Application.dart';
import 'global.dart' as global;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: TnT(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TnT',
      theme: ThemeData(
        primaryColor: global.primary,
        accentColor: global.accent,
      ),
      home: myCalendar(),
    );
  }
}


class myCalendar extends StatefulWidget {
  @override
  _myCalendarState createState() => _myCalendarState();
}

class _myCalendarState extends State<myCalendar> with TickerProviderStateMixin {

  int _selectedIndex = 0;

//  List<Meeting> meetings = <Meeting>[];
//  List<Schedule> todolists = <Schedule>[];
//  List<Schedule> todolistsWhole = <Schedule>[];

  bool _checkbox = false;
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;
  bool _isDue = false;
  final textController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  String _selectedDate = "";

  void _onItemTapped(int index) {
    //print(_todolistsWhole);
    setState(() {
      _selectedIndex = index;
    });
  }
  List<Meeting> _todolistWhole = [];
  List<Meeting> _todolistToday = [];
  List<Meeting> _timetables = [];
  List<Schedule> _todolists = [];

  List<Meeting> _meetings = [];
  List<Meeting> _schedule = [];
  bool itemsListening = false;

  @override
  Widget build(BuildContext context) {

    if (!itemsListening) {
      print("test1");
      Provider.of<ApplicationState>(context, listen: false).addListener(() {
        setState(() {
          _meetings = Provider.of<ApplicationState>(context, listen: false).getTodolistsWhole();
        });
        print(_meetings);
        _schedule = [];
        _todolistToday = [];
        _todolistWhole = [];
        for(var meeting in _meetings){
          if(meeting.recurrenceRule != null){
            _schedule.add(meeting);
          }
          else if(meeting.from != null){
            _todolistToday.add(meeting);
          }else{
            _todolistWhole.add(meeting);
          }
        }
      });
      itemsListening = true;
    }

    final List<Widget> _tabWidgets = [
      MonthlyCalendar(schedule : _schedule, todolistToday: _todolistToday, todolistWhole: _todolistWhole),
      WeeklyCalendar(meetingList: _meetings),
      DailyCalendar(meetingList: _meetings),
      addTimeTable()
    ];

    Color background = global.background;
    Color accent = global.accent;
    const color =  Color(0xffe0e0e0);

    return Scaffold(
      body: _tabWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'month',
              backgroundColor: color
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'week',
              backgroundColor: color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            label: 'day',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add',
              backgroundColor: color
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: accent,
        onTap: _onItemTapped,
        iconSize: 22,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              context: context,
              builder: (context) {
                print(MediaQuery.of(context).viewInsets.bottom);
                return SingleChildScrollView(
                    child: Container(
                      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTodoScreen(),
                    ));
              },
              isScrollControlled: true);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments[index].recurrenceRule;
  }
}

// 월간
class MonthlyCalendar extends StatefulWidget {
  MonthlyCalendar({Key key, @required this.schedule, @required this.todolistToday, @required this.todolistWhole}) : super(key: key);
  List<Meeting> schedule = [];
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState(schedule: schedule, todolistToday: todolistToday, todolistWhole: todolistWhole);
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  List<Meeting> schedule = [];
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];

  _MonthlyCalendarState({@required this.schedule, @required this.todolistToday, @required this.todolistWhole});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    context: context,
                    builder: (context) => AddTaskScreen(todolistToday: todolistToday, todolistWhole: todolistWhole),
                    isScrollControlled: true);
              }),
          IconButton(
              icon: Icon(Icons.bar_chart),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/dataAnalysis');
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              }),
          IconButton(
              icon: Icon(Icons.headset_rounded),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/addBySpeech');
              })
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(schedule),
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
            // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
          ),
        ),
      ),
    );
  }
}

// 주간
class WeeklyCalendar extends StatefulWidget {
  WeeklyCalendar({Key key, @required this.meetingList}) : super(key: key);
  List<Meeting> meetingList;

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState(meetingList:meetingList);
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  List<Meeting> meetingList = [];
  List<Meeting> schedule = [];
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];
  bool itemsListening = false;

  _WeeklyCalendarState({@required this.meetingList});

  @override
  Widget build(BuildContext context) {
    print(meetingList);
    schedule = [];
    todolistToday = [];
    todolistWhole = [];
    for(var meeting in meetingList){
      if(meeting.recurrenceRule != null){
        schedule.add(meeting);
      }else if(meeting.from != null){
        todolistToday.add(meeting);
      }else{
        todolistWhole.add(meeting);
      }
    }
    if (!itemsListening) {
      print("test2");
      Provider.of<ApplicationState>(context, listen: false).addListener(() {
        setState(() {
          meetingList = Provider.of<ApplicationState>(context, listen: false).getTodolistsWhole();
        });
        print(meetingList);
        schedule = [];
        todolistToday = [];
        todolistWhole = [];
        for(var meeting in meetingList){
          if(meeting.recurrenceRule != null){
            schedule.add(meeting);
          }
          else if(meeting.from != null){
            todolistToday.add(meeting);
          }else{
            todolistWhole.add(meeting);
          }
        }
      });
      itemsListening = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('calendar'),
          actions: [
            IconButton(
                icon: Icon(Icons.list),
                color: global.accent,
                iconSize: 28,
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      context: context,
                      builder: (context) => AddTaskScreen(todolistToday: todolistToday, todolistWhole: todolistWhole),
                      isScrollControlled: true);
                }),
            IconButton(
                icon: Icon(Icons.bar_chart),
                color: global.accent,
                iconSize: 28,
                onPressed: () {
                  Navigator.pushNamed(context, '/dataAnalysis');
                }),
            IconButton(
                icon: Icon(Icons.settings),
                color: global.accent,
                iconSize: 28,
                onPressed: () {
                  Navigator.pushNamed(context, '/setting');
                }),
            IconButton(
                icon: Icon(Icons.headset_rounded),
                color: Color(0xff636363),
                iconSize: 28,
                onPressed: () {
                  Navigator.pushNamed(context, '/addBySpeech');
                })
          ],
        ),
        body: Container(
          // padding: EdgeInsets.all(10),
          child: SfCalendar(
            view: CalendarView.week,
            dataSource: MeetingDataSource(schedule),
          ),
        ));
  }
}

// 일간
class DailyCalendar extends StatefulWidget {
  DailyCalendar({Key key, @required this.meetingList}) : super(key: key);
  List<Meeting> meetingList;
  @override
  _DailyCalendarState createState() => _DailyCalendarState(meetingList: meetingList);
}

class _DailyCalendarState extends State<DailyCalendar> {
  bool _ischecked = false;
  bool _ischecked2 = false;
  bool _ischecked3 = false;
  List<Meeting> meetingList = [];
  List<Meeting> schedule = [];
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];
  bool itemsListening = false;

  _DailyCalendarState({@required this.meetingList});

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(meetingList);
    schedule = [];
    todolistToday = [];
    todolistWhole = [];
    for(var meeting in meetingList){
      if(meeting.recurrenceRule != null){
       schedule.add(meeting);
      }else if(meeting.from != null){
        todolistToday.add(meeting);
      }else{
        todolistWhole.add(meeting);
      }
    }
    if (!itemsListening) {
      print("test1");
      Provider.of<ApplicationState>(context, listen: false).addListener(() {
        setState(() {
          meetingList = Provider.of<ApplicationState>(context, listen: false).getTodolistsWhole();
        });
        print(meetingList);
        schedule = [];
        todolistToday = [];
        todolistWhole = [];
        for(var meeting in meetingList){
          if(meeting.recurrenceRule != null){
            schedule.add(meeting);
          }
          else if(meeting.from != null){
            todolistToday.add(meeting);
          }else{
            todolistWhole.add(meeting);
          }
        }
      });
      itemsListening = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    context: context,
                    builder: (context) => AddTaskScreen(todolistToday: todolistToday, todolistWhole: todolistWhole),
                    isScrollControlled: true);
              }),
          IconButton(
              icon: Icon(Icons.bar_chart),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/dataAnalysis');
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: global.accent,
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              }),
          IconButton(
              icon: Icon(Icons.headset_rounded),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/addBySpeech');
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SfCalendar(
                  view: CalendarView.day,
                  dataSource: MeetingDataSource(schedule),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Text('TODAY'),
                    ),
                    Consumer<ApplicationState>(
                        builder: (context, appState, _) => Expanded(
                          child: ListView(
                            children: todolistToday.map((item) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: _ischecked,
                                    onChanged: (bool value) {
                                      Provider.of<ApplicationState>(context, listen: false).updateCheck(item, value);
                                      setState(() {
                                        _ischecked = value;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.eventName,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.minimize),
                                      iconSize: 13,
                                      color: Colors.blue,
                                      onPressed: () {
                                        Provider.of<ApplicationState>(context, listen: false).updateTodaytoWhole(item);
                                      })
                                ],
                              );
                            },).toList(),
                          ),
                        )),
                    Divider(
                      color: Colors.black45,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Text('WHOLE'),
                    ),
                    Consumer<ApplicationState>(
                        builder: (context, appState, _) => Expanded(
                          child: ListView(
                            children: todolistWhole.map((item) {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: _ischecked,
                                    onChanged: (value) {
                                      Provider.of<ApplicationState>(context, listen: false).updateCheck(item, value);
                                      setState(() {
                                        _ischecked = !_ischecked;
                                      });
                                    },
                                  ),
                                  Expanded(child: Text(item.eventName)),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 13,
                                      color: Colors.redAccent,
                                      onPressed: () {
                                        Provider.of<ApplicationState>(context, listen: false).updateWholetoToday(item);
                                      })
                                ],
                              );
                            }).toList(),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}

// 일간, 전체 일정 추가하기 위젯
class addWidget extends StatefulWidget {
  @override
  _addWidgetState createState() => _addWidgetState();
}

class _addWidgetState extends State<addWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('hello'),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];

  AddTaskScreen({Key key, @required this.todolistToday,  @required this.todolistWhole}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState(todolistToday: todolistToday, todolistWhole: todolistWhole);
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool _checkbox = false;
  List<Meeting> todolistToday = [];
  List<Meeting> todolistWhole = [];

  _AddTaskScreenState({@required this.todolistToday,  @required this.todolistWhole});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Container(
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TabBar(
                    tabs: [
                      Tab(text: "일간"),
                      Tab(text: "전체"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        ListView(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          children: todolistToday.map((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: _checkbox,
                                  onChanged: (value) {
                                    setState(() {
                                      print(_checkbox);
                                      _checkbox = !_checkbox;
                                    });
                                  },
                                ),
                                Expanded(child: Text(item.eventName)),
                                IconButton(
                                    icon: Icon(Icons.minimize),
                                    iconSize: 13,
                                    color: Colors.blue,
                                    onPressed: () {
                                      Provider.of<ApplicationState>(context, listen: false).updateTodaytoWhole(item);
                                    })
                              ],
                            );
                          },).toList(),
                        ),
                        ListView(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          children: todolistWhole.map((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: _checkbox,
                                  onChanged: (value) {
                                    setState(() {
                                      print(_checkbox);
                                      _checkbox = !_checkbox;
                                    });
                                  },
                                ),
                                Expanded(child: Text(item.eventName)),
                                IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 13,
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      Provider.of<ApplicationState>(context, listen: false).updateWholetoToday(item);
                                    })
                              ],
                            );
                          },).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController textController = TextEditingController();
  String _selectedDate = null;
  bool _isDue = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        height: 140,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: '할 일을 입력하세요.',
                        border: UnderlineInputBorder(),
                        focusColor: global.accent,
                        fillColor: global.accent,
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if(_selectedDate == null){
                          Provider.of<ApplicationState>(context, listen: false).addTodoList(Meeting(null, textController.text, null, null, null,null, null, false));
                        }else{
                          Provider.of<ApplicationState>(context, listen: false).addTodoList(Meeting(null, textController.text, null, DateTime.parse(_selectedDate), null,null, null, false));
                        }
                        Navigator.pop(context);
                      }
                  ),
                ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    Future<DateTime> selectedDate = showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018), // 시작일
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child,
                          );
                        });
                    selectedDate.then((dateTime) {
                      setState(() {
                        if (dateTime != null)
                          _selectedDate =
                              DateFormat('yyyy-MM-dd').format(dateTime);
                        print(_selectedDate);
                      });
                    });
                  },
                ),
                _selectedDate == null ? Text('마감일 선택') : Text(_selectedDate),
                SizedBox(
                  width: 20,
                ),
                Checkbox(
                  value: _isDue,
                  onChanged: (value) {
                    print(_isDue);
                    setState(() {
                      _isDue = !_isDue;
                    });
                  },
                ),
                Text('마감일 없음'),
              ],
            )
          ],
        ),
      ),
    );
  }
}


