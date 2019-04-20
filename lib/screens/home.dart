import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import '../constants/urls.dart';
import '../constants/payloads.dart';
import '../components/dialog.dart';
import '../components/copy.dart';
import '../components/font.dart';
import '../screens/charts/reservation_totals.dart';
import '../screens/tiles/square.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static final now = DateTime.now();
  static final now7Ago = DateTime.now().subtract(Duration(days: 7));
  String today = '${now.month}/${now.day}/${now.year}';
  String rewardsToday = '${now.year}-${now.month}-${now.day}';
  String rewardsDay7Ago = '${now7Ago.year}-${now7Ago.month}-${now7Ago.day}';
  String day7Ago = '${now7Ago.month}/${now7Ago.day}/${now7Ago.year}';


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

    if (!mounted)
      return 'Defunct!';

    setState(() {
      if (reqType.contains('readResChart_')) {
        globals.reservations[reqType] = json.decode(response.body);
      }
      if (reqType.contains('readResTotal')) {
        globals.reservationsTotal = json.decode(response.body);
        globals.totalReservations = globals.reservationsTotal['total'];
      }
      if (reqType.contains('readResAll')) {
        globals.reservationsAll = json.decode(response.body);
        List data = globals.reservationsAll['data'];
        for (int i=0; i<globals.totalReservations; i++) {
          try {
            globals.totalRevenueUsd += double.parse(data[i]['dwh_revenue_usd']);
          } catch (e) {}
        }
      }
    });
    return 'Success!';
  }

  Future<String> cpReadHotelsRequest(String user, String pass) async {
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
          Uri.encodeFull(cpReadHotelsURL()),
          body: hotelPayload(),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    if (!mounted)
      return 'Defunct!';

    setState(() {
      globals.hotels = json.decode(response.body);
    });
    return 'Success!';
  }

  Future<String> cpReadVouchersRequest(String user, String pass, Map options) async {
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
          Uri.encodeFull(cpReadVouchersURL()),
          body: voucherPayload(
            options['startDate'],
            options['endDate'],
          ),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    if (!mounted)
      return 'Defunct!';

    setState(() {
      globals.vouchers = json.decode(response.body);
    });
    return 'Success!';
  }

  Future<String> cpReadRewardsSubsRequest(String user, String pass, Map options) async {
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
          Uri.encodeFull(cpQueryURL()),
          body: rewardsSubsPayload(
            options['startDate'],
            options['endDate'],
          ),
          headers: {
            'Accept': 'application/json',
            'Cookie': 'PHPSESSID=${getPHPSESSID(response)}',
          }
        )
      ).whenComplete(client.close);

    if (!mounted)
      return 'Defunct!';

    setState(() {
      globals.rewards = json.decode(response.body);
    });
    return 'Success!';
  }

  bool chartDataDownloaded() {
    return globals.reservations['readResChart_0'] != null &&
      globals.reservations['readResChart_1'] != null &&
      globals.reservations['readResChart_2'] != null &&
      globals.reservations['readResChart_3'] != null &&
      globals.reservations['readResChart_4'] != null &&
      globals.reservations['readResChart_5'] != null &&
      globals.reservations['readResChart_6'] != null;
  }


  @override
  void initState() {
    if (globals.reservations.isEmpty) {
      for (var i=0; i<7; i++) {
        var date = now.subtract(Duration(days: i));
        var dateStr = '${date.month}/${date.day}/${date.year}';
        this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResChart_$i', {
          'startDate': dateStr, 'endDate': dateStr, 'payScheme': '1,2,3,4,5', 'limit': 1,
        });
      }
    }
    if (globals.hotels.isEmpty) {
      this.cpReadHotelsRequest(globals.cpUser, globals.cpPass);
    }
    if (globals.vouchers.isEmpty) {
      this.cpReadVouchersRequest(globals.cpUser, globals.cpPass, {'startDate': today, 'endDate': day7Ago});
    }
    if (globals.rewards.isEmpty) {
      this.cpReadRewardsSubsRequest(globals.cpUser, globals.cpPass, {'startDate': rewardsToday, 'endDate': rewardsDay7Ago});
    }
    if (globals.reservationsTotal.isEmpty) {
      this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResTotal', {
        'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': 1,
      });
    }
    if (globals.reservationsAll.isEmpty) {
      this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResAll', {
        'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': globals.totalReservations,
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {
    return globals.reservations.isEmpty || !chartDataDownloaded()
      ? Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: Text('Fetching stats, please wait ...')),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            Center(child: LinearProgressIndicator(backgroundColor: Colors.orange,)),
          ],
        )
      : RefreshIndicator(
          onRefresh: () async {
            setState(() {
              globals.totalReservations = 0;
              globals.totalRevenueUsd = 0.0;

              this.cpReadHotelsRequest(globals.cpUser, globals.cpPass);
              this.cpReadVouchersRequest(globals.cpUser, globals.cpPass, {'startDate': today, 'endDate': day7Ago});
              this.cpReadRewardsSubsRequest(globals.cpUser, globals.cpPass, {'startDate': rewardsToday, 'endDate': rewardsDay7Ago});
              this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResTotal', {
                'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': 1,
              });

              this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResAll', {
                'startDate': today, 'endDate': today, 'payScheme': '1,2,3,4,5', 'limit': globals.totalReservations,
              });

              for (var i=0; i<7; i++) {
                var date = now.subtract(Duration(days: i));
                var dateStr = '${date.month}/${date.day}/${date.year}';
                this.cpReadRsvsnRequest(globals.cpUser, globals.cpPass, 'readResChart_$i', {
                  'startDate': dateStr, 'endDate': dateStr, 'payScheme': '1,2,3,4,5', 'limit': 1,
                });
              }
            });
          },
          child: WillPopScope(
            onWillPop: () {
              return dialog(
                ctx, 'roomReset', wrapCopy('Are you sure?', boldColorFont(14.0, Colors.blueGrey)),
                wrapCopy('The system will log you out, if you click Yes.\n\nDo you really want to go back?',
                  normalFont(10.0))
              );
            },
            child: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                ReservationTotalsChart(
                  label: 'DWH Revenue, Today',
                  data: '\$ ${globals.totalRevenueUsd.toStringAsFixed(2)}',
                  reservations: globals.reservations,
                ),
                SquareTile(
                  label: globals.reservationsTotal.isEmpty ? null : globals.reservationsTotal['total'].toString(),
                  description: 'Total Reservations\nToday',
                  icon: Icons.hotel,
                  iconColor: Colors.blue,
                ),
                SquareTile(
                  label: globals.hotels.isEmpty ? null : globals.hotels['total'].toString(),
                  description: 'Active Hotels\nToday',
                  icon: Icons.business_center,
                  iconColor: Colors.amber,
                ),
                SquareTile(
                  label: globals.vouchers.isEmpty ? null : globals.vouchers['total'].toString(),
                  description: 'Vouchers Purchased\nThe Past 7 Days',
                  icon: Icons.shopping_basket,
                  iconColor: Colors.lightGreen,
                  data: globals.vouchers,
                ),
                SquareTile(
                  label: globals.rewards.isEmpty ? null : globals.rewards['data'].length.toString(),
                  description: 'Rewards Subscriptions\nThe Past 7 Days',
                  icon: Icons.loyalty,
                  iconColor: Colors.pink,
                  data: globals.rewards,
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 280.0),
                StaggeredTile.extent(1, 192.0),
                StaggeredTile.extent(1, 192.0),
                StaggeredTile.extent(1, 192.0),
                StaggeredTile.extent(1, 192.0),
              ],
            )
          ),
        );
  }
}
