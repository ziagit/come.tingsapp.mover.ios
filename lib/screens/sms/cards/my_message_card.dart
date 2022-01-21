import 'package:flutter/material.dart';
import 'package:shipbay/models/message.dart';
import 'package:shipbay/shared/services/colors.dart';

class MyMessageCard extends StatelessWidget {
  final Message message;
  const MyMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${_formatDate(message.createdAt)} ",
                      style: TextStyle(fontSize: 11, color: Tingsapp.fontColor),
                    ),
                    Icon(Icons.done_all, color: Colors.blue, size: 16),
                  ],
                ),
              ],
            ),
          ),
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
