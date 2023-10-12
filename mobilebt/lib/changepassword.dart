import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(
      {
      required this.userId,
      required this.tokenLogin});
  final int userId;
  final String tokenLogin;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String tokenLogin = "";
  int userId = 0;
  final String url = "http://125.253.121.180/SecurityService.svc/Security";
  final String changepasswordUrl =
      "ChangePassword?userId=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    userId = widget.userId;
  }

  Future<bool> changepassword(
      String currentPassword, String newPassword) async {
    var result = await http.post(Uri.parse(url + changepasswordUrl + userId.toString() + '&currentpassword=' + currentPassword
    + 'newpassword=' + newPassword + '&token=' + tokenLogin));
    dynamic obj = json.decode(result.body);
      if (obj['islogin_success'] == 'false')
        return false;
      else {
        return true;
      }
  }

  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  void showAlert() {
    QuickAlert.show(
      title: "Thay đổi mật khẩu thành công",
      context: context,
      type: QuickAlertType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0.0,
        title: const Text(
          'Thay Đổi Mật Khẩu',
          style: TextStyle(
              fontFamily: 'Helvetica,',
              fontWeight: FontWeight.bold,
              fontSize: 23),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.orange],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 0.0),
          child: Column(children: [
            // Current Password
            Form(
              key: _formKey,
              child: TextFormField(
                controller: txtCurrentPassword,
                obscureText: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.key, color: Colors.black),
                    filled: true,
                    fillColor: Colors.blue[200],
                    hintText: 'Mật Khẩu Hiện Tại',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            // New Password
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: txtNewPassword,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key, color: Colors.black),
                  filled: true,
                  fillColor: Colors.blue[200],
                  hintText: 'Mật Khẩu Mới',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu của bạn chưa khớp';
                }
                return null;
              },
            ),
            // Enter a new password
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.key,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.blue[200],
                  hintText: 'Nhập Lại Mật Khẩu Mới',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu của bạn chưa khớp';
                }
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 75),
              child: Center(
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50),
                        primary: Colors.blue[300],
                      ),
                      icon: Icon(
                        Icons.key,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Thay Đổi Mật Khẩu",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          changepassword(
                                  txtCurrentPassword.text, txtNewPassword.text)
                              .then((bool result) {
                            if (result) {
                              showAlert();
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
