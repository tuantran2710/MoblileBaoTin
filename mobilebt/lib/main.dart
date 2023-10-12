import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';

void main() => runApp(MyApp());
// ColorScheme defaultColorScheme = const ColorScheme(
//   primary: Color(0xffBB86FC),
//   secondary: Color(0xff03DAC6),
//   surface: Color(0xff181818),
//   background: Color(0xff121212),
//   error: Color(0xffCF6679),
//   onPrimary: Color(0xff000000),
//   onSecondary: Color(0xff000000),
//   onSurface: Color(0xffffffff),
//   onBackground: Color(0xffffffff),
//   onError: Color(0xff000000),
//   brightness: Brightness.dark,
// );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản Trị Kho',
      theme: ThemeData(
        //colorScheme: defaultColorScheme,
        primarySwatch: Colors.blue,
      ),
      // home: CompanyStoreList(),
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.blue[50],
        //   elevation: 0.0,
        //   title: Text(
        //     'Đăng Nhập',
        //     style: TextStyle(
        //         fontFamily: 'Helvetica,',
        //         fontWeight: FontWeight.bold,
        //         fontSize: 23),
        //   ),
        //   centerTitle: true,
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           bottomLeft: Radius.circular(15),
        //           bottomRight: Radius.circular(15)),
        //       gradient: LinearGradient(
        //           colors: [Colors.blue, Colors.white],
        //           begin: Alignment.bottomCenter,
        //           end: Alignment.topCenter),
        //     ),
        //   ), systemOverlayStyle: SystemUiOverlayStyle.light,
        // ),
        body: Login(),
      ),
    );
  }
}
