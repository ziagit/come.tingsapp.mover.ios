import 'package:flutter/material.dart';
import 'package:shipbay/models/message.dart';
import 'package:shipbay/shared/services/colors.dart';

class FriendMessageCard extends StatelessWidget {
  final Message message;
  const FriendMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    "${message.message}",
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.done_all, color: Colors.blue, size: 16),
                    Text(
                      _formatDate(message.createdAt),
                      style: TextStyle(fontSize: 11, color: Tingsapp.fontColor),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _formatDate(date) {
    return DateTime.parse(date).hour.toString() +
        ":" +
        DateTime.parse(date).minute.toString();
  }
}
