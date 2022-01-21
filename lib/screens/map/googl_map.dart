import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shipbay/screens/map/search.dart';
import 'package:shipbay/screens/notifications/notifications.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/styles.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'package:shipbay/shared/services/store.dart';

class GooglMap extends StatefulWidget {
  final trackingNumber;
  const GooglMap({Key key, this.trackingNumber}) : super(key: key);

  @override
  _GooglMapState createState() => _GooglMapState();
}

class _GooglMapState extends State<GooglMap> {
  Store _store = new Store();
  //polyline point
  double _originLatitude, _originLongitude;
  double _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> moverPolylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  //realtime db
  final db = FirebaseDatabase.instance;

  //search togal for popup
  bool _isSearchProcessing = false;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _mapController;
  int _user;
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: _isSearchProcessing
            ? Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey),
              )
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(49.283424963212354, -123.10426927282323),
                      zoom: 15.4746,
                    ),
                    myLocationEnabled: false,
                    tiltGesturesEnabled: true,
                    compassEnabled: false,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                    circles: Set.of((circle != null) ? [circle] : []),
                    onMapCreated: _onMapCreated,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: iconStyle(context),
                            child: Icon(Icons.menu),
                          ),
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: logoStyle(context),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: assetImage(context, 'logo.png'),
                            ),
                          ),
                          onTap: () {
                            //
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: iconStyle(context),
                            child: Icon(Icons.notifications),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                SlideRightRoute(page: Notifications()));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching, color: Colors.white),
          onPressed: () {
            _searchDialog(context);
          }),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  _init() async {
    var mover = await _store.read('mover');
    _user = mover['user'];
    if (widget.trackingNumber != null) {
      _searchDialog(context);
    }
  }

  _searchDialog(context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            return Search(query: widget.trackingNumber);
          },
        ),
      ),
    ).then(
      (value) {
        if (value != null) {
          getCurrentLocation();
          _initMarkers(value['address']);
        }
      },
    );
  }

  void getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();
      _updateMarker(location, 'mover');
      updateFirebase(location);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_mapController != null) {
          _mapController
              .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                  // bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 15.00)));
          _updateMarker(newLocalData, 'mover');
          updateFirebase(newLocalData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showSnackbar(context, "Permission Denied");
      }
    }
  }

//initialized marker and polylines
  _initMarkers(data) {
    _originLatitude = double.parse(data[0]['latitude']);
    _originLongitude = double.parse(data[0]['longitude']);
    _destLatitude = double.parse(data[1]['latitude']);
    _destLongitude = double.parse(data[1]['longitude']);

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "Pickup",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "Destination",
        BitmapDescriptor.defaultMarkerWithHue(118));

    _getPolyline(data[0]['formatted_address']);
  }

//add pickup and destination markers
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(
        title: "$id",
      ),
    );
    markers[markerId] = marker;
  }

//get cordinates
  _getPolyline(pickupAddress) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
      //wayPoints: [PolylineWayPoint(location: "$pickupAddress")],
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

//polyling functions
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    //geodesic = false;
    setState(() {});
  }

  void _updateMarker(LocationData newLocalData, String id) async {
    Uint8List imageData = await getMarker();
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    //LatLng latlng = LatLng(49.28657556321865, -123.1178808188516);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      position: latlng,
      zIndex: 2,
      icon: BitmapDescriptor.fromBytes(imageData),
      infoWindow: InfoWindow(
        title: "Mover location",
      ),
    );
    this.setState(() {
      markers[markerId] = marker;
      circle = Circle(
        circleId: CircleId("circle"),
        radius: 5,
        zIndex: 1,
        center: latlng,
        strokeColor: Colors.orange.withAlpha(60),
        fillColor: Colors.orange.withAlpha(200),
      );
    });
    _getMoverPolyline(newLocalData);
  }

//make custom marker from asset image
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/location_map_marker.png");
    return byteData.buffer.asUint8List();
  }

//get cordinates
  _getMoverPolyline(LocationData localData) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(_originLatitude, _originLongitude),
      //PointLatLng(49.28657556321865, -123.1178808188516),
      PointLatLng(localData.latitude, localData.longitude),
      travelMode: TravelMode.driving,
      wayPoints: [
        PolylineWayPoint(
            location: '${localData.latitude}, ${localData.longitude}')
      ],
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        moverPolylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addMoverPolyLine();
  }

//polyling functions
  _addMoverPolyLine() {
    PolylineId id = PolylineId("moverPoly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: moverPolylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  updateFirebase(LocationData location) {
    try {
      db.ref(_user.toString()).set(
        {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
