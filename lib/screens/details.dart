import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import '../constants/urls.dart';
import '../constants/payloads.dart';
import '../screens/charts/reservation_groups.dart';
import '../screens/tiles/square.dart';
import '../components/dialog.dart';
import '../components/copy.dart';
import '../components/font.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  static final now = DateTime.now();
  var today = '${now.month}/${now.day}/${now.year}';


  Future<String> cpReadRsvsnRequest(String user, String pass, String reqType, Map options) async {
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
          Uri.encodeFull(cpReadReservationsURL()),
          body: resPayload(
            options['startDate'],
            options['endDate'],
            options['payScheme'],
            options['limit']
          ),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    void generateTileData(Map dataTo, Map dataFr) {
      dataTo['total']++;
      dataTo['ids'].add(dataFr['confirmation_no']);
      dataTo['info'].add(dataFr);
    }

    void generateRsvsnGroupData(Map dataTo, String key) {
      dataTo[key] == null ? dataTo[key] = 0 : dataTo[key]++;
    }

    bool hasExtraBed(Map data) {
      return data['extra_bed_details'] != null && data['extra_bed_details'] != '[]';
    }

    bool hasAddon(Map data) {
      return data['add_on_details'] != null && data['add_on_details'] != 'null' && data['add_on_details'] != '[]';
    }

    bool isNoCC(Map data) {
      return data['ccard_no'] == '' && data['ccard_name'] == null && data['expiry'] == null;
    }

    bool isOnHold(Map data) {
      return data['status_id'] == 22;
    }

    bool isNotNull(data) {
      return data != null;
    }

    if (!mounted)
      return 'Defunct!';

    setState(() {
      if (reqType.contains('readResTotal')) {
        globals.reservationsTotal = json.decode(response.body);
        globals.totalReservations = globals.reservationsTotal['total'];
      }
      if (reqType.contains('readResAll')) {
        globals.reservationsAll = json.decode(response.body);
        List data = globals.reservationsAll['data'];
        for (int i=0; i<globals.totalReservations; i++) {
          try {
            globals.totalAmountUsd += double.parse(data[i]['total_amount_usd']);
            generateRsvsnGroupData(globals.pgwMethodInfo, data[i]['pgw_method']);
            generateRsvsnGroupData(globals.paymentTypeInfo, data[i]['payment_type']);
            generateRsvsnGroupData(globals.countryInfo, data[i]['country_name']);
            generateRsvsnGroupData(globals.propertyInfo, data[i]['property_name']);
            generateRsvsnGroupData(globals.nightsInfo, data[i]['no_of_nights'].toString());
            generateRsvsnGroupData(globals.adultsChildrenInfo, data[i]['no_of_adults_children']);
            hasExtraBed(data[i]) ? generateTileData(globals.withExtraBeds, data[i]) : globals.withExtraBeds;
            hasAddon(data[i]) ? generateTileData(globals.withAddOns, data[i]) : globals.withAddOns;
            isNoCC(data[i]) ? generateTileData(globals.areNoCreditCard, data[i]) : globals.areNoCreditCard;
            isNotNull(data[i]['private_account_id']) ? generateTileData(globals.arePrivate, data[i]) : globals.arePrivate;
            isOnHold(data[i]) ? generateTileData(globals.areOnHold, data[i]) : globals.areOnHold;
            isNotNull(data[i]['mixed_info']) ? generateTileData(globals.areRateMixed, data[i]) : globals.areRateMixed;
          } catch (e) {}
        }
      }
    });
    return 'Success!';
  }


  @override
  void initState() {
    if (globals.reservationsTotal.isEmpty) {
      this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResTotal', {
        'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': 1,
      });
    }
    if (globals.pgwMethodInfo.isEmpty) {
      this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResAll', {
        'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': globals.totalReservations,
      });
    }

    super.initState();
  }


  @override
  Widget build(BuildContext ctx) {
    bool isNull(dynamic data) {
      return data == null;
    }

    dynamic getTotal(Map data) {
      return isNull(globals.reservationsAll) ? null : data['total'].toString();
    }

    String getTileCopy(Map data, String prefix) {
      return '$prefix\n' + (data['ids'].length == 0 ? ''
        : 'Latest CN: ' + data['ids'][data['ids'].length -1].toString());
    }

    dynamic getDialogData(Map data) {
      var dialogData;
      try {
        dialogData = data['ids'].isEmpty ? null : data['info'][data['ids'].length -1];
      } catch (e) {
        dialogData = null;
      }
      return dialogData;
    }


    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          globals.totalReservations = 0;
          globals.totalAmountUsd = 0.0;
          globals.pgwMethodInfo = {};
          globals.paymentTypeInfo = {};
          globals.countryInfo = {};
          globals.propertyInfo = {};
          globals.nightsInfo = {};
          globals.withExtraBeds = {'total': 0, 'ids': [], 'info': []};
          globals.withAddOns = {'total': 0, 'ids': [], 'info': []};
          globals.arePrivate = {'total': 0, 'ids': [], 'info': []};
          globals.areOnHold = {'total': 0, 'ids': [], 'info': []};
          globals.areRateMixed = {'total': 0, 'ids': [], 'info': []};
          globals.areNoCreditCard = {'total': 0, 'ids': [], 'info': []};

          this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResTotal', {
            'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': 1,
          });

          this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResAll', {
            'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': globals.totalReservations,
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
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            ReservationGroupsChart(
              label: 'Total Amount, Today',
              data: globals.reservationsAll.isEmpty ? null : '\$ ${globals.totalAmountUsd.toStringAsFixed(2)}',
              reservations: globals.reservations,
              pgwMethodInfo: globals.pgwMethodInfo,
              paymentTypeInfo: globals.paymentTypeInfo,
              countryInfo: globals.countryInfo,
              propertyInfo : globals.propertyInfo,
              nightsInfo : globals.nightsInfo,
              adultsChildrenInfo : globals.adultsChildrenInfo,
            ),
            SquareTile(
              label: globals.withExtraBeds.isEmpty ? null : getTotal(globals.withExtraBeds),
              description: getTileCopy(globals.withExtraBeds, 'Bookings With Extra Beds'),
              icon: Icons.local_hotel,
              iconColor: Colors.purple,
              data: getDialogData(globals.withExtraBeds),
            ),
            SquareTile(
              label: globals.withAddOns.isEmpty ? null : getTotal(globals.withAddOns),
              description: getTileCopy(globals.withAddOns, 'Bookings With Add-Ons'),
              icon: Icons.airport_shuttle,
              iconColor: Colors.lime,
              data: getDialogData(globals.withAddOns),
            ),
            SquareTile(
              label: globals.areRateMixed.isEmpty ? null : getTotal(globals.areRateMixed),
              description: getTileCopy(globals.areRateMixed, 'Rate-Mixed Bookings'),
              icon: Icons.merge_type,
              iconColor: Colors.orange,
              data: getDialogData(globals.areRateMixed),
            ),
            SquareTile(
              label: globals.areNoCreditCard.isEmpty ? null : getTotal(globals.areNoCreditCard),
              description: getTileCopy(globals.areNoCreditCard, 'No-Credit-Card Bookings'),
              icon: Icons.card_giftcard,
              iconColor: Colors.blueGrey,
              data: getDialogData(globals.areNoCreditCard),
            ),
            SquareTile(
              label: globals.arePrivate.isEmpty ? null : getTotal(globals.arePrivate),
              description: getTileCopy(globals.arePrivate, 'Private Bookings'),
              icon: Icons.business,
              iconColor: Colors.cyan,
              data: getDialogData(globals.arePrivate),
            ),
            SquareTile(
              label: globals.areOnHold.isEmpty ? null : getTotal(globals.areOnHold),
              description: getTileCopy(globals.areOnHold, 'On-Hold Bookings'),
              icon: Icons.stop,
              iconColor: Colors.brown,
              data: getDialogData(globals.areOnHold),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 280.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
            StaggeredTile.extent(1, 192.0),
          ],
        ),
      ),
    );
  }
}
