import 'dart:ui';
import 'package:oasisapp/solde.dart';
import 'package:oasisapp/wallet/screen/home.dart';
import 'package:oasisapp/wallet/screen/payment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:oasisapp/tool.dart';
import 'detail_wallet.dart';

class Appro extends StatefulWidget
{
  @override
  _Appro createState() => _Appro();
}
class _Appro extends State<Appro>
{
  int _selectedItemIndex = 0;
  TextEditingController montantUSD = TextEditingController();
  TextEditingController montantCDF = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  String base_url = apiUrl + "";

  bool process = false;
  bool univProcess = false;

  bool valusd = false;
  bool valcdf = false;

  bool isRememberMe = false;
  bool isCDF = false;
  bool isUSD = true;

  bool btn = false;

  Widget _montantUSD(IconData icon, String hint,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: Center(
        child: TextFormField(
          controller: montantUSD,
          style: TextStyle(color: text_color2),
          validator: (value) {
            if (value!.isEmpty)
            {
              return "veuillez entrer le montant";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: text_color2,)),
            prefixIcon: Icon(icon, size: 20, color: text_color2,),
            hintText: hint,
            hintStyle: TextStyle(color: text_color2),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          // textInputAction: inputAction,
        ),
      ),
    );
  }
  Widget _montantCDF(IconData icon, String hint,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Center(
        child: TextFormField(
          controller: montantCDF,
          style: TextStyle(color: text_color2),
          validator: (value) {
            if (value!.isEmpty) {
              // setState(() {
              //   valcdf = true;
              // });
              return "veuillez entrer le montant";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: text_color2,
                )),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: text_color2,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: text_color2),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          // textInputAction: inputAction,
        ),
      ),
      // ),
    );
  }
  Form buildUSD() {
    Size size = MediaQuery
        .of(context)
        .size;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            _montantUSD(
              Icons.dialpad,
              'Montant',
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: size.height * 0.07,
              width: size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kBlue,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                 if (isUSD)
                  {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Payment_cart("USD", montantUSD.text),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  "Valider",
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Form buildCDF() {
    Size size = MediaQuery
        .of(context)
        .size;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            _montantCDF(
              Icons.dialpad,
              'Montant',
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: size.height * 0.07,
              width: size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kBlue,
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: ()
                {
                  if (isCDF)
                  {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Payment_cart("CDF", montantCDF.text),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  "Suivant",
                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    GestureDetector buildNavBarAppro(IconData iconLink, int index, String message) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedItemIndex = index;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 60,
          decoration: index == _selectedItemIndex
              ? BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 4, color: text_color0)),
              gradient: LinearGradient(colors: [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.016),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
              : BoxDecoration(),
          // ignore: deprecated_member_use
          child: RaisedButton(
            padding: EdgeInsets.only(top: 5),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => Appro()),
              );
            },
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                Icon(
                  iconLink,
                  color:
                  index == _selectedItemIndex ? text_color0 : text_color2,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    GestureDetector buildNavBarTrans(IconData iconLink, int index, String message) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedItemIndex = index;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 60,
          decoration: index == _selectedItemIndex
              ? BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 4, color: text_color0)),
              gradient: LinearGradient(colors: [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.016),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
              : BoxDecoration(),
          // ignore: deprecated_member_use
          child: RaisedButton(
            padding: EdgeInsets.only(top: 5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => DetailWalletScreen()),
              );
            },
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                Icon(
                  iconLink,
                  color:
                  index == _selectedItemIndex ? text_color0 : text_color2,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    GestureDetector buildNavBarHome(IconData iconLink, int index, String message) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedItemIndex = index;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 60,
          decoration: index == _selectedItemIndex
              ? BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 4, color: text_color0)),
              gradient: LinearGradient(colors: [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.016),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
              : BoxDecoration(),
          // ignore: deprecated_member_use
          child: RaisedButton(
            padding: EdgeInsets.only(top: 5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => HomeScreen()),
              );
            },
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                Icon(
                  iconLink,
                  color:
                  index == _selectedItemIndex ? text_color0 : text_color2,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    GestureDetector buildNavBarHist(IconData iconLink, int index, String message) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedItemIndex = index;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 60,
          decoration: index == _selectedItemIndex
              ? BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 4, color: text_color0)),
              gradient: LinearGradient(colors: [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.016),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
              : BoxDecoration(),
          // ignore: deprecated_member_use
          child: RaisedButton(
            padding: EdgeInsets.only(top: 5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => Appro()),
              );
            },
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                Icon(
                  iconLink,
                  color:
                  index == _selectedItemIndex ? text_color0 : text_color2,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('Oasis-wallet', style: style_init),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height * 0.8,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Solde(),
              const SizedBox(height: 20,),
              Stack(children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.bounceInOut,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.bounceInOut,
                    height: ((() {
                      if (isUSD) {
                        return size.height * 0.4;
                      }
                      if (isCDF) {
                        return size.height * 0.4;
                      }
                    })()),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isUSD = true;
                                    isCDF = false;

                                    valusd = false;
                                    valcdf = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "USD",
                                      style: TextStyle(
                                          fontSize: taille1,
                                          fontWeight: FontWeight.bold,
                                          color: isUSD
                                              ? text_color0
                                              : text_color2),
                                    ),
                                    if (!isCDF)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: text_color0,
                                      )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isUSD = false;
                                    isCDF = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "CDF",
                                      style: TextStyle(
                                          fontSize: taille1,
                                          fontWeight: FontWeight.bold,
                                          color: isCDF
                                              ? text_color0
                                              : text_color2),
                                    ),
                                    if (!isUSD)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: text_color0,
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (isCDF) buildCDF(),
                          if (isUSD) buildUSD(),
                          isUSD || isCDF
                              ? GestureDetector(
                            onTap: () {
                              ;
                            },
                            child: Container(
                              // width: size.width * 0.6,
                              margin: EdgeInsets.only(top: 10),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: const TextSpan(
                                    text:
                                    "Veuillez effectuer votre approvisionnement ",
                                    style: TextStyle(
                                      color: text_color2,
                                    ),
                                    children: [
                                      TextSpan(
                                        //recognizer: ,
                                        text: "Oasis-Wallet",
                                        style:
                                        TextStyle(color: text_color0),
                                      ),
                                      TextSpan(
                                        //recognizer: ,
                                        text: " en un clic",
                                        style:
                                        TextStyle(color: text_color2),
                                      ),
                                    ]),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: text_color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavBarHome(Icons.home, 3, "Accueil"),
            buildNavBarAppro(Icons.account_balance_wallet, 0, "Appro"),
            buildNavBarTrans(Icons.send, 2, "Pay"),
            buildNavBarHist(Icons.history, 4, "Historique"),
          ],
        ),
      ),
    );
  }
}
