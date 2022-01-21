import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/models/message.dart';
import 'package:shipbay/models/room.dart';
import 'package:shipbay/screens/sms/cards/friend_message_card.dart';
import 'package:shipbay/screens/sms/cards/my_message_card.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
//import 'package:pusher_client/pusher_client.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Messages extends StatefulWidget {
  final Room room;
  final int user;
  const Messages({Key key, this.room, this.user}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController _messageController = TextEditingController();
  //PusherClient pusher;
  //Channel channel;
  List<Message> messages = [];

  @override
  void initState() {
    _initPusher();
    super.initState();
  }

  @override
  void dispose() {
    //channel.unbind('chat-event');
    //pusher.unsubscribe('chat.' + widget.room.id.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.user == widget.room.creator ? widget.room.userName : widget.room.name}"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Tingsapp.lightOrange,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _call(context);
              },
              child: Icon(Icons.call),
            ),
          ),
        ],
      ),
      body: Container(
        color: Tingsapp.lightOrange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: _get(),
              builder: (context, snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _buildMyMessage(messages[index]) != null
                                ? MyMessageCard(
                                    message: _buildMyMessage(messages[index]))
                                : Container(),
                            _buildFriendMessage(messages[index]) != null
                                ? FriendMessageCard(
                                    message:
                                        _buildFriendMessage(messages[index]))
                                : Container(),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    child: Text("Error: ${snapshot.error}"),
                    padding: EdgeInsets.only(top: 8),
                  );
                } else {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        backgroundColor: Tingsapp.grey),
                  ));
                }
              },
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 3),
                          child: TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Message'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: Card(
                      color: Tingsapp.primary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: InkWell(
                          onTap: () => _send(context),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _send(context) async {
    Api api = new Api();
    try {
      var response = await api.post(
        jsonEncode(
          <String, dynamic>{
            'message': _messageController.text,
          },
        ),
        "chat/room/" + "${widget.room.id}" + "/message",
      );
      if (response.statusCode == 200) {
        _messageController.text = "";
        _get();
      }
    } catch (err) {
      showSnackbar(context, '${err.toString()}');
    }
  }

  Future _get() async {
    Api api = new Api();
    try {
      var response =
          await api.get("chat/room/" + "${widget.room.id}" + "/messages");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var messageList =
            (jsonData as List).map((e) => Message.fromJson(e)).toList();
        messages = messageList;
        return messages;
      }
      return [];
    } catch (err) {
      showSnackbar(context, '${err.toString()}');
    }
  }

  _buildFriendMessage(message) {
    return message.userId != widget.user ? message : null;
  }

  _buildMyMessage(message) {
    return message.userId == widget.user ? message : null;
  }

  Future<void> _initPusher() async {
    Store store = new Store();
    String token = await store.read('token');
    try {
    //
    } catch (e) {
      print(e.toString());
    }
  }

  _call(context) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(widget.room.userPhone);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
