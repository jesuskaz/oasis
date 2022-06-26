import 'dart:convert';
import 'dart:ui';
import 'package:chat_project/catalog/views/home.dart';
import 'package:chat_project/solde.dart';
import 'package:chat_project/wallet/component/appBar.dart';
import 'package:chat_project/wallet/component/card.dart';
import 'package:chat_project/wallet/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:chat_project/tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appro.dart';
import 'detail_wallet.dart';

class Pay extends StatefulWidget {
  @override
  _Pay createState() => _Pay();
}
class _Pay extends State<Pay>
{
  int _selectedItemIndex = 0;
  TextEditingController montantUSD = TextEditingController();
  TextEditingController montantCDF = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ProgressDialog progressDialog;

  // ignore: non_constant_identifier_names
  // String base_url = apiUrl + "";

  bool process = false;
  bool univProcess = false;
  bool _autovalidate = false;

  bool valusd = false;
  bool valcdf = false;

  bool isRememberMe = false;
  bool isCDF = false;
  bool isUSD = true;
  bool btn = false;

  late http.Response response;
  int quantitee = 0;

  showProgress() {
    progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: "Traitement en cours",
    );
    progressDialog.show();
  }
  Future passerCommande() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    showProgress();
    var res = await http.post(
        Uri.parse(apiUrl+"commande"),
        headers: <String, String>{
          'Authorization': "Bearer ${token}",'Accept': 'application/json; charset=UTF-8',
        },);

    progressDialog.dismiss();

    if(res.statusCode == 200)
    {
      var data = jsonDecode(res.body);

      if(data["status"] == false)
      {
        AlertDialog alert = AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "${data["message"]}",
                ),
                SizedBox(height: 3,),
                Text(
                  "${data["data"]["errors_msg"]}",
                ),
              ],
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: const Text(
                'Continuer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      }
      else
        {
          AlertDialog alert = AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    "${data["message"]}",
                  ),
                  SizedBox(height: 3,),
                ],
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.orange,
                textColor: Colors.white,
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                },
                color: Colors.orange,
                textColor: Colors.white,
                child: const Text(
                  'Continuer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              });
        }
    }
    else
    {
      Fluttertoast.showToast(
          msg: " La Commande a échoué",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.grey);
    }
  }
  Future getQuantite() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();
    var d;
    var liste;

    String url = apiUrl + "panier";
    response = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200)
    {
       d = jsonDecode(response.body);
       liste = d["data"]["panier"];
    }
    return liste;
  }
  showAlertDialog(BuildContext context) {
    // ignore: deprecated_member_use
    Widget cancelButton = RaisedButton(
      padding: EdgeInsets.all(10),
      onPressed: () {
        AlertDialog alert = AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Voulez-vous retourner ? ",
                ),
              ],
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: Text(
                'NON',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: Text(
                'OUI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      },
      color: Colors.orange,
      textColor: Colors.white,
      child: Text(
        'RETOUR',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // ignore: deprecated_member_use
    Widget continueButton = RaisedButton(
      padding: EdgeInsets.all(10),
      onPressed: () async {
        Navigator.pop(context);
        await passerCommande();
      },
      color: Colors.orange,
      textColor: Colors.white,
      child: Text(
        'CONFIRMER L\'APPRO',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              "Voulez-vous confirmer cet approvisionnement ?",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Cliquez sur confirmer pour effectuer votre paiement",
              style: TextStyle(
                  color: text_color3
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 4),
              child: continueButton,
            ),
            cancelButton
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        });
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
    final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height * 0.9,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Solde(),
              SizedBox(height: 20,),
              Container(
                child: Stack(children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.bounceInOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      curve: Curves.bounceInOut,
                      height: size.height * 0.5,
                      padding: EdgeInsets.all(20),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
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
                                GestureDetector(
                              onTap: () {
                                ;
                              },
                              child: Container(
                                // width: size.width * 0.6,
                                margin: EdgeInsets.only(top: 10),
                                child: RichText(
                                  textAlign: TextAlign.justify, text: const TextSpan(
                                      text:
                                      "Commande en processus avec ",
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
                                      ]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: FutureBuilder(
                                future: getQuantite(),
                                builder: (BuildContext context, AsyncSnapshot snapshot)
                                {
                                  if (!snapshot.hasData)
                                  {
                                    return Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                color: Colors.orange,
                                              ),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ],
                                        ));
                                  }
                                  else
                                    {
                                      return const Text("ok"
                                      //   "Article : ${snapshot.data[0]["article"]} - \n\nQuantités: ${snapshot.data[0]["qte"]} \nPrix-Unitaire: ${snapshot.data[0]["prix"]} \nPrix-Total: ${snapshot.data[0]["total"]} \n",
                                      //   style: const TextStyle(
                                      //       color: color_orange,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 16),
                                      //   textAlign: TextAlign.center,
                                      );
                                    }
                                },
                              ),
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
                                  passerCommande();
                                },
                                child: Text(
                                  "Confirmer la Commande",
                                  style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
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
  Widget _listCryptoItem({required String iconUrl, double precent = 0, required String myCrypto, myBalance, myProfit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              '$iconUrl',
              width: 50,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$myCrypto',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '$myProfit',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$myBalance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  precent >= 0 ? '+ $precent %' : '$precent %',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: precent >= 0 ? Colors.green : Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
