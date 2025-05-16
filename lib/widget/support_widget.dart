import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
class AppWidget{

  static TextStyle boldfeildtextstyle()
  {
    return TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
    );
  }
  static TextStyle lightfeildtextstyle(){
     return TextStyle(
         color: Colors.black,
         fontSize:16.0,
         fontWeight: FontWeight.w500
     );
  }
}