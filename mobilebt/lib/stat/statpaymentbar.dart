import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class StatPaymentBar extends StatefulWidget {
  const StatPaymentBar({required this.tokenLogin});
  final String tokenLogin;

  @override
  _StatPaymentBarState createState() => _StatPaymentBarState();
}

class _StatPaymentBarState extends State<StatPaymentBar> {
  List<_PaymentData> lstPaymentIncome =  <_PaymentData>[];
  List<_PaymentData> lstPaymentOutcome = <_PaymentData>[];


  String tokenLogin = "";
  final String url = "http://125.253.121.180/CommonService.svc/";
  final String statPaymentBarUrl = "Payment/GetListStatPayment?token=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    _PaymentData data;
    for(int i=1;i<13;i++)
    {
      data = new _PaymentData(i<10?'0' + i.toString():i.toString(), 0);
      lstPaymentIncome.add(data);
      data = new _PaymentData(i<10?'0' + i.toString():i.toString(), 0);
      lstPaymentOutcome.add(data);
    }
    fetchStatPaymentBar(0, 2023);
  }

  bool isUpdateUI = false;
  void fetchStatPaymentBar(int typeId, int year) async {
    isUpdateUI = false;
    var result = await http.get(Uri.parse(url + statPaymentBarUrl + tokenLogin +
        "&typeId=" + typeId.toString() + "&year=" + year.toString()));
    List<dynamic> lst = json.decode(result.body)['statpayments'];
    _PaymentData data;
    for(int i=0;i<12;i++)
      {
        lstPaymentIncome[i].money = 0;
        lstPaymentOutcome[i].money = 0;
      }
    for(dynamic item in lst)
      {
        //data = new _PaymentData(item['Month'] as String, item['Tree'] as int);
        if (item['Income'].toString().toLowerCase()=='true')
            lstPaymentIncome[int.parse(item['Month'])-1].money = double.parse((item['Money']/1000000).toStringAsFixed(0));
        else
          lstPaymentOutcome[int.parse(item['Month'])-1].money = double.parse((item['Money']/1000000).toStringAsFixed(0));
      }
    isUpdateUI = true;
    setState(() {
      if (isUpdateUI);
    });

  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Tất Cả"),value: "0"),
      DropdownMenuItem(child: Text("Nội Bộ"),value: "1"),
      DropdownMenuItem(child: Text("Khách Hàng"),value: "2"),
    ];
    return menuItems;
  }


  String dropdownValue = '0';

  TextEditingController txtYear = TextEditingController(text: DateTime.now().year.toString());
  int _year = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('THU CHI NĂM ' + _year.toString() + ' - TRIỆU VND',
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
                     DropdownButton(
                               dropdownColor: Colors.black,
                               value: dropdownValue,
                               icon: Icon(Icons.arrow_drop_down,color: Colors.blue),
                               iconSize: 14,
                               elevation: 2,
                               style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                               onChanged: (newValue) {
                                 //setState(() {
                                   dropdownValue = newValue as String;
                                   fetchStatPaymentBar(int.parse(dropdownValue) , _year);
                               },
                               items: dropdownItems
                             ),

                     SizedBox(height: 32.0, width: 50.0,
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
                     ),),
                   ]),
               Column(
                 children: <Widget>[
               SizedBox(height: 600.0, width: 500.0,
               child:
                   SfCartesianChart(

                       primaryXAxis: CategoryAxis(),
                       primaryYAxis: NumericAxis(
                         numberFormat: NumberFormat("#,###", "en_US")
                       ),
                       // Chart title
                       //title: ChartTitle(text: 'THỐNG KÊ THU CHI - TRIỆU VND'),
                       // Enable legend
                       legend: Legend(isVisible: true, textStyle: TextStyle(fontSize: 14)),
                       // Enable tooltip
                       tooltipBehavior: TooltipBehavior(enable: true),
                       series: <ChartSeries<_PaymentData, String>>[
                         BarSeries<_PaymentData, String>(
                             dataSource: lstPaymentIncome,
                             xValueMapper: (_PaymentData payment, _) => payment.month,
                             yValueMapper: (_PaymentData payment, _) => payment.money,
                             name: 'Thu',

                             width: 1,
                             //spacing: 1,
                             // Enable data label
    dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 11)),
                         ),

                         BarSeries<_PaymentData, String>(
                             dataSource: lstPaymentOutcome,
                             xValueMapper: (_PaymentData payment, _) => payment.month,
                             yValueMapper: (_PaymentData payment, _) => payment.money,
                             name: 'Chi',
                             // Enable data label
                           width: 1,
                           //spacing: 1,
                           dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 11)),
    )
                       ]))
                 ],
               )
             ])
         );
  }
}

class _PaymentData {
  _PaymentData(this.month, this.money);
  setPayment(double value)
  {
    money = value;
  }

  String month;
  double money;
}