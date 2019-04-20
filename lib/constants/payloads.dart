Map resPayload(String dateFrom, String dateTo, String payScheme, int limit) {
  return {
    'sort': 'server_created_date',
    'dir': 'DESC',
    'filter[0][field]': 'server_created_date',
    'filter[0][data][type]': 'date',
    'filter[0][data][comparison]': 'le',
    'filter[0][data][value]': dateFrom,
    'filter[1][field]': 'server_created_date',
    'filter[1][data][type]': 'date',
    'filter[1][data][comparison]': 'ge',
    'filter[1][data][value]': dateTo,
    'filter[2][field]': 'status_id',
    'filter[2][data][parent_id]': '0',
    'filter[2][data][type]': 'list',
    'filter[2][data][value]': '2,12,22',
    'filter[3][field]': 'payment_scheme',
    'filter[3][data][type]': 'list',
    'filter[3][data][value]': payScheme,
    'start': '0',
    'limit': limit.toString(),
  };
}

Map hotelPayload() {
  return {
    'sort': 'status',
    'dir': 'ASC',
    'filter[0][field]': 'status',
    'filter[0][data][type]': 'list',
    'filter[0][data][value]': '2',
    'filter[1][field]': 'category_id',
    'filter[1][data][type]': 'list',
    'filter[1][data][value]': '1',
    'start': '0',
    'limit': '1',
    'view': 'rm',
  };
}

Map searchPayload(String confirmationNo) {
  return {
    'sort': 'server_created_date',
    'dir': 'DESC',
    'filter[0][field]': 'confirmation_no',
    'filter[0][data][type]': 'numeric',
    'filter[0][data][comparison]': 'eq',
    'filter[0][data][value]': confirmationNo,
    'start': '0',
    'limit': '1',
  };
}

Map searchLatestPayload() {
  return {
    'sort': 'server_created_date',
    'dir': 'DESC',
    'start': '0',
    'limit': '1',
  };
}

Map voucherPayload(String dateFrom, String dateTo) {
  return {
    'filter[0][field]': 'purchase_date',
    'filter[0][data][type]': 'date',
    'filter[0][data][comparison]': 'le',
    'filter[0][data][value]': dateFrom,
    'filter[1][field]': 'purchase_date',
    'filter[1][data][type]': 'date',
    'filter[1][data][comparison]': 'ge',
    'filter[1][data][value]': dateTo,
    'filter[2][field]': 'timezone',
    'filter[2][data][type]': 'string',
    'filter[2][data][value]': 'DWH Timezone',
    'start': '0',
  };
}

Map rewardsSubsPayload(String dateFrom, String dateTo) {
  return {
    'db': 'dwh_log',
    'query': "SELECT * FROM rewards_provider_logs WHERE response::JSONB->'result'->>'action' = 'signup' AND response::JSONB->'result'->>'success' = 'Y' AND request_ts BETWEEN '$dateTo' AND '$dateFrom'  ORDER BY request_ts DESC;",
  };
}
