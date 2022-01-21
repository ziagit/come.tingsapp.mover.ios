class LocationModel {
  String latitude;
  String longitude;
  String accuracy;
  String heading;
  String altitude;
  String speed;
  String speedAccuracy;
  LocationModel(this.latitude, this.longitude, this.accuracy, this.heading,
      this.altitude, this.speed, this.speedAccuracy);
  LocationModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    accuracy = json['accuracy'];
    heading = json['heading'];
    altitude = json['altitude'];
    speed = json['speed'];
    speedAccuracy = json['speedAccuracy'];
  }
  Map<String, dynamic> toJson() => {
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        heading: heading,
        altitude: altitude,
        speed: speed,
        speedAccuracy: speedAccuracy
      };
}
