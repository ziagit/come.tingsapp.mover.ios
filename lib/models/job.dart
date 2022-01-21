class Job {
  int id;
  String jobId;
  String pickupDate;
  String appointmentTime;
  String type;
  double price;
  String status;

  Job(
      {this.id,
      this.jobId,
      this.pickupDate,
      this.appointmentTime,
      this.type,
      this.price,
      this.status});

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['order_detail']['id'],
        jobId: json['order_detail']['uniqid'],
        pickupDate: json['order_detail']['pickup_date'],
        appointmentTime: json['order_detail']['appointment_time'],
        type: json['order_detail']['movingtype']['title'],
        price: json['order_detail']['cost'],
        status: json['order_detail']['status'],
      );
}
