import 'package:flutter/material.dart';
import 'package:shipbay/models/room.dart';
import 'package:shipbay/shared/functions/date_formatter.dart';
import 'package:shipbay/shared/services/colors.dart';

class RoomCard extends StatelessWidget {
  final Function onTap;
  final Room room;
  final int user;
  const RoomCard({
    this.room,
    this.user,
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lastSms = "Hi, this is a last message your partner sent to you";
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage("assets/images/user_avatar.png"),
        backgroundColor: Colors.white,
      ),
      title: Text("${user == room.creator ? room.userName : room.name}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Icon(Icons.done_all, size: 16),
          SizedBox(width: 3),
          Text(lastSms.length > 15 ? '${lastSms.substring(0, 15)}...' : lastSms,
              style: TextStyle(color: Tingsapp.fontColor))
        ],
      ),
      trailing: Text("${roomDate(room.createdAt)}"),
    );
  }
}
