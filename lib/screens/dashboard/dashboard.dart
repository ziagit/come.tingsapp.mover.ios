// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shipbay/screens/dashboard/job_status_chart.dart';
import 'package:shipbay/screens/dashboard/received_jobs_chart.dart';
import 'package:shipbay/screens/dashboard/revenue_chart.dart';
import 'package:shipbay/screens/notifications/notifications.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/menu.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/services/colors.dart';

class Dashboard extends StatefulWidget {
  final Widget child;

  Dashboard({Key key, this.child}) : super(key: key);

  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> list = [
    Tab(text: "Performance"),
    Tab(text: "Jobs"),
    Tab(text: "Revenue"),
  ];
  @override
  void initState() {
    _tabController = TabController(length: list.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildLogo(context),
        centerTitle: true,
        backgroundColor: Tingsapp.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () => Navigator.push(
                  context, SlideRightRoute(page: Notifications())),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: list,
        ),
      ),
      drawer: MovingMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: JobStatusChart(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ReceivedJobsChart(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: RevenueChart(),
          ),
        ],
      ),
    );
  }

  SizedBox _buildLogo(context) {
    return SizedBox(
        height: 30, width: 30, child: assetImage(context, "logo.png"));
  }
}
