import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class StatStoreKg extends StatefulWidget {
  const StatStoreKg({required this.tokenLogin, required this.storeSubId});
  final String tokenLogin;
  final int storeSubId;

  @override
  _StatStoreKgState createState() => _StatStoreKgState();
}

class _StatStoreKgState extends State<StatStoreKg> {
  List<_ValueData> lstKgIn =  <_ValueData>[];
  List<_ValueData> lstKgOut = <_ValueData>[];


  String tokenLogin = "";
  int storeSubId = 0;
  final String url = "http://125.253.121.180/CommonService.svc/Store/";
  final String StatStoreKgUrl = "GetStatStoreKgBoth?token=";
  final String activeStoresUrl = "GetActiveStores?token=";


  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    storeSubId = widget.storeSubId;
    _lstStore = fetchActiveStores();
    _ValueData data;
    for(int i=1;i<13;i++)
    {
      data = new _ValueData(i<10?'0' + i.toString():i.toString(), 0);
      lstKgIn.add(data);
      data = new _ValueData(i<10?'0' + i.toString():i.toString(), 0);
      lstKgOut.add(data);
    }
  }
  bool isUpdateUI = false;
  void fetchStatStoreKg(int storeId, int year) async {
    isUpdateUI = false;
    var result = await http.get(Uri.parse(url + StatStoreKgUrl + tokenLogin + "&storeSubId=" + storeSubId.toString() +
        "&storeId=" + storeId.toString() + "&year=" + year.toString()));
    List<dynamic> lst = json.decode(result.body)['statstores'];
    _ValueData data;
    for(int i=0;i<12;i++)
      {
        lstKgIn[i].value = 0;
        lstKgOut[i].value = 0;
      }

    num value;
    for(dynamic item in lst)
      {
        value = item['Kg'];
        //data = new _ValueData(item['Month'] as String, item['kg'] as int);
        if (item['isIn'].toString().toLowerCase()=='true') {
          lstKgIn[int.parse(item['Month']) - 1].value = value;
        }
        else {
          lstKgOut[int.parse(item['Month']) - 1].value = value;
        }
      }

    isUpdateUI = true;
    setState(() {
      if (isUpdateUI);
    });

  }

  late Future<List<String>> _lstStore;
  Future<List<String>> fetchActiveStores() async {
    //if (dropdownValue.length > 0) return null;
    var result = await http.get(Uri.parse(url + activeStoresUrl + tokenLogin + "&storeSubId=" + storeSubId.toString()));
    List<dynamic> lst = json.decode(result.body)['activeStores'];

    List<String> lstResult = <String>[];
    for (int i = 0; i < lst.length; i++) {
      lstResult.add(lst[i]["id"].toString() +
          '-' +
          lst[i]["name"].toString());
    }
    setState(() {
      if (lstResult.length>0) {
        dropdownValue = lstResult[0];
        storeName = _storeName(dropdownValue);
        fetchStatStoreKg(_storeId(dropdownValue), _year);
      }
    });
    return lstResult;
  }


  String dropdownValue = '', storeName = '';
  int _storeId(String val) {
    return int.parse(val.substring(0, val.indexOf("-")));
  }

  String _storeName(String val) {
    return val.substring(val.indexOf("-")+1);
  }

  TextEditingController txtYear = TextEditingController(text: DateTime.now().year.toString());
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('THỐNG KÊ ' + storeName.toUpperCase() + ' NĂM ' + _year.toString(),
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
                     FutureBuilder<List<String>>(
                       future: _lstStore,
                       builder: (context, snapshot) {
                         if (snapshot.hasData) {
                           return
                             DropdownButton(
                               dropdownColor: Colors.black,
                               value: dropdownValue,
                               icon: Icon(Icons.arrow_drop_down,color: Colors.blue),
                               iconSize: 14,
                               elevation: 2,
                               style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                               onChanged: (newValue) {
                                   dropdownValue = newValue as String;
                                   storeName = _storeName(dropdownValue);
                                   fetchStatStoreKg(_storeId(dropdownValue) , _year);
                               },
                               items: snapshot.data?.map<DropdownMenuItem<String>>((String value) {
                                 return DropdownMenuItem<String>(
                                   value: value,
                                   child: Text(value),
                                 );
                               }).toList(),
                             );
                         } else if (snapshot.hasError) {
                           return Text("${snapshot.error}");
                         }
                         return CircularProgressIndicator();
                       },
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
                           numberFormat: NumberFormat("#,###.##", "en_US")
                       ),

                       // Chart title
                       title: ChartTitle(text: 'THỐNG KÊ NHẬP XUẤT KHỐI LƯỢNG'),
                       // Enable legend
                       legend: Legend(isVisible: true),
                       // Enable tooltip
                       tooltipBehavior: TooltipBehavior(enable: true),
                       series: <ChartSeries<_ValueData, String>>[
                         BarSeries<_ValueData, String>(
                             dataSource: lstKgIn,
                             xValueMapper: (_ValueData kg, _) => kg.month,
                             yValueMapper: (_ValueData kg, _) => kg.value,
                             name: 'Nhập',
                           width: 1,
                           //spacing: 1,
                           dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 11)),

                         ),

                         BarSeries<_ValueData, String>(
                             dataSource: lstKgOut,
                             xValueMapper: (_ValueData kg, _) => kg.month,
                             yValueMapper: (_ValueData kg, _) => kg.value,
                             name: 'Xuất',
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

class _ValueData {
  _ValueData(this.month, this.value);
  setkg(num value)
  {
    value = value;
  }

  String month;
  num value;
}