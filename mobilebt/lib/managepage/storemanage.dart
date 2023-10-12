import 'dart:convert';
import 'dart:async';
import 'package:mobilebt/store/storecurrentdate.dart';
import 'package:mobilebt/store/warningexpired.dart';
import 'package:mobilebt/store/warningkeep.dart';
import 'package:mobilebt/store/warningremain.dart';
import 'package:mobilebt/store/warningtreeremain.dart';
// import 'package:store/store/storecurrentdate.dart';
// import 'package:store/store/warningkeep.dart';
// import 'package:store/store/warningremain.dart';
// import 'package:store/store/warningexpired.dart';
// import 'package:store/store/warningtreeremain.dart';

import 'activestores.dart';

import '../store/inventoryreport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'lookupremain.dart';

class StoreManage extends StatefulWidget {
  const StoreManage({
    required this.userId,
    required this.tokenLogin, required this.storeId, required this.storeSubId, required this.storeName
  });

  final String tokenLogin;
  final int userId;
  final int storeId;
  final int storeSubId;
  final String storeName;

  @override
  State<StoreManage> createState() => _StoreManageState();
}

class _StoreManageState extends State<StoreManage> {
  String tokenLogin = "";
  int userId = 0;
  int storeId = 0;
  int storeSubId = 0;
  String storeName = "";


  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    userId = widget.userId;
    storeId = widget.storeId;
    storeSubId = widget.storeSubId;
    storeName = widget.storeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0.0,
        title: Text(
          'Quản Lý $storeName',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica',
          ),
        ),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ActiveStores(userId: userId, tokenLogin: tokenLogin, storeSubId: storeSubId))),
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.orange,

                  ]
              )
            //     ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
            children: [
              // InkWell(
              //   onTap: () {},
              //   splashColor: Colors.white,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: Colors.lightBlue,
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.import_export_outlined,
              //           size: 60,
              //           color: Colors.yellow,
              //         ),
              //         Text(
              //           "Nhập Kho",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 22,
              //               fontFamily: 'Helvetica',
              //               fontWeight: FontWeight.bold),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 InventoryReport(tokenLogin: tokenLogin, storeId: storeId, storeSubId: storeSubId,)));
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: Colors.lightBlue,
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.checklist_outlined,
              //           size: 60,
              //           color: Colors.yellow,
              //         ),
              //         Text(
              //           "Kiểm Kê",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 22,
              //               fontFamily: 'Helvetica',
              //               fontWeight: FontWeight.bold),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InventoryReport(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Hàng Tồn",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreCurrentDate(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isIn:true)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Nhập Hôm Nay",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreCurrentDate(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isIn:false)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Xuất Hôm Nay",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningRemain(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isMax: false,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Tồn Trọng Lượng Cận Dưới",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningRemain(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isMax: true,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Tồn Trọng Lượng Cận Trên",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningTreeRemain(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isMax: false,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Tồn Số Lượng Cận Dưới",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningRemain(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId, isMax: true,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Tồn Số Lượng Cận Trên",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningKeep(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Lưu Kho",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              WarningExpired(tokenLogin: tokenLogin, storeSubId: storeSubId, storeId: storeId)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors: [Colors.green,Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2,4),
                            blurRadius: 5,
                            spreadRadius: 1.0
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Cảnh Báo Hết Hạn",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Helvetica',
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
