class Bank {
  int id;
  String currency;
  String transitNumber;
  double institutionNumber;
  String accountNumber;

  Bank(this.id, this.currency, this.transitNumber, this.institutionNumber,
      this.accountNumber);
  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    transitNumber = json['transit_number'];
    institutionNumber = json['institution_number'];
    accountNumber = json['account_number'];
  }
}
