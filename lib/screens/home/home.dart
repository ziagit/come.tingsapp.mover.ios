import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/menu.dart';
import 'package:shipbay/screens/calendar/calendar.dart';
import 'package:shipbay/screens/dashboard/dashboard.dart';
import 'package:shipbay/screens/jobs/jobs.dart';
import 'package:shipbay/screens/map/googl_map.dart';

class Home extends StatefulWidget {
  final trackingNumber;
  const Home({Key key, this.trackingNumber}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //bottom nav
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _initPages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initPages() {
    _children = [
      GooglMap(trackingNumber: widget.trackingNumber),
      Dashboard(),
      Jobs(),
      Calendar()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MovingMenu(),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false, // <-- HERE
          showUnselectedLabels: false, // <-- AND HERE
          currentIndex: _currentIndex,
          type: BottomNavigationBarType
              .fixed, // this will be set when a new tab is tapped
          onTap: (index) {
            _navigate(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: '',
            )
          ],
        ),
        body: _children[_currentIndex]);
  }

  _navigate(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
