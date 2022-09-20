import 'package:flutter/material.dart';

import 'dart:io';
import 'my_globals.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:my_flutter_app/screen/navigation_drawer_widget.dart';
import 'package:my_flutter_app/screen/scan_qrcode.dart';
import 'package:my_flutter_app/screen/qr_code_scanner.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewPlusController controller;
  String qrcode = '';
  bool isLoading = true;
  bool qrCodeUpdated = true;

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.indigo[500],
          title: Text('Kiểm tra kho'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebViewPlus(
              // initialUrl: 'http://10.0.2.2/kiem-tra-kho',
              initialUrl: 'https://warehouse.tms-s.vn/kiem-tra-kho',
              // initialUrl: 'http://warehouse.tms.ftcjsc.com/kiem-tra-kho',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                  qrCodeUpdated = true;
                });
              },
              javascriptChannels: {
                JavascriptChannel(
                    name: 'OpenQRCodeScannerChannel',
                    onMessageReceived: (message) async {
                      if(message.message == 'JS command: Open QRCode Scanner Camera!') {
                        print(GlobalVariable.userId);
                        print(GlobalVariable.accessToken);
                        final String newQRCode = await Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => ScanQRCodeScreen()),
                          MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
                        );

                        setState(() {
                          qrcode = newQRCode;
                          print('QRCODE: $qrcode');
                          if(qrcode != null && qrCodeUpdated == true) {
                            isLoading = true;
                            qrCodeUpdated = false;
                            controller.webViewController.runJavascript(
                              'document.getElementById("pro_info").value = `$qrcode`;'
                              'document.getElementById("submit").submit();'
                            );
                          }
                        });
                      }
                    }
                ),
              },
            ),
            if(isLoading)
              const Center(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(),
                ),
              )
          ]
        )
      ),
      onWillPop: () async {
        final exitApp = await confirmExitAppDialog();
        return exitApp ?? false;
      },
    );
  }


  Future<bool?> confirmExitAppDialog() => showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Vui lòng xác nhận', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Bạn có chắc muốn thoát khỏi ứng dụng?', textAlign: TextAlign.center),
              ],
            )
          ),
          actions: [
            TextButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Xác nhận'),
              onPressed: () async {
                Navigator.pop(context);
                exit(0);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      }
  );
}
