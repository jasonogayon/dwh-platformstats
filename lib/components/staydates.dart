import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/copy.dart';
import '../components/font.dart';

Container stayDates(Map stayData, List<Widget> content) {
  return Container(
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: content,
      )
    )
  );
}

Container dateButton(BuildContext ctx, Map stayDate, bool isFullWidth, EdgeInsets padding) {
  return Container(
    width: isFullWidth ? MediaQuery.of(ctx).size.width/2 - 32.0 : null,
    padding: padding,
    child: Column(
      children: <Widget>[
        wrapCopy(stayDate['label'], boldFont(14.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            wrapCopy(
              stayDate['day'] < 10
              ? "0${stayDate['day']}"
              : stayDate['day'].toString(),
             boldFont(28.0)),
            Container(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: <Widget>[
                  wrapCopy(stayDate['month'], boldFont(14.0)),
                  wrapCopy(stayDate['year'].toString(), boldFont(14.0)),
                ],
              ),
            ),
          ],
        ),
        wrapCopy(stayDate['nameOfDay'].toString(), boldFont(12.0)),
      ]
    ),
  );
}

Map dateButtonDetails(String label, DateTime date) {
  return {
    'label': label,
    'day': date.day,
    'nameOfDay': DateFormat.EEEE().format(date),
    'month': DateFormat.MMM().format(date).toUpperCase(),
    'year': date.year,
  };
}

Container stayNights(int nights, EdgeInsets padding) {
  String copy = nights > 1 ? '$nights Nights Stay' :  '$nights Night Stay';
  Icon stayNightsIcon = Icon(Icons.hotel, size: 20.0, color: Colors.black);

  return Container(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              stayNightsIcon,
              padWrapCopy(copy, normalFont(14.0), EdgeInsets.only(left: 8.0)),
            ],
          ),
        ),
      ],
    ),
  );
}

ButtonTheme stayDate(
  BuildContext ctx,
  Container container,
  String buttonType,
  bool willRedirect,
  String redirectLocation
) {
  var redirection = willRedirect ? (){ Navigator.of(ctx).pushNamed(redirectLocation); } : () {};

  return ButtonTheme(
    child: buttonType == 'raised' ?
      RaisedButton(child: container, onPressed: redirection, elevation: 4.0, color: Colors.blueGrey[100],) :
      FlatButton(child: container, onPressed: redirection),
  );
}
