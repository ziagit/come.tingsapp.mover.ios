// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shipbay/screens/earnings/Paid.dart';
import 'package:shipbay/screens/earnings/Unpaid.dart';
import 'package:shipbay/shared/services/colors.dart';

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> with TickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> list = [
    Tab(text: "Unpaid"),
    Tab(text: "Paid"),
  ];

  @override
  void initState() {
    // Create TabController for getting the index of current tab
    _tabController = TabController(length: list.length, vsync: this);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings"),
        centerTitle: true,
        backgroundColor: Tingsapp.transparent,
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: list),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Unpaid(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Paid(),
          ),
        ],
      ),
    );
  }
}
