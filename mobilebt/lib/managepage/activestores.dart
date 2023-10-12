import 'package:flutter/cupertino.dart';

import '../dashboardmenu.dart';

import 'storemanage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveStores extends StatefulWidget {
  const ActiveStores({required this.userId, required this.tokenLogin, required this.storeSubId});

  final String tokenLogin;
  final int userId;
  final int storeSubId;

  @override
  _ActiveStoresState createState() => _ActiveStoresState();
}

class _ActiveStoresState extends State<ActiveStores> {
  String tokenLogin = "";
  int userId = 0;
  int storeId = 0;
  int storeSubId = 0;
  final String url = "http://125.253.121.180/CommonService.svc/Store/";
  final String activeStoresUrl = "GetActiveStores?token=";


  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    userId = widget.userId;
    storeSubId = widget.storeSubId;
  }

  Future<List<dynamic>> fetchTickets() async {
    var result = await http.get(Uri.parse(url + activeStoresUrl + tokenLogin + "&storeSubId=" + storeSubId.toString()));
    List<dynamic> lst = json.decode(result.body)['activeStores'];
    return lst;
  }

  String _name(dynamic activeStores) {
    return activeStores['name'];
  }

  String _data(dynamic activeStores) {
    String productCount =format(activeStores['productCount'].toString());
    String remainProductCount =format(activeStores['remainProductCount'].toString());
    String emptyProductCount =format((activeStores['productCount'] - activeStores['remainProductCount']).toString());
    String valueIn = format(activeStores['totalValueRemainIn'].toString());
    String valueOut = format(activeStores['totalValueRemainOut'].toString());
    String tree = format(activeStores['totalTreeRemain'].toString());
    String kg = format(activeStores['totalKgRemain'].toString());
    return "Số Sản Phẩm Tồn:" + remainProductCount
        + "\r\nSố Sản Phẩm Hết:" + emptyProductCount
        + "\r\nS.L:" + tree
        + "\r\nK.L:" + kg
        + "\r\nGT Mua:" + valueIn
        + "đ\r\nGT Bán:" + valueOut + "đ";
  }

  String format(String val)
  {
    if (val.length<4) return val;
    String decimals = "";
    int dotPos = val.indexOf('.');
    if ( dotPos > 0)
    {
      decimals += val.substring(dotPos);
      val = val.substring(0, dotPos);
    }

    bool isNegative = false;
    if (val[0] == '-')
    {
      isNegative = true;
      val = val.substring(1);
    }
    String result = val;
    for (int i = val.length - 3; i > 0; i = i - 3)
      result = result.substring(0, i) + "," + result.substring(i);
    if (isNegative) result = '-' + result;
    return result + decimals;
  }

  int _id(dynamic activeStores) {
    return activeStores['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomSheet: Text(
      //   "HOTLINE: 0817.789.789 - 0787.979.979",
      //   style:
      //       TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow[200]),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'QUẢN LÝ KHO',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Helvetica,',
              fontWeight: FontWeight.bold,
              fontSize: 23),
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
        child: FutureBuilder<List<dynamic>>(
          future: fetchTickets(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return RefreshIndicator(
              child: _listView(snapshot),
              onRefresh: fetchTickets,
            );
          },
        ),
      ),
    );
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      // return ListView.builder(
      //     padding: EdgeInsets.all(8),
      //     itemCount: snapshot.data.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Card(
      //           child: Column(
      //         children: <Widget>[
      //           ListTile(
      //             title: Text(_name(snapshot.data[index])),
      //             trailing: ElevatedButton(
      //               style: ElevatedButton.styleFrom(
      //                 primary: Colors.white,
      //               ),
      //               child: Text(_id(snapshot.data[index]).toString(),
      //                   style: TextStyle(fontWeight: FontWeight.bold)),
      //               onPressed: () {
      //                 Navigator.pushAndRemoveUntil(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => StoreManage(
      //                             userId: userId,
      //                             tokenLogin: tokenLogin,
      //                             storeId: _id(snapshot.data[index]),
      //                             storeSubId: storeSubId,
      //                             )),
      //                     (route) => false);
      //               },
      //             ),
      //           ),
      //         ],
      //       ));
      //     });
      return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 20),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {

            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreManage(
                          userId: userId, tokenLogin: tokenLogin, storeId: _id(snapshot.data[index]), storeSubId: storeSubId, storeName: _name(snapshot.data[index]),)));
              },
              splashColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
                        Icons.store_outlined,
                        size: 50,
                        color: Colors.yellow
                    ),
                    Text(
                      _name(snapshot.data[index]),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _data(snapshot.data[index]),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          }
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
