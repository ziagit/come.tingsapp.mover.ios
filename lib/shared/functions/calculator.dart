double totalPayments(list) {
  double balance = 0;
  for (int i = 0; i < list.length; i++) {
    balance = balance + list[i].price;
  }
  return balance;
}
