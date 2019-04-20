String cpLoginURL() {
  return 'https://cp.directwithhotels.com/login/process_login';
}

String cpReadReservationsURL() {
  return 'https://cp.directwithhotels.com/ibo/readReservations';
}

String cpReservationLogsURL(String id) {
  return 'https://cp.directwithhotels.com/ibo/getAuditLogs/$id';
}

String cpReadHotelsURL() {
  return 'https://cp.directwithhotels.com/pm/readProperties';
}

String cpSearchReservationURL() {
  return 'https://cp.directwithhotels.com/ibo/readReservations';
}

String cpReadVouchersURL() {
  return 'https://cp.directwithhotels.com/voucher/getSales';
}

String cpQueryURL() {
  return 'https://cp.directwithhotels.com/dbquery/query';
}
