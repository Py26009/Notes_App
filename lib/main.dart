import 'package:database_integration/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
   runApp(MyApp());
}
  class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home_page(),
    );

  }
  }