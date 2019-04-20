import 'package:scoped_model/scoped_model.dart';

class Stats extends Model {
  Map<String, dynamic> _hotels = {};
  Map<String, dynamic> _reservation = {};
  Map<String, dynamic> _reservations = {};
  Map<String, dynamic> _pgwMethodInfo = {};
  Map<String, dynamic> _paymentTypeInfo = {};
  Map<String, dynamic> _countryInfo = {};
  Map<String, dynamic> _propertyInfo = {};
  Map<String, dynamic> _nightsInfo = {};
  Map<String, dynamic> _adultsChildrenInfo = {};

  Map<String, dynamic> get hotels => _hotels;
  Map<String, dynamic> get reservation => _reservation;
  Map<String, dynamic> get reservations => _reservations;
  Map<String, dynamic> get pgwMethodInfo => _pgwMethodInfo;
  Map<String, dynamic> get paymentTypeInfo => _paymentTypeInfo;
  Map<String, dynamic> get countryInfo => _countryInfo;
  Map<String, dynamic> get propertyInfo => _propertyInfo;
  Map<String, dynamic> get nightsInfo => _nightsInfo;
  Map<String, dynamic> get adultsChildrenInfo => _adultsChildrenInfo;

  void setHotels(Map<String, dynamic> map) {
    _hotels = map;
    notifyListeners();
  }
  void setReservation(Map<String, dynamic> map) {
    _reservation = map;
    notifyListeners();
  }
  void setReservations(Map<String, dynamic> map) {
    _reservations = map;
    notifyListeners();
  }
  void setPgwMethodInfo(Map<String, dynamic> map) {
    _pgwMethodInfo = map;
    notifyListeners();
  }
  void setPaymentTypeInfo(Map<String, dynamic> map) {
    _paymentTypeInfo = map;
    notifyListeners();
  }
  void setCountryInfo(Map<String, dynamic> map) {
    _countryInfo = map;
    notifyListeners();
  }
  void setPropertyInfo(Map<String, dynamic> map) {
    _propertyInfo = map;
    notifyListeners();
  }
  void setNightsInfo(Map<String, dynamic> map) {
    _nightsInfo = map;
    notifyListeners();
  }
  void setAdultsChildrenInfo(Map<String, dynamic> map) {
    _adultsChildrenInfo = map;
    notifyListeners();
  }
}
