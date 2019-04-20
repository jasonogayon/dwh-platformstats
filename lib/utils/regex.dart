String priceFormat(double price) {
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  return price.toStringAsFixed(2).replaceAllMapped(reg, mathFunc).replaceAll(',', ', ');
}

bool letterMatch(String copy) {
  RegExp reg = RegExp(r'(^[a-zA-Z]+$)');
  return reg.hasMatch(copy);
}

bool isEmail(String email) {
  RegExp reg = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return reg.hasMatch(email.toLowerCase());
}

bool isCreditCard(String cardNumber) {
  RegExp reg = RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');
  var test = reg.hasMatch(cardNumber);
  print(test);
  return test;
}