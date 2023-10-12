import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class StatPaymentTopPie extends StatefulWidget {
  const StatPaymentTopPie({required this.tokenLogin});
  final String tokenLogin;

  @override
  _StatPaymentTopPieState createState() => _StatPaymentTopPieState();
}

class _StatPaymentTopPieState extends State<StatPaymentTopPie> {
  List<_PaymentData> lstPaymentIncome =  <_PaymentData>[];
  List<_PaymentData> lstPaymentOutcome = <_PaymentData>[];


  String tokenLogin = "";
  final String url = "http://125.253.121.180/CommonService.svc/";
  final String statPaymentTopPieUrl = "Payment/GetListStatTopIncome?token=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    fetchStatPaymentTopPie(3, 2023);
  }

  Future<void> fetchStatPaymentTopPie(int top, int year) async {
    String statPaymentTopPieBaseUrl = url + statPaymentTopPieUrl + tokenLogin +
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


  int _top = 3;

  TextEditingController txtTop = TextEditingController(text: '3');
  TextEditingController txtYear = TextEditingController(text: DateTime.now().year.toString());
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('THỐNG KÊ KHÁCH HÀNG ĐẦU NĂM ' + _year.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16)),
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
         body:
         Column(
             children: <Widget>[
               Row(
                   children: <Widget>[
                     Icon(Icons.search, size:32, color: Colors.blue,),
                     SizedBox(height: 32.0, width: 100.0,
             child:
                     TextFormField(
                       style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                       controller: txtTop,

                       decoration: InputDecoration(
                           border: InputBorder.none,
                           hintText: 'Hàng Đầu',
                           hintStyle: TextStyle(
                               color: Colors.blue,
                               //fontFamily: 'Helvetica',
                               fontSize: 14, fontWeight: FontWeight.bold
                           )),
                       onChanged: (value) {
                         try {
                           _top = int.parse(value);
                           fetchStatPaymentTopPie(_top, _year);
                         }catch(Exception){_top=3;}

                       },
                     )),
        SizedBox(height: 32.0, width: 100.0,
            child:
                     TextFormField(
                       style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                       controller: txtYear,
                       decoration: InputDecoration(
                           border: InputBorder.none,
                           hintText: 'Năm',
                           hintStyle: TextStyle(
                               color: Colors.blue,
                               //fontFamily: 'Helvetica',
                               fontSize: 14, fontWeight: FontWeight.bold
                           )),
                       onChanged: (value) {
                         try {
                           _year = int.parse(value);
                         }catch(Exception){_year = 2023;}
                       },
                     ))
                   ]),
               Column(
                 children: <Widget>[
                   SfCircularChart(
                        // Chart title
                        title: ChartTitle(text: 'THỐNG KÊ THU HÀNG ĐẦU'),
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
                   SfCircularChart(
                     // Chart title
                       title: ChartTitle(text: 'THỐNG KÊ CHI HÀNG ĐẦU'),
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
                       ])
                 ],
               )
             ])
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