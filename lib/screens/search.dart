import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../globals.dart' as globals;
import '../constants/urls.dart';
import '../constants/payloads.dart';
import '../components/dialog.dart';
import '../components/copy.dart';
import '../components/font.dart';
import '../components/box.dart';
import '../components/cta.dart';
import '../utils/regex.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final searchKey = GlobalKey<FormState>();
  List<Widget> reservationContent = [];
  List<Widget> reservationLogContent = [];

  Future<String> cpSearchReservationRequest(String user, String pass) async {
    String getPHPSESSID(var response) {
      return response.headers.toString().split('PHPSESSID=')[1].split(';')[0];
    }

    var client = http.Client();
    var response = await client
      .post(
        Uri.encodeFull(cpLoginURL()),
        body: { 'user_name': user, 'user_pwd': pass, },
        headers: { 'Accept': 'application/json' }
      ).then((response) =>
        client.post(
          Uri.encodeFull(cpSearchReservationURL()),
          body: searchController.text.isEmpty ? searchLatestPayload() : searchPayload(searchController.text),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    if (!mounted)
      return 'Defunct!';

    setState(() {
      globals.reservation = json.decode(response.body);
      try {
        globals.reservationId = globals.reservation['data'][0]['id'].toString();
      } catch (e) {
        globals.reservationId = null.toString();
      }
    });
    return 'Success!';
  }

  Future<String> cpSearchReservationLogRequest(String user, String pass) async {
    String getPHPSESSID(var response) {
      return response.headers.toString().split('PHPSESSID=')[1].split(';')[0];
    }

    var client = http.Client();
    var response = await client
      .post(
        Uri.encodeFull(cpLoginURL()),
        body: { 'user_name': user, 'user_pwd': pass, },
        headers: { 'Accept': 'application/json' }
      ).then((response) =>
        client.get(
          Uri.encodeFull(cpReservationLogsURL(globals.reservationId)),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    if (!mounted)
      return 'Defunct!';

    setState(() {
      globals.reservationLog = json.decode(response.body);
    });
    return 'Success!';
  }

  GestureDetector generateCopy(String label, dynamic data) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: wrapCopy('$label', boldFont(10.0)),
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0),
              child: wrapCopy('$data', normalFont(10.0)),
            )
          ],
        ),
      ),
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: data.toString()));
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Copied: ${data.toString()}'))
        );
      }
    );
  }

  List<Widget> rsvsnContent(Map reservation, Map reservationLog) {
    if (reservation['data'] != null && globals.reservationId != null.toString()) {
      var data = reservation['data'][reservation['data'].length -1];
      var log = reservationLog['data'][reservationLog['data'].length -1];
      var currency = data['currency_code'];
      reservationContent = [
        generateCopy('Confirmation No:', data['confirmation_no']),
        generateCopy('Transaction Id:', data['transaction_id'] ?? 'N/A'),
        generateCopy('Server Created Date:', data['server_created_date'] ?? 'N/A'),
        generateCopy('Property:', data['property_name']),
        generateCopy('Timezone:', data['timezone_name']),
        generateCopy('Check-In Date:', data['check_in_date']),
        generateCopy('Check-Out Date:', data['check_out_date']),
        generateCopy('Exchange Rate:', data['gi_exchange_rate'] == null ? 'N/A' : '$currency ${data['gi_exchange_rate']}'),
        generateCopy('Source Channel:', data['source_channel']),
        Divider(),
        generateCopy('Guest Name:', data['guest_name'].toUpperCase()),
        generateCopy('Guest Email:', data['guest_email']),
        generateCopy('Guest Phone:', data['contact_no']),
        generateCopy('Guest Country:', data['country_name']),
        generateCopy('Adults / Children:', data['no_of_adults_children']),
        Divider(),
        generateCopy('Deposit:', '$currency ${priceFormat(double.parse(data['deposit_amount']))}'),
        generateCopy('Balance Payable:', '$currency ${priceFormat(double.parse(data['balance_amount']))}'),
        generateCopy('Payment Type:', data['payment_type'] ?? 'N/A'),
        generateCopy('Refund Policy:', data['refundable_flag'] == 0 ? 'Non-Refundable' : 'Refundable'),
        generateCopy('Status:', data['status_name']),
        Divider(),
        generateCopy('Total Room Charge:', '$currency ${priceFormat(double.parse(data['total_room_charges']))}'),
        generateCopy('Total Tax:', '$currency ${priceFormat(double.parse(data['total_tax']))}'),
        generateCopy('Total Fee:', '$currency ${priceFormat(double.parse(data['total_fee']))}'),
        generateCopy('Other Fees:', data['other_fees'] == null ? 'N/A' : '$currency ${priceFormat(double.parse(data['other_fees']))}'),
        generateCopy('Total Add-on Charge:', '$currency ${priceFormat(double.parse(data['total_add_on_rate']))}'),
        Divider(),
        generateCopy('Total Amount:', '$currency ${priceFormat(double.parse(data['total_amount']))}'),
        generateCopy('DWH Revenue:', '$currency ${priceFormat(double.parse(data['dwh_revenue']))}'),
        generateCopy('PCT Commission:', data['pct_commission'] == null ? 'N/A' : '${data['pct_commission']}%'),
        Divider(),
        generateCopy('Is Mixed?', data['is_mixed'] == 0 || data['is_mixed'] == null ? 'NO' : 'YES'),
        generateCopy('Is Private?', data['private_account_id'] == null ? 'NO' : 'YES (ID: ${data['private_account_id']})'),
        generateCopy('Is Mobile?', log['gi_version'].contains('desktop') ? 'NO' : 'YES'),
        Divider(),
        generateCopy('Room Name:', ''),
        padWrapCopy(log['reservation_details'][0]['room_name'], normalFont(10.0), EdgeInsets.only(bottom: 4.0)),
        generateCopy('No. of Rooms:', log['reservation_details'][0]['no_of_rooms']),
        generateCopy('Promo Name:', ''),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: wrapCopy(log['rate_plan_info'] == null ? 'N/A' : '${log['rate_plan_info']['rate_plan_name']}\n', normalFont(10.0)),
        ),
        generateCopy('Breakfast:', log['rate_plan_info'] == null ? 'N/A' : log['rate_plan_info']['breakfast_name']),
        generateCopy('Is Mobile Exclusive?', log['rate_plan_info'] == null ? 'N/A' : log['rate_plan_info']['mobile_exclusive_flag'] == 0 ? 'NO' : 'YES'),
        generateCopy('Has Children?', log['rate_plan_info'] == null ? 'N/A' : log['rate_plan_info']['parent_rate_plan_id'] == null ? 'NO' : 'YES'),
        Divider(),
        wrapCopy('Applied Policies:\n', boldFont(12.0)),
        wrapCopy('${log['applied_policy']['modify_desc']}\n', normalFont(10.0)),
        wrapCopy('${log['applied_policy']['late_desc']}\n', normalFont(10.0)),
        wrapCopy('${log['applied_policy']['no_show_desc']}\n', normalFont(10.0)),
        Divider(),
        wrapCopy('Hotel Extranet Policies:\n', boldFont(12.0)),
        wrapCopy('${log['HEPolicyCopies']['modify_desc']}\n', normalFont(10.0)),
        wrapCopy('${log['HEPolicyCopies']['late_desc']}\n', normalFont(10.0)),
        wrapCopy('${log['HEPolicyCopies']['no_show_desc']}\n', normalFont(10.0)),
        Divider(),
        wrapCopy('Booking Engine Policies:\n', boldFont(12.0)),
        wrapCopy('${log['IBEPolicyCopies']['modification']}\n', normalFont(10.0)),
        wrapCopy('${log['IBEPolicyCopies']['cancellation']}\n', normalFont(10.0)),
        wrapCopy('${log['IBEPolicyCopies']['noshow']}\n', normalFont(10.0)),
        wrapCopy('${log['IBEPolicyCopies']['prepayment']}\n', normalFont(10.0)),
        wrapCopy('${log['IBEPolicyCopies']['child']}\n', normalFont(10.0)),
        Divider(),
      ];
    } else {
      reservationContent = [
        wrapCopy('Sorry, but it seems that what you are looking for does not exist in our database.', boldColorFont(16.0, Colors.blueGrey)),
      ];
    }

    return reservationContent;
  }

  @override
  void initState() {
    if (globals.reservation.isEmpty) {
      cpSearchReservationRequest(globals.cpUser, globals.cpPass)
        .then((str) {
          if (globals.reservationId != null.toString()) {
            cpSearchReservationLogRequest(globals.cpUser, globals.cpPass);
          }
        });
    }

    super.initState();
  }


  @override
  Widget build(BuildContext ctx) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          cpSearchReservationRequest(globals.cpUser, globals.cpPass)
            .then((str) {
              if (globals.reservationId != null.toString()) {
                cpSearchReservationLogRequest(globals.cpUser, globals.cpPass);
              }
            });
        });
      },
      child: WillPopScope(
        onWillPop: () {
          return dialog(
            ctx, 'roomReset', wrapCopy('Are you sure?', boldColorFont(16.0, Colors.blueGrey)),
            wrapCopy('The system will log you out, if you click Yes.\n\nDo you really want to go back?',
              normalFont(12.0))
          );
        },
        child: Form(
          key: searchKey,
          child: Stack(
            children: <Widget>[
              globals.reservationLog.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Text('Fetching latest reservation ...')),
                    Padding(padding: EdgeInsets.only(top: 8.0)),
                    Center(child: LinearProgressIndicator(backgroundColor: Colors.orange,)),
                  ],
                )
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 80.0, left: 40.0, right: 40.0),
                  child: ListView(
                    children: <Widget>[
                      Divider(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: rsvsnContent(globals.reservation, globals.reservationLog),
                        )
                      ),
                    ],
                  ),
                ),
              Container(
                color: Colors.orange[300],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        width: 152.0,
                        decoration: boxNoColor(Colors.grey, 1.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 10.0, color: Colors.black),
                          controller: searchController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            labelText: 'Confirmation Number',
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        ),
                      ),
                    ),
                    CallToAction(
                      copy: 'Search',
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      onPressedAction: (){
                        var form = searchKey.currentState;
                        form.save();
                        FocusScope.of(context).requestFocus(FocusNode());
                        cpSearchReservationRequest(globals.cpUser, globals.cpPass)
                          .then((str) {
                            if (globals.reservationId != null.toString()) {
                              cpSearchReservationLogRequest(globals.cpUser, globals.cpPass);
                            }
                          });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
