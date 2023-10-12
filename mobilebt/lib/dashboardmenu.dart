
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'managepage/statmanage.dart';

import 'changepassword.dart';
import 'managepage/debtpage.dart';
import 'managepage/activestores.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconic/iconic.dart';
class DashboardMenu extends StatefulWidget {
  const DashboardMenu({
    required this.userId,
    required this.tokenLogin,
    required this.storeSubId,
  });

  final String tokenLogin;
  final int userId;
  final int storeSubId;
  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {

  String tokenLogin = "";
  int userId = 0;
  int storeSubId = 0;
  int storeId = 0;
  // url payment
  final String url = "http://125.253.121.180/CommonService.svc/Payment/";
  final String paymentTotalUrl = "GetPaymentTotal?token=";
  //url đồ thị
  final String url2 = "http://125.253.121.180/CommonService.svc/";
  final String statPaymentTopPieUrl = "Payment/GetListStatTopIncome?token=";
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
    userId = widget.userId;
    storeSubId = widget.storeSubId;
    fetchPaymentTotal();
    fetchStatPaymentTopPie(3, 2023);
  }
  List<_PaymentData> lstPaymentIncome =  <_PaymentData>[];
  List<_PaymentData> lstPaymentOutcome = <_PaymentData>[];
// đồ thị 1
  Future<void> fetchStatPaymentTopPie(int top, int year) async {
    String statPaymentTopPieBaseUrl = url2 + statPaymentTopPieUrl + tokenLogin +
        "&top=" + top.toString() + "&year=" + year.toString();
    lstPaymentIncome.clear();
    lstPaymentOutcome.clear();
    num totalIn = 0;
    num totalOut = 0;

    var result = await http.get(Uri.parse(statPaymentTopPieBaseUrl + "&income=true"));
    List<dynamic> lst = json.decode(result.body)['stattopcustomers'];
    num value = 0;
    for(dynamic item in lst) {
      value = item['Money'];
      totalIn += value;
      lstPaymentIncome.add(new _PaymentData(item['Name'], value, 0));
    }
    for(int i=0;i<lstPaymentIncome.length;i++)
      lstPaymentIncome[i].percent = double.parse((100*lstPaymentIncome[i].money/totalIn).toStringAsFixed(2));

    result = await http.get(Uri.parse(statPaymentTopPieBaseUrl + "&income=false"));
    lst = json.decode(result.body)['stattopcustomers'];
    for(dynamic item in lst) {
      value = item['Money'];
      totalOut += value;
      lstPaymentOutcome.add(new _PaymentData(item['Name'], value, 0));
    }
    for(int i=0;i<lstPaymentOutcome.length;i++)
      lstPaymentOutcome[i].percent = double.parse((100*lstPaymentOutcome[i].money/totalOut).toStringAsFixed(2));

    setState((){
      if (lstPaymentIncome.length>0);
    });

  }
  void _showSuccessDialog() {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
  final _controller = PageController();
  int _selectedIndex = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.orange,

                ]
            )
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
              ),
              height: 190,
              width: 460,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(
                    top: 110,
                    left: 15,
                    right: 15,
                  ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text("TỔNG QUAN",
                            style: TextStyle(fontSize: 25,
                                // fontWeight: FontWeight.w500,
                                fontFamily: 'sanf',
                                letterSpacing: 1),
                          ),
                        ),
                        Center(
                          child: Text("Hi, BẢO TÍN SOFTWARE",
                            style: TextStyle(fontSize: 25,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'sanf',
                                letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ) ,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)
                  )
              ),
              height: 580.3,
              width: 460,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Nợ phải trả
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1,2),
                                    blurRadius: 15,
                                    spreadRadius: 1.0
                                )
                              ]
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 100,
                          width: 180,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(CupertinoIcons.money_dollar ,color: Colors.green[500],size: 30,),
                              Text(_remainIn + "₫",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight:FontWeight.w500),),
                              Text("Nợ phải thu",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 18,
                                    fontFamily: 'Helvetica'
                                ),),
                            ],
                          ),
                        ),
                      ),
                      //Nợ phải thu
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(1,2),
                                    blurRadius: 15,
                                    spreadRadius: 1.0
                                )
                              ]
                          ),
                          height: 100,
                          width: 180,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(CupertinoIcons.money_dollar  ,color: Colors.red[500],size: 30,),
                              Text(_remainOut +"₫",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight:FontWeight.w500),),
                              Text("Nợ phải chi",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 18,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Thu tiền trong ngày
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(1,2),
                                        blurRadius: 15,
                                        spreadRadius: 1.0
                                    )
                                  ]
                              ),
                              height: 100,
                              width: 180,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(CupertinoIcons.money_dollar  ,color: Colors.green[500],size: 30,),
                                  Text(_totalIn +"₫",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight:FontWeight.w500)),
                                  Text("Thu trong ngày",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 18),),
                                ],
                              ),
                            ),
                          ),
                          // Chi tiền trong ngày
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(1,2),
                                        blurRadius: 15,
                                        spreadRadius: 1.0
                                    )
                                  ]
                              ),
                              height: 100,
                              width: 180,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(CupertinoIcons.money_dollar  ,color: Colors.red[500],size: 30,),
                                  Text(_totalOut + "₫",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight:FontWeight.w500)),
                                  Text("Chi trong ngày",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 18),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // đồ thị //
                  // ĐỒ THỊ THU CHI
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(1,2),
                                blurRadius: 15,
                                spreadRadius: 2.0
                            )
                          ]
                      ),
                      height: 330,
                      width: 380,
                      child: PageView(
                        controller: _controller,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.black38,
                                //       offset: Offset(1,2),
                                //       blurRadius: 15,
                                //       spreadRadius: 2.0
                                //   )
                                // ]
                              ),
                              // đồ thị 1
                              child: SfCircularChart(
                                // Chart title
                                  title: ChartTitle(text: 'THỐNG KÊ THU HÀNG ĐẦU',
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Helvetica',
                                          letterSpacing: 5)),
                                  // Enable legend
                                  legend: Legend(isVisible: true),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CircularSeries<_PaymentData, String>>[
                                    PieSeries<_PaymentData, String>(
                                        dataSource: lstPaymentIncome,
                                        xValueMapper: (_PaymentData payment, _) => payment.customer,
                                        yValueMapper: (_PaymentData payment, _) => payment.percent,
                                        // Enable data label
                                        dataLabelSettings: DataLabelSettings(isVisible: true)
                                    )
                                  ]),

                            ),
                          ),
                          // đồ thị 2
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.black38,
                                //       offset: Offset(1,2),
                                //       blurRadius: 15,
                                //       spreadRadius: 1.0
                                //   )
                                // ]
                              ),
                              child: SfCircularChart(
                                // Chart title
                                  title: ChartTitle(text: 'THỐNG KÊ CHI HÀNG ĐẦU',textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Helvetica',
                                      letterSpacing: 5)),
                                  // Enable legend
                                  legend: Legend(isVisible: true),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CircularSeries<_PaymentData, String>>[
                                    PieSeries<_PaymentData, String>(
                                        dataSource: lstPaymentOutcome,
                                        xValueMapper: (_PaymentData payment, _) => payment.customer,
                                        yValueMapper: (_PaymentData payment, _) => payment.percent,
                                        // Enable data label
                                        dataLabelSettings: DataLabelSettings(isVisible: true)
                                    )
                                  ]),
                            ),
                          ),
                          // đồ thị 3
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey[100],
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(20),
                          //       ),
                          //       // boxShadow: [
                          //       //   BoxShadow(
                          //       //       color: Colors.black38,
                          //       //       offset: Offset(1,2),
                          //       //       blurRadius: 15,
                          //       //       spreadRadius: 1.0
                          //       //   )
                          //       // ]
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: ColorTransitionEffect(
                        activeDotColor: Colors.orange,
                        dotColor: Colors.black.withOpacity(1),
                        dotHeight: 10,
                        dotWidth: 10
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text(
        //   // 'Tổng Quan',
        //   style: TextStyle(
        //     color: Colors.black,
        //       fontFamily: 'Helvetica,',
        //       fontWeight: FontWeight.bold,
        //       fontSize: 23),
        // ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(

            // gradient: LinearGradient(colors: [
            //   Colors.green,
            //   Colors.orange,
            //   Colors.white,
            // ],
            //     ),
          ),
        ),

      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.orange,

                  ]
              )
          ),
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(
                  "BẢO TÍN SOFTWARE",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text("info@baotinsoftware.com",
                    style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.red,
                    backgroundImage: AssetImage('images/avatar.png')
                  // backgroundImage: NetworkImage(
                  //     'https://znews-photo.zingcdn.me/w1920/Uploaded/bzwvopcg/2020_12_09/lee.jpeg'),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/draw.jpg'),
                      // image: NetworkImage(
                      //     'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              Column(
                children: [
                  Divider(
                    color: Colors.black,
                    height: 20,
                    indent: 4,
                    endIndent: 4,
                    thickness: 1,
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.assignment_outlined,
                    color: Colors.white, size: 25),
                title: const Text("Quản Lý Kho",
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                onTap: () {
                 Navigator.push(context,MaterialPageRoute(builder: (context)=>
                     ActiveStores(userId: userId, tokenLogin: tokenLogin, storeSubId: storeSubId)));
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_chart_outlined_outlined,
                    color: Colors.white, size: 25),
                title: const Text("Thống Kê",
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatManage(
                            tokenLogin: tokenLogin,
                            storeSubId: storeSubId,
                          )));
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money_rounded,
                    color: Colors.white, size: 25),
                title: const Text("Công Nợ",
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DebtPage(
                            tokenLogin: tokenLogin,
                          )));
                },
              ),
              ListTile(
                leading:
                Icon(Icons.vpn_key_outlined, color: Colors.white, size: 25),
                title: const Text("Đổi Mật Khẩu",
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword(
                              userId: userId, tokenLogin: tokenLogin)));
                },
              ),
              ListTile(
                leading:
                Icon(Icons.logout_outlined, color: Colors.white, size: 25),
                title: const Text("Đăng Xuất",
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
              // Column(
              //   children: [
              //     Divider(
              //       color: Colors.black,
              //       height: 20,
              //       indent: 4,
              //       endIndent: 4,
              //       thickness: 1,
              //     )
              //   ],
              // ),
              SizedBox(
                height: 218,
              ),
              Text(
                " © 2021-2023. Toàn bộ bản quyền thuộc Bảo Tín Software & Automation 4.0+",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Helvetica',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
class _PaymentData {
  _PaymentData(this.customer, this.money, this.percent);
  setPayment(num value)
  {
    money = value;
  }

  setPercent(double value)
  {
    percent = value;
  }

  String customer;
  num money;
  double percent;
}

