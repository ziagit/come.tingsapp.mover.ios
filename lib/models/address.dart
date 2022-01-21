class Address {
  int id;
  String country;
  String state;
  String city;
  String zip;
  String street;
  String street_number;
  String formatted_address;
  Address(this.id, this.country, this.state, this.city, this.zip, this.street,
      this.street_number, this.formatted_address);
  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street_number = json['street_number'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    formatted_address = json['formatted_address'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country,
        'state': state,
        'city': city,
        'zip': zip,
        'street': street,
        'street_number': street_number,
        'formatted_address': formatted_address,
      };
}
