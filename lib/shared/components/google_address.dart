import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shipbay/shared/components/placePredictions.dart';
import 'package:shipbay/shared/components/divider.dart';
import 'package:shipbay/shared/components/prediction_tile.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:uuid/uuid.dart';

class GoogleAddress extends StatefulWidget {
  final selectedAddress;
  final keyword;
  GoogleAddress({Key key, this.selectedAddress, this.keyword})
      : super(key: key);
  @override
  _GoogleAddressState createState() => _GoogleAddressState();
}

class _GoogleAddressState extends State<GoogleAddress> {
  TextEditingController _addressController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];
  String sToken;
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autofocus: true,
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Postal code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onChanged: (val) {
            final sessionToken = uuid.v4();
            findPlace(val, sessionToken);
          },
        ),
        (placePredictionList.length > 0)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionList[index],
                      callback: (val) {
                        widget.selectedAddress(val, sToken);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      DividerWidget(),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CircularProgressIndicator(backgroundColor: Tingsapp.grey),
                ),
              ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.keyword);
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  void findPlace(String placeName, String sessionToken) async {
    Api api = new Api();
    if (placeName.length > 1) {
      var res = await api.googleFindPlace(placeName, sessionToken);
      Map data = jsonDecode(res.body);
      var predictions = data['predictions'];
      var placesList = (predictions as List)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      sToken = sessionToken;
      placePredictionList = placesList;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
