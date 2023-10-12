import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilebt/dashboardmenu.dart';
import 'package:iconic/iconic.dart';
import 'package:mobilebt/managepage/debtpage.dart';
import 'package:mobilebt/managepage/statmanage.dart';
import 'package:http/http.dart' as http;
class MainHome extends StatefulWidget {
  const MainHome({super.key, required this.tokenLogin, required this.userId, required this.storeSubId});
  final String tokenLogin;
  final int userId;
  final int storeSubId;
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  String tokenLogin = "";
  int userId = 0;
  int storeSubId = 0;
  int storeId = 0;

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

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.grey[100],
        activeColor: Colors.orange,
        inactiveColor: Colors.black87.withOpacity(0.5),
        onTap: (index){

        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home,size: 30,),
            label: 'Dashdoard',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar,size: 30),
              label: 'Công nợ'
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar,size: 30,),
              label: 'Thông kê'
          ),

        ],

      ),
      tabBuilder: (context, index){
        switch (index){
          case 0:
            return DashboardMenu(userId: userId, tokenLogin: tokenLogin, storeSubId: storeSubId);
          case 1:
            return DebtPage(tokenLogin: tokenLogin);
          case 2:
          default:
            return StatManage(tokenLogin: tokenLogin, storeSubId: storeSubId);

        }
      },
    );
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
