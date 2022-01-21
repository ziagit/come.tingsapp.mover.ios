import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/screens/jobs/job_details.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("Notifications"),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: _get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return Center(child: Text("There are no notification yet!"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    margin: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      SizedBox(width: 50, child: Text("$index")),
                      Text("${snapshot.data[index]['type'].substring(18)}"),
                      Spacer(),
                      IconButton(
                        onPressed: () => _navigate(snapshot.data[index]),
                        icon: Icon(Icons.arrow_right),
                      )
                    ]),
                  );
                },
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
        ),
      ),
    );
  }

  _get() async {
    Api api = new Api();
    var response = await api.get('auth/notifications');
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    }
  }

  _navigate(data) {
    var jsonData = jsonDecode(data['data']);
    String type = data['type'].substring(18);
    if (type == 'JobCreated' || type == 'JobUpdated') {
      Navigator.push(
        context,
        SlideRightRoute(
          page: JobDetails(id: jsonData['job']['id']),
        ),
      );
    }
  }
}
