import 'dart:convert';

import 'package:oasisapp/wallet/component/appBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tool.dart';
import 'appro.dart';
import 'detail_wallet.dart';
import 'home.dart';


class Payment_cart extends StatefulWidget
{
  String devise;
  String montant;

  Payment_cart(this.devise, this.montant, {Key? key}) : super(key: key);

  @override
  State<Payment_cart> createState() => _Payment_cartState();
}

class _Payment_cartState extends State<Payment_cart>
{
  List listData = [];
  late ProgressDialog progressDialog;
  late int id_f = 0;
  late SharedPreferences preferences;

  Future getOperateur() async {
    String url = apiUrl + "operateur";
    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    var rep;

    if(response.statusCode == 200)
      {
        var r = jsonDecode(response.body);
        rep = r;
      }
    return rep ?? [];
  }

  Future getDevise() async {
    String url = apiUrl + "devise";
    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      listData = r["data"];
      if(listData.isNotEmpty)
      {
        setState(() {
          for(int i=0; i < listData.length; i++)
          {
            if(listData[i]["devise"] == widget.devise)
            {
              id_f = listData[i]["id"];
            }
          }
        });
      }
    }
  }
  @override
  initState() {
    getDevise();
    super.initState();
  }
  showProgress() {
    progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: "Traitement en cours",
    );
    progressDialog.show();
  }
  hideProgress() {
    progressDialog.dismiss();
  }

  Future appro(int operateur_id) async {
    var data = {
      "operateur_id": operateur_id.toString(),
      "devise_id": id_f.toString(),
      "montant": widget.montant,
      "source": "appro"
    };

    print("DATA ::: $data ===");


    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    showProgress();
    var res = await http.post(Uri.parse(apiUrl+"appro"), headers: <String, String>{
          'Authorization': "Bearer ${token}",'Accept': 'application/json; charset=UTF-8',},
        body: data);

    progressDialog.dismiss();
    debugPrint("MESSAGE ::: ${res.body}");
    if(res.statusCode == 200)
      {
        var data = jsonDecode(res.body);
        Fluttertoast.showToast(
            msg: " Votre approvisionnement a été éffectué avec succès",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: Colors.grey);
        AlertDialog alert = AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "${data["message"]}",
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              color: text_color,
              textColor: Colors.white,
              child: const Text(
                'Ok',
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
      }
    else
      {
        Fluttertoast.showToast(
            msg: "Votre Approvisionnement a échoué",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: Colors.grey);
      }
  }
  showAlertDialog(BuildContext context) {
    // ignore: deprecated_member_use
    Widget cancelButton = RaisedButton(
      padding: EdgeInsets.all(10),
      onPressed: () {
        AlertDialog alert = AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
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
              color: text_color,
              textColor: Colors.white,
              child: const Text(
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
              color: text_color,
              textColor: Colors.white,
              child: const Text(
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
      color: text_color,
      textColor: Colors.white,
      child: const Text(
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
        await appro(2);
      },
      color: text_color,
      textColor: Colors.white,
      child: const Text(
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
            const Text(
              "Voulez-vous confirmer cet approvisionnement ?",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10,),
            const Text(
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
    int _selectedItemIndex = 0;

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
    
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('Oasis-wallet', style: style_init),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            // width: size.width * 0.6,
            margin: EdgeInsets.all(10),
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                  text:
                  "Veuillez choisir votre mode d'approvisionnement pour ",
                  style: TextStyle(
                    color: text_color2,
                    fontSize: taille0
                  ),
                  children: [
                    TextSpan(
                      //recognizer: ,
                      text: "Oasis-Wallet",
                      style:
                      TextStyle(color: text_color0, fontSize: taille1),
                    ),
                  ]),
            ),
          ),
          SizedBox(height: 12.0),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                width: MediaQuery.of(context).size.width - 200.0,
                height: MediaQuery.of(context).size.height - 20,
                child: GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.9,
                  children: <Widget>[
                    _buildCard('images/vodacom.png', context),
                    _buildCard('images/airtel.png', context),
                    _buildCard('images/mastercard.png', context),
                    _buildCard('images/orange.png', context),
                  ],
                )),
          ),
          // SizedBox(height: 15.0)
        ],
      ),
      bottomNavigationBar: Container(
        color: text_color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavBarAppro(Icons.account_balance_wallet, 0, "Appro"),
            buildNavBarTrans(Icons.send, 2, "Pay"),
            buildNavBarHome(Icons.home, 3, "Accueil"),
            buildNavBarHist(Icons.history, 4, "Historique"),
          ],
        ),
      ),
    );
  }
  Widget _buildCard(String imgPath, context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white),
            child: Column(children: [
              InkWell(
                onTap: ()
                {
                  showAlertDialog(context);
                },
                child: Hero(
                    tag: imgPath,
                    child: Container(
                        height: 160.0,
                        width: 75.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(imgPath),
                                fit: BoxFit.contain)))),
              ),
              SizedBox(height: 7.0),
              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
              const Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),)
            ])));
  }

}