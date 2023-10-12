import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class StatStoreBottomProduct extends StatefulWidget {
  const StatStoreBottomProduct({required this.tokenLogin, required this.storeSubId});
  final String tokenLogin;
  final int storeSubId;

  @override
  _StatStoreBottomProductState createState() => _StatStoreBottomProductState();
}

class _StatStoreBottomProductState extends State<StatStoreBottomProduct> {
  List<_ValueData> lstProductTopTree =  <_ValueData>[];
  List<_ValueData> lstProductTopKg = <_ValueData>[];


  String tokenLogin = "";
  int storeSubId = 0;
  final String url = "http://125.253.121.180/CommonService.svc/";
  final String StatStoreBottomProductUrl = "Product/GetListStatProductTopTree?token=";
  final String StatStoreBottomProductKgUrl = "Product/GetListStatProductTopKg?token=";
  final String activeStoresUrl = "Store/GetActiveStores?token=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    storeSubId = widget.storeSubId;
    _lstStore = fetchActiveStores();
  }

  bool isUpdateUI = false;
  void fetchStatStoreBottomProduct(int storeId, int year, int top) async {
    isUpdateUI = false;
    _ValueData data;
    lstProductTopTree.clear();
    lstProductTopKg.clear();

    var result = await http.get(Uri.parse(url + StatStoreBottomProductUrl + tokenLogin + "&storeSubId=" + storeSubId.toString() +
        "&storeId=" + storeId.toString() + "&time=" + year.toString() + "&top=" + top.toString() + "&isYear=true&isTop=false"));
    List<dynamic> lst = json.decode(result.body)['statproducts'];
    num totalTree = 0;
    num totalKg = 0;
    num value = 0;
    for(dynamic item in lst) {
      value = item['Tree'];
      totalTree += value;
      lstProductTopTree.add(new _ValueData(item['DisplayName'], value, 0));
    }
    for(int i=0;i<lstProductTopTree.length;i++)
      lstProductTopTree[i].percent = double.parse((100*lstProductTopTree[i].value/totalTree).toStringAsFixed(2));

    result = await http.get(Uri.parse(url + StatStoreBottomProductKgUrl + tokenLogin + "&storeSubId=" + storeSubId.toString() +
        "&storeId=" + storeId.toString() + "&time=" + year.toString() + "&top=" + top.toString() + "&isYear=true&isTop=false"));
    lst = json.decode(result.body)['statproducts'];
    for(dynamic item in lst) {
      value = item['Kg'];
      totalKg += value;
      lstProductTopKg.add(new _ValueData(item['DisplayName'], value, 0));
    }
    for(int i=0;i<lstProductTopKg.length;i++)
      lstProductTopKg[i].percent = double.parse((100*lstProductTopKg[i].value/totalKg).toStringAsFixed(2));



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
      if (lstResult.length > 0) {
        dropdownValue = lstResult[0];
        storeName = _storeName(dropdownValue);
        fetchStatStoreBottomProduct(_storeId(dropdownValue) , _year, _top);
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
  TextEditingController txtTop = TextEditingController(text: '3');
  int _year = DateTime.now().year;
  int _top = 3;
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
                                   fetchStatStoreBottomProduct(_storeId(dropdownValue) , _year, _top);
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
                         style: TextStyle(color: Colors.blue,fontSize: 14, fontWeight: FontWeight.bold),
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
                     SizedBox(height: 32.0, width: 50.0,
                       child:
                       TextFormField(
                         style: TextStyle(color: Colors.blue,fontSize: 14, fontWeight: FontWeight.bold),
                         controller: txtTop,
                         decoration: InputDecoration(
                             border: InputBorder.none,
                             hintText: 'Ít Nhất',
                             hintStyle: TextStyle(
                                 color: Colors.blue,
                                 //fontFamily: 'Helvetica',
                                 fontSize: 14, fontWeight: FontWeight.bold
                             )),
                         onChanged: (value) {
                           try {
                             _top = int.parse(value);
                           }catch(Exception){_top = 3;}

                         },
                       ),),
                   ]),
               Column(
                 children: <Widget>[
                   SfCircularChart(
                     // Chart title
                       title: ChartTitle(text: 'THỐNG KÊ S.L ÍT NHẤT'),
                       // Enable legend
                       legend: Legend(isVisible: true),
                       // Enable tooltip
                       tooltipBehavior: TooltipBehavior(enable: true),
                       series: <CircularSeries<_ValueData, String>>[
                         PieSeries<_ValueData, String>(
                             dataSource: lstProductTopTree,
                             xValueMapper: (_ValueData treeData, _) => treeData.product,
                             yValueMapper: (_ValueData treeData, _) => treeData.percent,
                             // Enable data label
                             dataLabelSettings: DataLabelSettings(isVisible: true)
                         )
                       ]),
                   SfCircularChart(
                     // Chart title
                       title: ChartTitle(text: 'THỐNG KÊ K.L ÍT NHẤT'),
                       // Enable legend
                       legend: Legend(isVisible: true),
                       // Enable tooltip
                       tooltipBehavior: TooltipBehavior(enable: true),
                       series: <CircularSeries<_ValueData, String>>[
                         PieSeries<_ValueData, String>(
                             dataSource: lstProductTopKg,
                             xValueMapper: (_ValueData kgData, _) => kgData.product,
                             yValueMapper: (_ValueData kgData, _) => kgData.percent,
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

class _ValueData {
  _ValueData(this.product, this.value, this.percent);

  String product;
  num value;
  double percent;
}