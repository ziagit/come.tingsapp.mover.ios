import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddAppointment extends StatefulWidget {
  final booked;
  AddAppointment({Key key, this.booked}) : super(key: key);

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  Store store = Store();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Press and hold a date"),
        backgroundColor: Tingsapp.transparent,
        iconTheme: IconThemeData(),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.transparent),
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey))
            : SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: SfCalendar(
                    onLongPress: calenderPressed,
                    backgroundColor: Colors.transparent,
                    view: CalendarView.month,
                    dataSource: MeetingDataSource(_getDataSource()),
                    monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (int i = 0; i < widget.booked.length; i++) {
      final DateTime startTime = DateTime(widget.booked[i]['year'],
          widget.booked[i]['month'], widget.booked[i]['day']);
      final DateTime endTime = startTime.add(const Duration(hours: 12));
      meetings.add(Meeting('Busy', startTime, endTime, Colors.green, false));
    }
    return meetings;
  }

  calenderPressed(CalendarLongPressDetails pressed) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
      jsonEncode(<String, dynamic>{
        'year': pressed.date.year,
        'month': pressed.date.month,
        'day': pressed.date.day
      }),
      'carrier/calendar',
    );
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
  }
}

calendarTapped(context) {
  //
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
