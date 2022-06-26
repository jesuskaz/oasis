import 'package:flutter/material.dart';

Widget card({double width = double.infinity, double padding = 20, required Widget child}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: child,
  );
}
Widget cardUSD({double width = double.infinity, double padding = 20, required Widget child}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: child,
  );
}
Widget cardCDF({double width = double.infinity, double padding = 20, required Widget child}) {
  return Container(
    width: width,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: child,
  );
}