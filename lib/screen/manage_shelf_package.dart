import 'package:flutter/material.dart';

import 'dart:io';
import 'my_globals.dart';
import 'package:my_flutter_app/screen/qr_code_scanner.dart';
import 'package:my_flutter_app/screen/navigation_drawer_widget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:my_flutter_app/api/api.dart';

class ManageShelfPackageWebView extends StatefulWidget {
  const ManageShelfPackageWebView({Key? key}) : super(key: key);

  @override
  State<ManageShelfPackageWebView> createState() => _ManageShelfPackageWebViewState();
}

class _ManageShelfPackageWebViewState extends State<ManageShelfPackageWebView> {
  late WebViewPlusController controller;
  String qrcode = '';
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.indigo[500],
          title: Text('Quản lý kiện - kệ'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebViewPlus(
              // initialUrl: 'http://10.0.2.2/map-package-shelf',
              // initialUrl: 'http://warehouse.tms.ftcjsc.com/map-package-shelf',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) async {
                this.controller = controller;
                var username = await ApiHelper().getLoginData('username');
                var password = await ApiHelper().getLoginData('password');
                var token = await ApiHelper().getLoginData('token');
                print('USERNAME: $username');
                print('PASSWORD: $password');
                print('TOKEN: $token');
                controller.webViewController.loadUrl(
                  'https://warehouse.tms-s.vn/map-package-shelf',
                  // 'http://warehouse.tms.ftcjsc.com/map-package-shelf',
                  headers: {
                    "username": "$username",
                    "password": "$password",
                    "Authorization": "$token",
                  },
                );
              },
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptChannels: {
                JavascriptChannel(
                    name: 'ManageShelfPackageChannel',
                    onMessageReceived: (message) async {
                      print('---------MESSAGE RECEIVED FROM JS--------');
                      print(message.message);
                      int successIdx = message.message.indexOf(';');
                      print(successIdx);
                      if ( successIdx > 0 ) {
                        String strStatus = message.message.substring(0, successIdx);
                        int msgIdx = message.message.lastIndexOf(";");
                        String msg = message.message.substring(successIdx + 5 ,msgIdx);
                        print(strStatus);
                        print(msg);

                        bool status = false;
                        if ( strStatus == "success:true" ) {
                          status = true;
                        }
                        print(status);

                        setState(() {
                            isLoading = false;
                            _showSuccessMsg(msg, status);
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                            _showSuccessMsg(message.message, false);
                          });
                        }
                      


                      // if(message.message == 'JS command: Get shelf information successed!') {
                      //   setState(() {
                      //     isLoading = false;
                      //     _showSuccessMsg('Lấy dữ liệu kệ thành công!', true);
                      //   });
                      // }
                      // if(message.message == 'JS command: Import package successed!') {
                      //   setState(() {
                      //     isLoading = false;
                      //     _showSuccessMsg('Chuyển kiện vào kệ thành công!', true);
                      //   });
                      // }
                      // if(message.message == 'Kiện đã được lưu trong kệ này') {
                      //   setState(() {
                      //     isLoading = false;
                      //     _showSuccessMsg('Kiện đã trong kệ. Vui lòng quét kiện khác!', false);
                      //   });
                      // }
                      // if(message.message == 'QR Code không tồn tại, vui lòng quét mã khác') {
                      //   setState(() {
                      //     isLoading = false;
                      //     _showSuccessMsg('QRCode không tồn tại, vui lòng quét mã khác!', false);
                      //   });
                      // }
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
        ),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            tooltip: 'Quét QRCode',
            elevation: 4.0,
            backgroundColor: Colors.green[400],
            child: Icon(Icons.qr_code),
            onPressed: () async {
              final String newQRCode = await Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ScanQRCodeScreen()),
                MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
              );

              setState(() {
                qrcode = newQRCode;
                print('found qrcode !!!!!');
                print('$qrcode');
                if(qrcode != null) {
                  isLoading = true;
                  controller.webViewController.runJavascript(
                    'console.log("1234512412512512521");'
                    'document.getElementById("qr_code").value = `$qrcode`;'
                    'document.getElementById("submit").click();'
                  );
                }
              });
            }
          ),
        )
      ),
      onWillPop: () async {
        final exitApp = await confirmExitAppDialog();
        return exitApp ?? false;
      },
    );
  }

  _showSuccessMsg(msg, bool isSuccess) { //
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: isSuccess ? Colors.green[400] : Colors.orange[400],
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
