import 'dart:convert';
import 'package:flutter/material.dart';

import 'my_globals.dart';
import 'package:my_flutter_app/screen/webview.dart';
import 'package:my_flutter_app/api/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameInputField = TextEditingController();
  TextEditingController passwordInputField = TextEditingController();
  bool? rememberAccount = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print('arguments relogin: ${arguments['reLogin']}');
    if(arguments['reLogin'] != null) {
      setState(() {
        Future(() {
          final snackBar = SnackBar(content: Text('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login-background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                color: Colors.indigo.withOpacity(0.35),
              ),
            )
          ),
          Positioned(
            top: 120,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              height: 400,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ]
              ),
              child: Column (
                children: [
                  Container(
                    width: 180,
                    height: 90,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/logo-tms.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Đăng nhập tài khoản của bạn",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        buildInputTextField(Icons.supervisor_account_outlined, usernameInputField ,"Nhập tên tài khoản"),
                        buildInputTextField(Icons.lock_outline, passwordInputField, "Nhập mật khẩu"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Expanded(
                            //   child: CheckboxListTile(
                            //     dense: true,
                            //     contentPadding: EdgeInsets.zero,
                            //     activeColor: Colors.indigo[400],
                            //     title: Text(
                            //       " Ghi nhớ tài khoản",
                            //       style: TextStyle(fontSize: 15),
                            //     ),
                            //     value: rememberAccount,
                            //     onChanged: (bool? newValue) {
                            //       setState(() {
                            //         rememberAccount = newValue;
                            //       });
                            //     },
                            //     controlAffinity: ListTileControlAffinity.leading,
                            //   ),
                            // ),
                            Text(
                              "Quên mật khẩu? ",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned (
            top: 480,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                width: 210,
                height: 70,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: Offset(0,2),
                    ),
                  ],
                ),
                child: InkWell (
                  onTap: () {
                    print("ĐÃ NHẤN VÀO NÚT ĐĂNG NHẬP!!!");
                    _loginAction();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo[200]!, Colors.indigo[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0,1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height-30,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                "Copyright © 2022, Textile Management Solutions. All rights reserved",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputTextField(IconData icon, inputField, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: hint == "Nhập mật khẩu" ? true : false,
        controller: inputField,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          contentPadding: EdgeInsets.all(20),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _loginAction() async {
    var loginUrl = Uri.parse('https://ttd-api.tms-s.vn/api/v1/login');
    // var loginUrl = Uri.parse('https://ttd-api.tms.ftcjsc.com/api/v1/login');
    setState(() {

    });

    var data = {
      'username':usernameInputField.text,
      'password':passwordInputField.text,
    };

    var response = await ApiHelper().postData(data, loginUrl);
    var body = json.decode(response.body);
    if(body['success']) {
      // GlobalVariable.userId = body['user']['id'];
      // GlobalVariable.userName = body['user']['username'];
      // GlobalVariable.userEmail = body['user']['email'];
      // GlobalVariable.accessToken = body['user']['token'];
      // GlobalVariable.password = passwordInputField.text;
      // GlobalVariable.ttd_user_auth = body['user'];
      ApiHelper().storeLoginData('username', body['user']['username']);
      ApiHelper().storeLoginData('password', passwordInputField.text);
      ApiHelper().storeLoginData('email', body['user']['email']);
      ApiHelper().storeLoginData('token', body['user']['token']);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/web_view',
        (Route<dynamic> route) => false,
        // ModalRoute.withName('/'),
      ).then((value) {
        usernameInputField.clear();
        passwordInputField.clear();
      });
    }else {
      _showMsg(body['message']);
    }
  }

  _showMsg(msg) { //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}