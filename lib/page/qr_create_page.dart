import 'package:barcode_widget/barcode_widget.dart';
import 'package:chat_project/wallet/component/appBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../tool.dart';

class QRCreatePage extends StatefulWidget
{
  String numero_compte;
  QRCreatePage(this.numero_compte);

  @override
  _QRCreatePageState createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage>
{

  bool process = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SafeArea(
          child: appBar(
              left: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.black54)),
              title: 'Oasis-Wallet',
              right: Icon(Icons.more_vert, color: Colors.black54)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarcodeWidget(
                barcode: Barcode.qrCode(),
                color: text_color4,
                data: widget.numero_compte,
                width: 200,
                height: 200,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
