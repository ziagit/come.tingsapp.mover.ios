// ignore_for_file: unused_field, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/models/room.dart';
import 'package:shipbay/screens/sms/cards/room_card.dart';
import 'package:shipbay/screens/sms/messages.dart';
import 'package:shipbay/shared/components/slide_bottom_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Rooms extends StatefulWidget {
  final listener;
  const Rooms({Key key, this.listener}) : super(key: key);
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> with TickerProviderStateMixin {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> list = [
    Tab(text: "CHATS"),
    Tab(text: "CALLS"),
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
          elevation: 0,
          title: Text("Chatrooms"),
          centerTitle: true,
          actions: [_buildPopupMenu(context)],
          backgroundColor: Tingsapp.transparent,
          leading: Container(),
          bottom: TabBar(controller: _tabController, tabs: list),
        ),
        body: FutureBuilder(
          future: _createRoom(widget.listener),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: ChatWidget(),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text("CALLS"),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                child: Text("Error: ${snapshot.error}"),
                padding: EdgeInsets.only(top: 8),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Tingsapp.grey));
            }
          },
        ));
  }

  PopupMenuButton _buildPopupMenu(context) {
    return PopupMenuButton(
      key: _key,
      onSelected: (newValue) {
        _close(context);
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem(child: Text('Close'), value: 0),
          PopupMenuItem(child: Text('...'), value: 1),
        ];
      },
    );
  }

  _createRoom(listener) async {
    Api api = new Api();
    try {
      var response = await api.post(
          jsonEncode(<String, dynamic>{"listener": listener}), "chat/room");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      }
    } catch (err) {
      showSnackbar(context, '${err.toString()}');
    }
  }

  _close(context) {
    Navigator.pop(context);
  }
}

class ChatWidget extends StatelessWidget {
  List<Room> rooms = [];
  int _user;
  Store _store = new Store();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _get(context),
      builder: (context, snapshot) {
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return RoomCard(
                  room: snapshot.data[index],
                  user: _user,
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideBottomRoute(
                        page: Messages(room: snapshot.data[index], user: _user),
                      ),
                    );
                  },
                );
              });
        } else if (snapshot.hasError) {
          return Padding(
            child: Text("Error: ${snapshot.error}"),
            padding: EdgeInsets.only(top: 8),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(backgroundColor: Tingsapp.grey));
        }
      },
    );
  }

  Future _get(context) async {
    Api api = new Api();
    try {
      var response = await api.get("chat/rooms");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var roomList = (jsonData as List).map((e) => Room.fromJson(e)).toList();
        rooms = roomList;
        var mover = await _store.read('mover');
        _user = mover['user'];
        return rooms;
      }
    } catch (err) {
      showSnackbar(context, '${err.toString()}');
    }
  }
}
