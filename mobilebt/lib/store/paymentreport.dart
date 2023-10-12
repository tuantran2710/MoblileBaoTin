import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentReport extends StatefulWidget {
  const PaymentReport({required this.tokenLogin, required this.income});

  final String tokenLogin;
  final bool income;

  @override
  _PaymentReportState createState() => _PaymentReportState();
}

class _PaymentReportState extends State<PaymentReport> {
  String tokenLogin = "";
  bool income = true;

  final String url = "http://125.253.121.180/CommonService.svc/Payment/";
  final String incomeListUrl = "GetIncomePayments?token=";
  final String outcomeListUrl = "GetOutcomePayments?token=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    income = widget.income;
    if (income == true) {
      title = ' Tổng Hợp Công Nợ Khách Hàng';
    } else {
      title = ' Tổng Hợp Công Nợ Của NCC';
    }
    fetchTickets();
  }
  List<_Data> lstPayment =  <_Data>[];
  List<_Data> lstSource =  <_Data>[];
  String title = "";
  bool isUpdateUI = false;
  void fetchTickets() async {
    isUpdateUI = false;
    var result;
    if (income)
      result = await http.get(Uri.parse(url + incomeListUrl + tokenLogin));
    else
      result = await http.get(Uri.parse(url + outcomeListUrl + tokenLogin));

    List<dynamic> lst = json.decode(result.body)['remain_info'];
    _Data data;
    for(dynamic item in lst)
      {
          data = _Data(item['Code'], item['Name'], '', '');
          data.setCustomer(item);
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
        backgroundColor: Colors.blue,
        title: Text(
          '$title',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
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
      body:
      Column(
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

                        style: TextStyle(color: Colors.black, fontSize: 14),
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
                                fontSize: 14
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
                              if (item.code.toString().contains(value) || item.name.toString().contains(value))
                                lstPayment.add(item);
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
            SizedBox(height: 650.0, width: 520.0,
            child:_listView())
              ],
            )
          ])
    );
  }

  Widget _listView() {
      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: lstPayment.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.grey[300],
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('${lstPayment[index].customer}',
                      style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20) ,),
                    subtitle: Text('${lstPayment[index].data}'),
                  )
                ],
              ),
            );
          });
  }
}

class _Data {
  _Data(this.code, this.name, this.customer, this.data);
  setCustomer(dynamic payments) {
    customer = payments['Code'] + ' - ' + payments['Name'];
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


  setData(dynamic payments) {
    data = (payments['Employee'] == null
        ? ''
        : 'Nhân viên: ' + payments['Employee'] + ' - ') +
        'Thành Tiền: ' +
        format(payments['EndRemain'].toString());
  }
  String code;
  String name;
  String customer;
  String data;
}