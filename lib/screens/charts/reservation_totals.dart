import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import '../../globals.dart' as globals;
import '../../components/tile.dart';
import '../../components/copy.dart';
import '../../components/font.dart';

class ReservationTotalsChart extends StatefulWidget{
  final String label;
  final dynamic data;
  final Map reservations;

  ReservationTotalsChart({Key key, this.label, this.data, this.reservations}) : super(key: key);

  @override
  _ReservationTotalsChartState createState() => _ReservationTotalsChartState();
}

class _ReservationTotalsChartState extends State<ReservationTotalsChart> {
  List<double> rsvsnsMonthFull = [];
  List<List<double>> charts = [];
  static final List<String> chartDropdownItems = [
    'Bookings for the last 7 days',
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  void updateChartData() {
    for (var i=6; i>=0; i--) {
      rsvsnsMonthFull.add(double.parse(globals.reservations['readResChart_$i']['total'].toString()));
    }
    charts.add(rsvsnsMonthFull);
  }


  @override
  void initState() {
    super.initState();

    updateChartData();
  }


  @override
  Widget build(BuildContext context){
    return buildTile(
      Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
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
                    double.parse(widget.data.replaceAll('\$ ', '')) == 0.0
                      ? Container(
                          child: LinearProgressIndicator(),
                          width: 100.0,
                          padding: EdgeInsets.symmetric(vertical: 8.0)
                        )
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
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0)),
            Sparkline(
              data: charts[actualChart],
              lineColor: Colors.lightBlueAccent,
              pointColor: Color(0xFF0277BD),
              pointsMode: PointsMode.all,
              fallbackHeight: 150.0,
            )
          ],
        )
      ),
    );
  }
}
