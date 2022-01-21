class Earning {
  int id;
  String jobId;
  String createdAt;
  double price;
  String status;

  Earning(this.id, this.jobId, this.createdAt, this.price, this.status);
  Earning.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['order']['uniqid'];
    createdAt = json['order']['created_at'];
    price = json['carrier_earning'];
    status = json['status'];
  }
}
