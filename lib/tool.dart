import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const Color text_color0 = Color(0xff154a99);
// const Color text_color0 = Color(0xffeead41);
const Color text_color = Color(0xff154a99);

const Color text_color1 = Colors.white70;
const Color text_color2 = Colors.grey;
const Color text_color3 = Colors.green;
const Color text_color4 = Colors.blueAccent;
const Color kBlue = Color(0xff154a99);

const Color color_grey = Colors.grey;
const Color color_white = Colors.white;
const Color color_red = Colors.red;

const TextStyle kBodyText = TextStyle(fontSize: 18, color: Colors.white, height: 1.5);
const TextStyle style_init = TextStyle(fontFamily: 'Varela', fontSize: 18.0, color: color_white, fontWeight: FontWeight.bold);
const TextStyle style_init1 = TextStyle(fontFamily: 'Varela', fontSize: 18.0, color: text_color2, fontWeight: FontWeight.bold);

//Predefine size

const double taille0 = 15;
const double taille1 = 20;
const double taille2 = 15;
const double taille3 = 12;

// Credential
const appId = "cc5315fdd98a42d98dbad2f476b74d10";
const token = "007eJxTYHjgZcsVOq01ZQq7l+pk4WtRn/uZl3M2ME8uaZL+fnCd2GsFhuRkU2ND07SUFEuLRBMjIJmSlJhilGZibpZkbpJiaKD4Ryd5ga9ecj+HDSMjAwSC+BwM+YnFmcWJBQUMDABIeiA2";

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
// Box Color
final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFFC6B299).withOpacity(0.3),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2)
      )
    ]
);
final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const apiUrl = "http://192.168.43.3:8000/api/";
// const apiUrl = "http://192.168.1.110:8000/api/";
// const apiUrl = "http://192.168.1.107:8000/api/";
// const apiUrl = "https://oasisapp.tech/api/";

const ressourceBasePath = apiUrl;

userHeaders() async
{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var apiToken = preferences.getString("token");
  return {'token': "$apiToken", 'Accept': 'application/json'};
}