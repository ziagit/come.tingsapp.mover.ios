import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/screens/calendar/sync_google.dart';
import 'package:shipbay/shared/components/appbar.dart';
import 'package:shipbay/shared/components/menu.dart';
import 'package:shipbay/shared/components/slide_top_route.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shipbay/screens/calendar/add_appointment.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key key}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Store store = Store();
  var _booked = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar('Calendar'),
      drawer: MovingMenu(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: SfCalendar(
            backgroundColor: Colors.transparent,
            onTap: calendarTapped,
            view: CalendarView.month,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
          ),
        ),
      ),
      floatingActionButton: buildSpeedDial(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    Api api = new Api();
    var response = await api.get('carrier/calendar');
    if (response.statusCode == 200) {
      _booked = jsonDecode(response.body);
      if (mounted) {
        setState(() {});
      }
    }
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (int i = 0; i < _booked.length; i++) {
      final DateTime startTime =
          DateTime(_booked[i]['year'], _booked[i]['month'], _booked[i]['day']);
      final DateTime endTime = startTime.add(const Duration(hours: 12));
      meetings.add(Meeting('Busy', startTime, endTime, Colors.green, false));
    }
    return meetings;
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.sync),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: 'Sync Google',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _syncGoogleCalendar(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: 'Update',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _updateCalendar(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.link),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: 'Connect Google',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _connectGoogleCalendar(context),
        ),
      ],
    );
  }

  _updateCalendar(context) {
    Navigator.push(
            context, SlideTopRoute(page: AddAppointment(booked: _booked)))
        .then((value) => _init());
  }

  _connectGoogleCalendar(context) async {
    var store = Store();
    var user = await store.read("mover");
    String url =
        "https://tingsapp.com/connect-to-gcalendar/" + user['user'].toString();
    if (!await launch(url)) throw 'Could not launch $url';
  }

  _syncGoogleCalendar(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: SyncGoogle(),
        );
      },
    ).whenComplete(() {
      _init();
    });
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments[index];
    Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
