import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../globals.dart' as globals;
import '../constants/urls.dart';
import '../components/copy.dart';
import '../components/font.dart';
import '../components/box.dart';
import '../components/cta.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  int counter = 0;
  int maxFailedAttempts = 5;
  bool hasloginError = false;
  bool maxedLoginAttempts = false;
  bool obscurePassword = true;

  Future<Map<String, dynamic>> cpLoginRequest(String user, String pass) async {
    var client = http.Client();
    var response = await client
      .post(
        Uri.encodeFull(cpLoginURL()),
        body: { 'user_name': user, 'user_pwd': pass, },
        headers: { 'Accept': 'application/json' }
      ).whenComplete(client.close);

    if (!mounted)
      return {'success' : false};

    setState(() {
      var res = json.decode(response.body);
      hasloginError = !res['success'];
      globals.loggedIn = res['success'];
    });

    return json.decode(response.body);
  }


  @override
  void initState() {
    counter = 0;
    hasloginError = false;
    maxedLoginAttempts = false;
    obscurePassword = true;
    super.initState();
  }


  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: loginKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 60.0, left: 40.0, right: 40.0, bottom: 20.0),
              child: Image.asset('assets/logo.gif'),
            ),
            Container(
              child: centerPadWrapCopy(
                'Platform Stats', boldFont(20.0), EdgeInsets.only(top: 16.0)
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: boxNoColor(Colors.grey[300], 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                      child: Container(
                        decoration: boxNoColor(Colors.grey, 1.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 10.0, color: Colors.black),
                          controller: usernameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            labelText: 'Username',
                          ),
                          inputFormatters: [LengthLimitingTextInputFormatter(32)],
                          validator: (str) => str.isEmpty ? 'Enter in a valid username please' : null
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                      child: Container(
                        decoration: boxNoColor(Colors.grey, 1.0),
                        child: TextFormField(
                          obscureText: obscurePassword,
                          style: TextStyle(fontSize: 10.0, color: Colors.black),
                          controller: passwordController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.remove_red_eye, color: Colors.blueGrey),
                              onTap: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              }
                            )
                          ),
                          inputFormatters: [LengthLimitingTextInputFormatter(32)],
                          validator: (str) => str.isEmpty ? 'Enter in a valid password please' : null
                        ),
                      ),
                    ),
                    maxedLoginAttempts
                      ? Container(
                          padding: EdgeInsets.only(left: 40.0, right: 20.0),
                          child: centerPadWrapCopy(
                            'You have exceeded the maximum failed login attempts. Please try again later.',
                            normalColorFont(10.0, Colors.red),
                            EdgeInsets.symmetric(vertical: 8.0)
                          )
                        )
                      : hasloginError
                          ? Container(
                              padding: EdgeInsets.only(left: 40.0, right: 20.0),
                              child: centerPadWrapCopy(
                                'Login Failed. Please check if your login credentials are correct.',
                                normalColorFont(10.0, Colors.red),
                                EdgeInsets.symmetric(vertical: 8.0)
                              )
                            )
                          : Container(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: CallToAction(
                              copy: 'Login',
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              color: maxedLoginAttempts ? Colors.grey : null,
                              onPressedAction: (){
                                if (!maxedLoginAttempts) {
                                  var form = loginKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    cpLoginRequest(usernameController.text, passwordController.text)
                                      .then((response) {
                                        if (response['success']) {
                                          globals.cpUser = usernameController.text;
                                          globals.cpPass = passwordController.text;
                                          usernameController.text = '';
                                          passwordController.text = '';
                                          setState(() {
                                            counter = 0;
                                            hasloginError = false;
                                            maxedLoginAttempts = false;
                                          });
                                          Navigator.of(ctx).pushNamed('/stats');
                                        } else {
                                          print(response);
                                          setState(() {
                                            counter++;
                                            hasloginError = true;
                                            if (counter > maxFailedAttempts) {
                                              maxedLoginAttempts = true;
                                            }
                                          });
                                        }
                                      }
                                    );
                                  }
                                }
                              },
                            ),
                          )
                        ]
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
