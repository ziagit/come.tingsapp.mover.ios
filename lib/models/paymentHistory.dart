class PaidHistory {
  int id;
  String from;
  String to;
  double amount;
  String createdAt;

  PaidHistory(this.id, this.from, this.to, this.amount, this.createdAt);
  PaidHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    amount = json['amount'];
    createdAt = json['created_at'];
  }
}
