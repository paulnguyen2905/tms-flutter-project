import 'package:flutter/material.dart';

import 'package:my_flutter_app/screen/login.dart';
import 'package:my_flutter_app/screen/webview.dart';
import 'package:my_flutter_app/api/api.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  var isLoggin = true;
  var username;
  var email;
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  void initState() {
    super.initState();
    getLoginInfo();
  }

  getLoginInfo() async {
    this.username = await ApiHelper().getLoginData('username');
    this.email = await ApiHelper().getLoginData('email');
    // this.email = null;
    print('USERNAME: ${this.username}');
    print('EMAIL: ${this.email}');
    if (this.username != null && this.email != null) {
      setState(() {});
    }else {
      this.isLoggin = false;
      this.username = 'Chưa cập nhật';
      this.email = 'Vui lòng đăng nhập lại!';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('USERNAME IN BUILD WIDGET: ${this.username}');
    print('EMAIL IN BUILD WIDGET: ${this.email}');
    return Drawer(
      child: Material(
        color: Colors.indigo[600],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HeaderInfo(
              username: this.username,
              email: this.email,
              onClicked: () {},
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildMenuItem(
                    text: 'Kiểm tra kho',
                    icon: Icons.fact_check,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Quản lý kiện - kệ',
                    icon: Icons.warehouse,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Đăng xuất',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height - 515),
                  Container(
                    // margin: EdgeInsets.only(bottom: 10),
                    child: ClipRRect (
                      child: Image(
                        height: 70.0,
                        width: 70.0,
                        image: AssetImage("images/logo-tms-no-text.png"),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Copyright © 2022, Textile Management Solutions. All rights reserved",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget HeaderInfo({
    required var username,
    required var email,
    VoidCallback? onClicked,
  }) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 50)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage("images/user-icon.png"),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$username',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '$email',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login-background.jpg'),
            fit: BoxFit.fill,
          )
        ),
      )
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon,
        color: color),
      title: Text(text,
        style: TextStyle(
        color: color,
      )),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    Navigator.pop(context);

    switch (index) {
      case 0:
        openConfirmDialog();
        break;
      case 1:
        if(this.isLoggin == false) {
          await ApiHelper().clearAllLoginData();
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (Route<dynamic> route) => false,
            arguments: {'reLogin': true},
          );
        }else if(ModalRoute.of(context)?.settings.name != '/web_view') {
          // Navigator.pushNamed(context, '/web_view');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/web_view',
            ModalRoute.withName('/'),
          );
        }
        break;
      case 2:
        if(this.isLoggin == false) {
          await ApiHelper().clearAllLoginData();
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (Route<dynamic> route) => false,
            arguments: {'reLogin': true},
          );
        }else if(ModalRoute.of(context)?.settings.name != '/manage_shelf_package') {
          // Navigator.pushNamed(context, '/manage_shelf_package');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/manage_shelf_package',
            ModalRoute.withName('/'),
          );
        }
        break;
    }
  }

  Future openConfirmDialog() => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Vui lòng xác nhận', textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Bạn có chắc muốn đăng xuất khỏi tài khoản hiện tại?', textAlign: TextAlign.center),
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
              await ApiHelper().clearAllLoginData();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (Route<dynamic> route) => false,
                // ModalRoute.withName('/'),
              );
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      );
    }
  );
}
