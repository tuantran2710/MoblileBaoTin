import 'package:flutter/cupertino.dart';

import '/stat/statpaymentbar.dart';
import '/stat/statpaymentpie.dart';
import '/stat/statpaymenttoppie.dart';
import '/stat/statstorebottomproduct.dart';
import '/stat/statstorekg.dart';
import '/stat/statstoretopproduct.dart';
import '/stat/statstoretree.dart';

import '../store/paymentreport.dart';
import 'package:flutter/material.dart';

class StatManage extends StatefulWidget {
  const StatManage({required this.tokenLogin, required this.storeSubId});

  final String tokenLogin;
  final int storeSubId;

  @override
  State<StatManage> createState() => _StatManageState();
}

class _StatManageState extends State<StatManage> {
  String tokenLogin = "";
  int storeSubId = 0;

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    storeSubId = widget.storeSubId;
  }

  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Thống kê',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Helvetica,',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 23),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green,
            Colors.orange,
          ])
              //     ),
              ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext Context){
                    return StatStoreTree(tokenLogin: tokenLogin, storeSubId: storeSubId);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_bar_alt_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "Kho S.L",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext Context){
                    return StatStoreKg(tokenLogin: tokenLogin, storeSubId: storeSubId);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_bar_alt_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "Kho K.L",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (BuildContext context) {
                        return StatPaymentBar(tokenLogin: tokenLogin);
                  }
                         ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_bar_alt_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "Thu Chi",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (BuildContext context) {
                        return StatPaymentPie(tokenLogin: tokenLogin);
                  }
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_pie_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "Thu Chi",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext Context){
                    return StatStoreTopProduct(tokenLogin: tokenLogin, storeSubId: storeSubId);
                  }));

                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_pie_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "SP Hàng Đầu",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,CupertinoPageRoute(builder: (BuildContext Context){
                    return StatStoreBottomProduct(tokenLogin: tokenLogin, storeSubId: storeSubId);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_pie_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      Text(
                        "SP Không Chạy",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,CupertinoPageRoute(builder: (BuildContext Context){
                    return StatPaymentTopPie(tokenLogin: tokenLogin);
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 1.0)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chart_pie_fill,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Khách Hàng Đầu",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          ),
        ),
      ),
    );
  }
}
