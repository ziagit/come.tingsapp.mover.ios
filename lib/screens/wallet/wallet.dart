// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shipbay/screens/wallet/history.dart';
import 'package:shipbay/screens/wallet/method.dart';
import 'package:shipbay/shared/services/colors.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> list = [
    Tab(text: "Payment method"),
    Tab(text: "Payment history"),
  ];

  @override
  void initState() {
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
        centerTitle: true,
        backgroundColor: Tingsapp.transparent,
        elevation: 0,
        title: Text("Wallet"),
        bottom: TabBar(controller: _tabController, tabs: list),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: PaymentMethod(),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: PaymentHistory(),
          ),
        ],
      ),
    );
  }
}
