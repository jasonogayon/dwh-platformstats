import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../components/tile.dart';
import '../../components/copy.dart';
import '../../components/font.dart';

class RsvsnData {
  final String payScheme;
  final int rsvsns;
  final charts.Color color;

  RsvsnData(this.payScheme, this.rsvsns, Color color)
    : this.color = charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class ReservationGroupsChart extends StatefulWidget {
  final String label;
  final dynamic data;
  final Map reservations;
  final Map pgwMethodInfo;
  final Map paymentTypeInfo;
  final Map countryInfo;
  final Map propertyInfo;
  final Map nightsInfo;
  final Map adultsChildrenInfo;

  ReservationGroupsChart({
    Key key, this.label, this.data, this.reservations, this.pgwMethodInfo, this.paymentTypeInfo
    , this.countryInfo, this.propertyInfo, this.nightsInfo, this.adultsChildrenInfo
  }) : super(key: key);

  @override
  _ReservationGroupsChartState createState() => _ReservationGroupsChartState();
}


class _ReservationGroupsChartState extends State<ReservationGroupsChart> {
  List<RsvsnData> data1 = [];
  List<RsvsnData> data2 = [];
  List<RsvsnData> data3 = [];
  List<RsvsnData> data4 = [];
  List<RsvsnData> data5 = [];
  List<RsvsnData> data6 = [];
  List colors = [
    Colors.amber, Colors.amberAccent, Colors.black, Colors.blue, Colors.blueAccent, Colors.blueGrey,
    Colors.brown, Colors.cyan, Colors.cyanAccent, Colors.deepOrange, Colors.deepOrangeAccent,
    Colors.deepPurple, Colors.deepPurpleAccent, Colors.green, Colors.greenAccent, Colors.grey,
    Colors.indigo, Colors.indigoAccent, Colors.lightBlue, Colors.lightBlueAccent, Colors.lightGreen,
    Colors.lightGreenAccent, Colors.lime, Colors.limeAccent, Colors.orange, Colors.orangeAccent,
    Colors.pink, Colors.pinkAccent, Colors.red, Colors.redAccent, Colors.teal, Colors.tealAccent,
    Colors.yellow, Colors.yellowAccent
  ];

  static final List<String> chartDropdownItems = [
    'per Payment Method',
    'per Prepayment',
    'Top 5 Countries (Bookings)',
    'Top 5 Properties (Bookings)',
    'Top 5 Nights',
    'Top 5 Adults/Children',
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;


  LinkedHashMap sortData(Map data) {
    var sortedKeys = data.keys.toList(growable:false)..sort((k1, k2) => data[k2].compareTo(data[k1]));
    return LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => data[k]);
  }

  void generateData(Map data, List<RsvsnData> list, int position) {
    for(String k in data.keys) {
      var label = '';
      if (position == 1) {
        label = k == null ? 'HPP' :
          k.contains('Banco de Oro') ? 'BDO' : k.contains('AsiaPayMetro') ? 'AsiaPay\nMetro' : k;
      } else if (position == 2) {
        label = k.contains('200') ? 'Pay\nUpon\nArrival' : k.contains('201') ? 'Pay\nUpon\nBooking' : '$k%';
      } else if (position == 4) {
        label = k.replaceAll('  ', ' ').replaceAll(' ', '\n');
      } else if (position == 5) {
        label = '$k nights';
      } else if (position == 6) {
        label = k.replaceAll('/', '\n');
      } else {
        label = k;
      }
      if (position > 2) {
        if (list.length < 5) {
          list.add(RsvsnData(label, data[k], colors[Random().nextInt(colors.length)]));
        } else {
          break;
        }
      } else {
        list.add(RsvsnData(label, data[k], colors[Random().nextInt(colors.length)]));
      }
    }
  }

  getSeries(int actualChart) {
    return [
      charts.Series(
        domainFn: (RsvsnData rsvsnData, _) => rsvsnData.payScheme,
        measureFn: (RsvsnData rsvsnData, _) => rsvsnData.rsvsns,
        colorFn: (RsvsnData rsvsnData, _) => rsvsnData.color,
        id: 'ReservationGroups',
        data:
          actualChart == 0 ? data1
            : actualChart == 1 ? data2
                : actualChart == 2 ? data3
                    : actualChart == 3 ? data4
                        : actualChart == 4 ? data5 : data6,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    bool inProgress = widget.pgwMethodInfo.isEmpty || widget.paymentTypeInfo.isEmpty ||
      widget.countryInfo.isEmpty || widget.propertyInfo.isEmpty ||
      widget.nightsInfo.isEmpty || widget.adultsChildrenInfo.isEmpty;

    generateData(sortData(widget.pgwMethodInfo), data1, 1);
    generateData(sortData(widget.paymentTypeInfo), data2, 2);
    generateData(sortData(widget.countryInfo), data3, 3);
    generateData(sortData(widget.propertyInfo), data4, 4);
    generateData(sortData(widget.nightsInfo), data5, 5);
    generateData(sortData(widget.adultsChildrenInfo), data6, 6);

    return buildTile(
      Padding(
        padding: EdgeInsets.all(20.0),
        child: inProgress
        ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        wrapCopy(widget.label, boldColorFont(10.0, Colors.green)),
                        widget.data == null
                          ? LinearProgressIndicator()
                          : wrapCopy(widget.data, boldColorFont(24.0, Colors.black)),
                      ],
                    ),
                    DropdownButton(
                      isDense: true,
                      value: actualDropdown,
                      onChanged: (String value) => setState(() {
                        actualDropdown = value;
                        actualChart = chartDropdownItems.indexOf(value);
                      }),
                      items: chartDropdownItems.map((String option) {
                        return DropdownMenuItem(
                          value: option,
                          child: wrapCopy(option, normalColorFont(10.0, Colors.blue)),
                        );
                      }).toList()
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    height: 150.0,
                    child: charts.BarChart(getSeries(actualChart), animate: true),
                  ),
                ),
              ],
            )
      ),
    );
  }
}
