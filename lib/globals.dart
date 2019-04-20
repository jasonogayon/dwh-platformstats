library platformstats.globals;

String cpUser = '';
String cpPass = '';
String reservationId;
bool loggedIn = false;
bool hasFinishedChart = false;
int totalReservations = 0;
double totalRevenueUsd = 0.0;
double totalAmountUsd = 0.0;
Map<String, dynamic> hotels = {};
Map<String, dynamic> vouchers = {};
Map<String, dynamic> rewards = {};
Map<String, dynamic> reservations = {};
Map<String, dynamic> reservationsTotal = {};
Map<String, dynamic> reservationsAll = {};
Map<String, dynamic> reservation = {};
Map<String, dynamic> reservationLog = {};
Map<String, dynamic> pgwMethodInfo = {};
Map<String, dynamic> paymentTypeInfo = {};
Map<String, dynamic> countryInfo = {};
Map<String, dynamic> propertyInfo = {};
Map<String, dynamic> nightsInfo = {};
Map<String, dynamic> adultsChildrenInfo = {};
Map<String, dynamic> withExtraBeds = {'total': 0, 'ids': [], 'info': []};
Map<String, dynamic> withAddOns = {'total': 0, 'ids': [], 'info': []};
Map<String, dynamic> arePrivate = {'total': 0, 'ids': [], 'info': []};
Map<String, dynamic> areOnHold = {'total': 0, 'ids': [], 'info': []};
Map<String, dynamic> areRateMixed = {'total': 0, 'ids': [], 'info': []};
Map<String, dynamic> areNoCreditCard = {'total': 0, 'ids': [], 'info': []};
