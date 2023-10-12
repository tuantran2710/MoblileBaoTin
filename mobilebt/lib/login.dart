import 'dart:convert';
import 'dart:async';
import 'package:mobilebt/MainHome.dart';

import 'stat/statpaymentbar.dart';
import 'stat/statpaymentpie.dart';
import 'stat/statpaymenttoppie.dart';
import 'stat/statstorebottomproduct.dart';
import 'stat/statstoretopproduct.dart';

import 'dashboardmenu.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  final String url = "http://125.253.121.180/SecurityService.svc/Security/";
  final String tokenUrl =
      "GetToken?publicKey=BAOTINPUBLICKEY_123456789&secretKey=BAOTINSECRETKEY_123456789";
  final String loginUrl = "Login?";

  final String urlCommon = "http://125.253.121.180/CommonService.svc/";
  final String storeSubUrl = "StoreSub/GetStoreSubs";


  late String token;
  late int userId;

  String dropdownValue = '';
  @override
  initState() {
    // Future.delayed(Duration(seconds:0),() async {
    //   //your async 'await' codes goes here
    //   fetchStoreSubs();
    // });

    super.initState();
    fetchStoreSubs().then((List<String> result) {
      setState(() {
        lstStoreSubs = result;
      });
    });
  }

  Future<String> login(String userName, String password) async {
    var result = await http.get(Uri.parse(url + tokenUrl));
    String getToken = json.decode(result.body)['accesstoken'];
    if (getToken.length > 0) {
      result = await http.get(Uri.parse(url +
          loginUrl +
          "userName=" +
          userName +
          "&password=" +
          password +
          "&token=" +
          getToken));
      dynamic obj = json.decode(result.body);
      if (obj['islogin_success'] == 'false')
        return "";
      else {
        token = obj['token_loginsuccess'];
        userId = obj["id"];

        return token;
      }
    } else
      return "";
  }

  List<dynamic> lstStoreSubs = <String>[];

  // List<String> lstResult = <String>[];
  Future<List<String>> fetchStoreSubs() async {
    var result = await http.get(Uri.parse(urlCommon + storeSubUrl));
    List<dynamic> lstStoreSubs = json.decode(result.body)['storeSubs'];

    List<String> lstResult = <String>[];
    for (int i = 0; i < lstStoreSubs.length; i++) {
      lstResult.add(lstStoreSubs[i]["id"].toString() +
          '-' +
          lstStoreSubs[i]["name"].toString());
    }
    dropdownValue = lstResult[0];
    return lstResult;
  }

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final dropStoreSubs = GlobalKey<DropdownSearchState<String>>();

  int _storeSubId(String storeSub) {
    return int.parse(storeSub.substring(0, storeSub.indexOf("-")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Image.asset('images/baotin2.png'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 500,
                  width: 360,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('images/baotincontainer6.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 1,
                          ),
                          // Icon(
                          //   Icons.key,
                          //   size: 50,
                          //   color: Colors.blue,
                          // ),
                          SizedBox(
                            height: 240,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: txtUsername,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nhập tài khoản đăng nhập đúng.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Tài khoản',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Helvetica',
                                      ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Helvetica'
                                ),
                                controller: txtPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nhập mật khẩu đúng.';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Mật khẩu',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Helvetica',
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 50.0),

                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                //   child: DropdownButton<String>(
                                //     dropdownColor: Colors.white,
                                //     value: dropdownValue,
                                //     icon: const Icon(Icons.arrow_downward,color: Colors.black),
                                //     elevation: 16,
                                //     style: const TextStyle(color: Colors.black),
                                //     // underline: Container(
                                //     //   height: 2,
                                //     //   color: Colors.deepPurpleAccent,
                                //     // ),
                                //     onChanged: (String? value) {
                                //       // This is called when the user selects an item.
                                //       setState(() {
                                //         dropdownValue = value!;
                                //       });
                                //     },
                                //     items: lstResult.map<DropdownMenuItem<String>>((String value) {
                                //       return DropdownMenuItem<String>(
                                //         value: value,
                                //         child: Text(value),
                                //       );
                                //     }).toList(),
                                //   ),
                                // ),
                                child:
                                DropdownButton(
                                          dropdownColor: Colors.white,
                                          value: dropdownValue,
                                          icon: Icon(Icons.arrow_drop_down,color: Colors.black),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          onChanged: (newValue) {
                                            setState(() {
                                              dropdownValue = newValue as String;
                                            });
                                          },
                                          items: lstStoreSubs.map<DropdownMenuItem<String>>((dynamic value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )

                              )
                          ),

                          SizedBox(
                            height: 1,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 110),
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[300],
                                  ),
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  label: Text("Đăng nhập",
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 16,
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login(txtUsername.text, txtPassword.text)
                                          .then((String result) {
                                        if (result.length > 0) {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OutputList(
                                          //                 userId: userId,
                                          //                 tokenLogin: token)));
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MainHome(tokenLogin: token, userId: userId, storeSubId: _storeSubId(dropdownValue),)));
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             StatStoreBottomProduct(
                                          //               tokenLogin: token, storeSubId: _storeSubId(dropdownValue),
                                          //             )));
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "CTCP PHẦN MỀM & CÔNG NGHỆ TỰ ĐỘNG 4.0 BẢO TÍN\n📱HOTLINE: 0817.789.789 - 0787.797.797\n📩EMAIL:INFO@BAOTINSOFTWARE.VN\n🌎WEBSITE:BAOTINSOFTWARE.VN",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Helvetica',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
