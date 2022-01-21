class Mover {
  int id;
  String first_name;
  String last_name;
  String phone;
  int employees;
  int vehicles;
  int rate;
  int year_established;
  double votes;
  String company;
  String detail;
  String website;
  String license;
  String insurance;

  Mover(
      this.id,
      this.first_name,
      this.last_name,
      this.phone,
      this.rate,
      this.company,
      this.detail,
      this.website,
      this.license,
      this.insurance,
      this.votes,
      this.employees,
      this.vehicles,
      this.year_established);

  Mover.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
    rate = json['hourly_rate'];
    company = json['company'];
    detail = json['detail'];
    votes = json['votes'];
    website = json['website'];
    license = json['business_license'];
    insurance = json['insurance_papers'];
    year_established = json['year_established'];
    employees = json['employees'];
    vehicles = json['vehicles'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'phone': phone,
        'rate': rate,
        'company': company,
        'detail': detail,
        'employees': employees,
        'website': website,
        'license': license,
        'insurance':insurance,
        'votes':votes,
        'vehicles':vehicles,
        'year_established': year_established,
      };
}
