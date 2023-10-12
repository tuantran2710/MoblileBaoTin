import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class StatStoreTree extends StatefulWidget {
  const StatStoreTree({required this.tokenLogin, required this.storeSubId});
  final String tokenLogin;
  final int storeSubId;

  @override
  _StatStoreTreeState createState() => _StatStoreTreeState();
}

class _StatStoreTreeState extends State<StatStoreTree> {
  List<_TreeData> lstTreeIn =  <_TreeData>[];
  List<_TreeData> lstTreeOut = <_TreeData>[];


  String tokenLogin = "";
  int storeSubId = 0;
  final String url = "http://125.253.121.180/CommonService.svc/Store/";
  final String StatStoreTreeUrl = "GetStatStoreTreeBoth?token=";
  final String activeStoresUrl = "GetActiveStores?token=";

  @override
  void initState() {
    super.initState();
    tokenLogin = widget.tokenLogin;
    storeSubId = widget.storeSubId;
    _lstStore = fetchActiveStores();
    _TreeData data;
    for(int i=1;i<13;i++)
    {
      data = new _TreeData(i<10?'0' + i.toString():i.toString(), 0);
      lstTreeIn.add(data);
      data = new _TreeData(i<10?'0' + i.toString():i.toString(), 0);
      lstTreeOut.add(data);
    }
  }

  bool isUpdateUI = false;
  void fetchStatStoreTree(int storeId, int year) async {
    isUpdateUI = false;
    var result = await http.get(Uri.parse(url + StatStoreTreeUrl + tokenLogin + "&storeSubId=" + storeSubId.toString() +
        "&storeId=" + storeId.toString() + "&year=" + year.toString()));
    List<dynamic> lst = json.decode(result.body)['statstores'];
    _TreeData data;
    for(int i=0;i<12;i++)
      {
        lstTreeIn[i].tree = 0;
        lstTreeOut[i].tree = 0;
      }
    for(dynamic item in lst)
      {
        //data = new _TreeData(item['Month'] as String, item['Tree'] as int);
        if (item['isIn'].toString().toLowerCase()=='true')
            lstTreeIn[int.parse(item['Month'])-1].tree = item['Tree'] as int;
        else
          lstTreeOut[int.parse(item['Month'])-1].tree = item['Tree'] as int;
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
        fetchStatStoreTree(_storeId(dropdownValue), _year);
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
                                   fetchStatStoreTree(_storeId(dropdownValue) , _year);
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
                       title: ChartTitle(text: 'THỐNG KÊ NHẬP XUẤT SỐ LƯỢNG'),
                       // Enable legend
                       legend: Legend(isVisible: true),
                       // Enable tooltip
                       tooltipBehavior: TooltipBehavior(enable: true),
                       series: <ChartSeries<_TreeData, String>>[
                         BarSeries<_TreeData, String>(
                             dataSource: lstTreeIn,
                             xValueMapper: (_TreeData tree, _) => tree.month,
                             yValueMapper: (_TreeData tree, _) => tree.tree,
                             name: 'Nhập',
                           width: 1,
                           //spacing: 1,
                           dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 11)),

                         ),

                         BarSeries<_TreeData, String>(
                             dataSource: lstTreeOut,
                             xValueMapper: (_TreeData tree, _) => tree.month,
                             yValueMapper: (_TreeData tree, _) => tree.tree,
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

class _TreeData {
  _TreeData(this.month, this.tree);
  setTree(int value)
  {
    tree = value;
  }

  String month;
  int tree;
}