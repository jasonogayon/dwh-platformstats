import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/tile.dart';
import '../../components/copy.dart';
import '../../components/font.dart';
import '../../utils/regex.dart';

class SquareTile extends StatefulWidget {
  final dynamic label;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Map data;

  SquareTile({
    Key key, this.label, this.description, this.icon, this.iconColor, this.data
  }) : super(key: key);

  @override
  SquareTileState createState() => SquareTileState();
}

class SquareTileState extends State<SquareTile> {
  @override
  Widget build(BuildContext ctx) {
    var data = widget.data;

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

    List<Widget> dialogContent(String description) {
      List<Widget> content = [];
      if (description.toLowerCase().contains('rewards')) {
        for (var i=0; i<data['data'].length; i++) {
          var rewardsResponse = json.decode(data['data'][i][7]);
          var rewardsData = json.decode(data['data'][i][5]);
          content.add(Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.loyalty, color: Colors.pink))
          );
          content.add(generateCopy('Member Number:', rewardsResponse['result']['membership_number']));
          content.add(generateCopy('Member Name:', '${rewardsData['name']['surname']}, ${rewardsData['name']['firstname']}'.toUpperCase()));
          content.add(generateCopy('Member Email:', rewardsData['email']));
          content.add(generateCopy('Member Phone:', rewardsData['mobile_phone']));
          content.add(generateCopy('Member Address:', ''));
          content.add(centerPadWrapCopy(
            '${rewardsData['address']['line1']}, ${rewardsData['address']['city']}, ${rewardsData['address']['postcode']}, ${rewardsData['address']['country']}',
            normalFont(10.0), EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0)
          ));
          content.add(generateCopy('Member Birthday:', '${rewardsData['birthday']['month']}-${rewardsData['birthday']['day']}'));
          content.add(Divider());
          content.add(generateCopy('Membership Date:', ''));
          content.add(centerPadWrapCopy(
            data['data'][i][6],
            normalFont(10.0), EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0)
          ));
          content.add(generateCopy('Membership Type:', rewardsData['membership_type']));
          content.add(generateCopy('Origin Site:', rewardsData['origin_site']));
          content.add(generateCopy('Login Type:', rewardsData['signin']['login_type']));
          content.add(Divider(height: 20.0, color: Colors.green));
        }
      } else if (description.toLowerCase().contains('voucher')) {
        for (var i=0; i<data['data'].length; i++) {
          var vouchers = data['data'][i];
          var details = json.decode(vouchers['voucher_details']);
          var guest = json.decode(vouchers['guest_details']);
          var payment = json.decode(vouchers['payment_details']);
          var currency = details['currency'];
          content.add(Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.shopping_basket, color: Colors.lightGreen))
          );
          content.add(generateCopy('Order No:', vouchers['order_no']));
          content.add(generateCopy('Order Status:', vouchers['status_id'] == 3 ? 'Claimed' : 'Confirmed'));
          content.add(generateCopy('Transaction Id:', vouchers['transaction_id']));
          content.add(generateCopy('Property:', vouchers['org_name']));
          content.add(Divider());
          content.add(generateCopy('Voucher Id:', details['cart'][0]['voucher_id']));
          content.add(generateCopy('Voucher Code:', details['cart'][0]['voucher_code']));
          content.add(generateCopy('Voucher Name:', details['cart'][0]['details']['voucher_name']));
          content.add(generateCopy('Voucher Description:', ''));
          content.add(centerPadWrapCopy(
            details['cart'][0]['details']['voucher_description'],
            normalFont(10.0), EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0)
          ));
          content.add(generateCopy('Quantity:', details['total_quantity']));
          content.add(generateCopy('Validity:', details['cart'][0]['validity_copy']));
          content.add(generateCopy('Claiming Days:', ''));
          content.add(centerPadWrapCopy(
            details['cart'][0]['claiming_days_copy'],
            normalFont(10.0), EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0)
          ));
          content.add(generateCopy('Claim Date:', details['cart'][0]['claim_date'] ?? 'N/A'));
          content.add(Divider());
          content.add(generateCopy('Guest Name:', "${guest['last_name']}, ${guest['first_name']}".toUpperCase()));
          content.add(generateCopy('Guest Email:', guest['email']));
          content.add(generateCopy('Guest Phone:', guest['mobile_no']));
          content.add(generateCopy('Guest Country:', guest['country']));
          content.add(Divider());
          content.add(generateCopy('Total Taxes/Fees:', '$currency ${priceFormat(double.parse(details['total_tax_fees']))}'));
          content.add(generateCopy('Total Amount:', '$currency ${priceFormat(double.parse(details['total_amount']))}'));
          content.add(Divider());
          content.add(generateCopy('Payment Mode:', payment['payment_mode']));
          content.add(generateCopy('Payment Method:', payment['pgw_method']));
          content.add(generateCopy('Payment Reference No:', payment['pgw_ref_no']));
          content.add(generateCopy('Device:', ''));
          content.add(centerPadWrapCopy(
            vouchers['device_details'],
            normalFont(10.0), EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0)
          ));
          content.add(Divider(height: 20.0, color: Colors.green));
        }
      } else {
        var currency = data['currency_code'];
        content = [
          generateCopy('Confirmation No:', data['confirmation_no']),
          generateCopy('Transaction Id:', data['transaction_id'] ?? 'N/A'),
          generateCopy('Property:', data['property_name']),
          generateCopy('Check-In Date:', data['check_in_date']),
          generateCopy('Check-Out Date:', data['check_out_date']),
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
          generateCopy('Total Amount:', '$currency ${priceFormat(double.parse(data['total_amount']))}'),
        ];

        if (description.toLowerCase().contains('extra bed')) {
          content.add(Divider());
          content.add(generateCopy('Extra-Bed Quantity:', data['extra_bed_details'].split(',')[1].split(':')[1]));
          content.add(generateCopy('Extra-Bed Rate:', '$currency ${data['extra_bed_details'].split(',')[4].split(':')[1]}'));
        }
        if (description.toLowerCase().contains('add-on')) {
          for (var i=1; i<data['add_on_details'].split('"name":"').length; i++) {
            content.add(Divider());
            content.add(generateCopy('Add-on Name:', ''));
            content.add(centerPadWrapCopy(
              data['add_on_details'].split('"name":"')[i].split('"')[0],
              normalFont(10.0), EdgeInsets.only(top: 4.0, bottom: 8.0)
            ));
            content.add(generateCopy('Add-on Description:', ''));
            content.add(centerPadWrapCopy(
              data['add_on_details'].split('"description":"')[i].split('"')[0],
              normalFont(10.0), EdgeInsets.only(top: 4.0, bottom: 8.0)
            ));
            content.add(generateCopy('Add-on Quantity:', data['add_on_details'].split('"quantity":')[i].split(',')[0]));
            content.add(generateCopy('Add-on Rate:', '$currency ${data['add_on_details'].split('"total_rate":')[i].split(',')[0]}'));
          }
        }
      }
      return content;
    }

    return buildTile(
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              color: widget.iconColor,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(widget.icon, color: Colors.white, size: 26.0),
              )
            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            widget.label == null
              ? Padding(child: LinearProgressIndicator(), padding: EdgeInsets.symmetric(vertical: 4.0))
              : wrapCopy(widget.label, boldColorFont(30.0, Colors.black)),
            wrapCopy(widget.description, normalColorFont(10.0, Colors.blueGrey[400])),
          ]
        ),
      ),
      onTap: data == null || (widget.description.toLowerCase().contains('voucher') && data['total'] == 0)
        ? null
        : () {
          showDialog(
            context: ctx,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    widget.description.toLowerCase().contains('rewards')
                      ? 'Latest Subscriptions'
                      : widget.description.toLowerCase().contains('voucher')
                        ? 'Latest Vouchers' : 'Latest Reservation',
                    style: TextStyle(fontSize: 14.0)
                  ),
                ),
                content: Container(
                  width: 400.0,
                  child: ListView(
                    children: dialogContent(widget.description),
                  )
                )
              );
            },
          );
      },
    );
  }
}
