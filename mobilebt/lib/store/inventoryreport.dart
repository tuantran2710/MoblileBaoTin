import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InventoryReport extends StatefulWidget {
  const InventoryReport({required this.tokenLogin, required this.storeId, required this.storeSubId});

  final String tokenLogin;
  final int storeId;
  final int storeSubId;

  @override
  _InventoryReportState createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> {
  String tokenLogin = "";
  final String url = "http://125.253.121.180/CommonService.svc/Remain/";
  final String remainListUrl = "GetRemains?token=";
  int storeId = 0;
  int storeSubId = 0;

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    storeId = widget.storeId;
    storeSubId = widget.storeSubId;
    fetchInventory();
  }

  List<_Data> lstPayment =  <_Data>[];
  List<_Data> lstSource =  <_Data>[];
  bool isUpdateUI = false;
  void fetchInventory() async {
    isUpdateUI = false;
    var result = await http.get(Uri.parse(url + remainListUrl + tokenLogin + "&storeSubId=" + storeSubId.toString() + "&storeId=" + storeId.toString())).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 408); // Request Timeout response status code
      },
    );
    List<dynamic> lst = json.decode(result.body)['remain_info'];
    _Data data;
    for(dynamic item in lst)
    {
      data = _Data(item['ProductCode'], item['Product'], '', '',item['ColorCode'], item['Color']);
      data.setProduct(item);
      data.setData(item);
      lstPayment.add(data);
      lstSource.add(data);
    }
    isUpdateUI = true;
    setState(() {
      if (isUpdateUI);
    });
  }


  TextEditingController txtKeyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Báo Cáo Hàng Tồn",
          style:
              TextStyle(fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
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
      body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
              child: Row(
                  children: <Widget>[
                    Icon(Icons.search, size:32, color: Colors.black,),
                    SizedBox(height: 32.0, width: 200.0,
                      child:
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        controller: txtKeyword,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            //
                            //   focusedBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                            //   ),
                            //   enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.red, width: 1.0),
                            //   ),
                            hintText: 'Từ Khóa',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                //fontFamily: 'Helvetica',
                                fontSize: 14, fontWeight: FontWeight.bold
                            )),
                        onChanged: (value) {
                          if (value.length == 0) {
                            lstPayment.clear();
                            for (dynamic item in lstSource) {
                              lstPayment.add(item);
                            }
                            setState(() {

                            });
                          }
                          else if (value.length > 1) {
                            _Data data;
                            lstPayment.clear();
                            value = value.toUpperCase();
                            for (dynamic item in lstSource) {
                              if (item.code.toString().contains(value) || item.name.toString().contains(value) || item.colorCode.toString().contains(value) || item.colorName.toString().contains(value))
                              {
                                lstPayment.add(item);
                              }
                            }
                            if (lstPayment.length>0)
                              setState(() {

                              });
                          }
                        },
                      ),),
                  ]),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 600.0, width: 520.0,
                    child:_listView())
              ],
            )
          ])
    );
  }

  Widget _listView() {
    return ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: lstPayment.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('${lstPayment[index].product}',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  subtitle: Text('${lstPayment[index].data}',style: TextStyle(color: Colors.black),),
                )
              ],
            ),
          );
        });
  }
}

class _Data {
  _Data(this.code, this.name, this.product, this.data, this.colorCode, this.colorName);
  setProduct(dynamic remainStores) {
    product = 'Sản Phẩm: ' + remainStores['ProductCode'] + ' - ' + remainStores['Product'];
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



  setData(dynamic remainStores) {
    data = 'Màu: ' + remainStores['ColorCode'] + ' - ' + remainStores['Color'] + '\r\nS.L: ' +
        format(remainStores['TreeRemain'].toString()) + ' - K.L: ' + format(remainStores['KgRemain'].toString()) + '\r\nGiá Bán: ' +
        format(remainStores['Price'].toString()) + 'đ - GṬ Tồn: ' + (remainStores['StrTotalRemain'].length==0?'0':remainStores['StrTotalRemain']) + 'đ';
  }

  String code;
  String name;
  String colorCode;
  String colorName;
  String product;
  String data;
}