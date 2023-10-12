import 'package:flutter/cupertino.dart';
import 'package:mobilebt/store/paidreport.dart';
// import 'package:store/store/paidreport.dart';

import '../store/paymentreport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DebtPage extends StatefulWidget {
  const DebtPage({
    required this.tokenLogin,
  });
  final String tokenLogin;

  @override
  State<DebtPage> createState() => _DebtPageState();
}

class _DebtPageState extends State<DebtPage> {
  String tokenLogin = "";
  final String url = "http://125.253.121.180/CommonService.svc/Payment/";
  final String paymentTotalUrl = "GetPaymentTotal?token=";
  String _totalIn = '', _totalOut = '', _customerCount = '', _supplierCount = '', _remainIn = '', _remainOut = '';

  Future<void> fetchPaymentTotal() async {
    var result = await http.get(Uri.parse(url + paymentTotalUrl + tokenLogin + "&storeSubId="));
    List<dynamic> lst = json.decode(result.body)['remain_info'];
    setState(() {
      _customerCount= lst[0]['CustomerCount'].toString();
      _supplierCount= lst[0]['SupplierCount'].toString();
      _remainIn = lst[0]['strRemainIn'].toString();
      _remainOut = lst[0]['strRemainOut'].toString();
      _totalIn = lst[0]['strTotalIn'].toString();
      _totalOut = lst[0]['strTotalOut'].toString();
    });
  }


  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    fetchPaymentTotal();
  }

  String title = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Công nợ',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Helvetica,',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
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
                        return PaymentReport(tokenLogin: tokenLogin, income: false);
                      }));
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
                          CupertinoIcons.money_dollar ,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "NỢ PHẢI TRẢ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Số NCC: " + _supplierCount + "\r\n" +
                              _remainOut + "đ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
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
                      return PaymentReport(tokenLogin: tokenLogin, income: true);
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors:  [Colors.green,Colors.orange],
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
                          CupertinoIcons.money_dollar,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "NỢ PHẢI THU",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Số Khách: " + _customerCount + "\r\n" +
                          _remainIn + "đ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        )                    ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,CupertinoPageRoute(builder: (BuildContext Context){
                      return PaidReport(tokenLogin: tokenLogin, income: true);
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight, colors:  [Colors.green,Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                          CupertinoIcons.money_dollar,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          'TIỀN CHI TRONG \n          \rNGÀY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Số Tiền: " + _totalIn + "đ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        )                    ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,CupertinoPageRoute(builder: (BuildContext Context){
                      return PaidReport(tokenLogin: tokenLogin, income: false);
                    }));
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
                          CupertinoIcons.money_dollar,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          'TIỀN CHI TRONG \n          \rNGÀY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Số Tiền: " + _totalOut + "đ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        )                    ],
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
