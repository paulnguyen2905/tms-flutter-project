import 'package:flutter/material.dart';
import 'package:my_flutter_app/screen/login.dart';
import 'package:my_flutter_app/screen/webview.dart';
import 'package:my_flutter_app/screen/manage_shelf_package.dart';
import 'package:my_flutter_app/screen/scan_qrcode.dart';
import 'package:my_flutter_app/screen/qr_code_scanner.dart';
import 'package:my_flutter_app/api/api.dart';

// void main() => runApp(MaterialApp(
//   initialRoute: '/login',
//   routes: {
//     '/login': (context) => LoginScreen(),
//     '/web_view': (context) => WebViewScreen(),
//     '/manage_shelf_package': (context) => ManageShelfPackageWebView(),
//     '/scan_qrcode': (context) => ScanQRCodeScreen(),
//     '/qr_code_scanner': (context) => QRCodeScannerScreen(),
//   },
// ));

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = LoginScreen();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    var token = await ApiHelper().getLoginData('token');
    print('TOKEN: $token');
    if (token != null) {
      setState(() {
        currentPage = WebViewScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('CURRENT PAGE: $currentPage');
    return MaterialApp(
      home: currentPage,
      // initialRoute: $currentPage,
      routes: {
        '/login': (context) => LoginScreen(),
        '/web_view': (context) => WebViewScreen(),
        '/manage_shelf_package': (context) => ManageShelfPackageWebView(),
        '/scan_qrcode': (context) => ScanQRCodeScreen(),
        '/qr_code_scanner': (context) => QRCodeScannerScreen(),
      },
    );
  }
}

