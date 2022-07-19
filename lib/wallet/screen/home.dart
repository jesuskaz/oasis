import 'dart:ui';

import 'package:oasisapp/screens/homepage.dart';
import 'package:oasisapp/solde.dart';

import 'package:oasisapp/wallet/screen/appro.dart';
import 'package:flutter/material.dart';
import 'package:oasisapp/wallet/component.dart';

import 'package:oasisapp/tool.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'appro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oasisapp/catalog/views/home.dart' as homecatalog;
import 'package:oasisapp/screens/homepage.dart' as homepage;
import 'package:sliding_sheet/sliding_sheet.dart';

class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin
{

  List listData = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController montant = TextEditingController();
  String _selectedDevise = '';
  String name_devise = '';

  String qrCode = 'Votre code est inconnu';
  bool process = false;
  List listDevise = [];

  String token = '';
  late ProgressDialog progressDialog;

  late AnimationController animationController;
  late Animation degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  late Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    getTransaction();
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController
        , curve: Curves.easeOut));
    super.initState();
    animationController.addListener((){
      setState(() {

      });
    });
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
  Future payment(String compte) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token").toString();

    String url = apiUrl + "transfert";
    showProgress();

    var res = await http.post(Uri.parse(url),headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    },
        body: {
          "numero_compte": compte,
          "montant": montant.text,
          "devise_id": _selectedDevise.toString()
        });

    progressDialog.dismiss();

    if (res.statusCode == 200)
    {
      AlertDialog alert = AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text(
                "Message",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                "Votre Paiement a été effectué avec succès",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // ignore: deprecated_member_use
          RaisedButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context);
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

      }
  }
  _montant(String compte) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Paiement Courses"),
              content: Column(
                mainAxisSize:MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                        "Effectuez votre paiement à ce N° de Compte : ${qrCode}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: text_color3
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      height: 50,
                      child: TextFormField(
                        controller: montant,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer le montant';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Montant',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                      ),
                    ),
                  ),
                  _devise(
                    Icons.dialpad,
                    'Votre devise',
                  ),
                ],
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("Quitter"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("Confirmer"),
                  textColor: Colors.white,
                  color: Colors.orange,
                  onPressed: () {

                    if (_formKey.currentState!.validate())
                    {
                      AlertDialog alert = AlertDialog(
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              const Text(
                                "Confirmer Paiement",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                "Voulez-vous confirmer le paiement de ${montant.text} ${name_devise}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                            padding: EdgeInsets.all(10),
                            onPressed: ()
                            {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: const Text(
                              'Annuler',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              Navigator.of(context).pop();
                              payment(compte);
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
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future getDevise() async {

    String url = apiUrl + "devise";

    setState(() {
      process = true;
    });

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      if(r["status"] == true)
      {
        setState(() {
          listDevise = r["data"];
          if(listDevise.length > 0)
            {
              _selectedDevise = listDevise[0]["id"].toString();
            }
        });
      }
    }
    setState(() {
      process = false;
    });
  }
  Widget _devise(IconData icon, String hint) {
    return Container(
      //gauche, haut, doit, bas
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 1.0, 0.0),
      child:Row(
        children: <Widget>[
          Expanded(
              child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    // alignedDropdown: true,
                    child: listDevise.length > 0
                        ? DropdownButtonFormField(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: _selectedDevise == null &&
                            listDevise.length == 0
                            ? Colors.grey
                            : Colors.black,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: text_color2,
                          ),
                        ),
                        hintStyle: TextStyle(color: text_color2),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(2.0),
                      ),
                      isDense: true,
                      isExpanded: true,
                      hint: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Choisissez votre université",
                          style: TextStyle(
                              color: listDevise.length > 0
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                      ),
                      value: int.parse(_selectedDevise),
                      items: listDevise.map((devise)
                      {
                        name_devise = devise["devise"];
                        return DropdownMenuItem(
                            value: devise["id"],
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(devise["devise"]),
                                ),
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDevise = value.toString();
                        });
                      },
                      validator: (value)
                      {
                        if (value == null) {
                          return 'Veullez selectionner votre universié';
                        } else {
                          return null;
                        }
                      },
                    )
                        : Container(),
                  )))
        ],
      ),
    );
  }
  Future getTransaction() async {
    String url = apiUrl + "transaction/5";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'});

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      print("DATA IS ::: $r");

      setState(() {
        listData = r["data"];
      });
    }
    return listData;
  }
  @override
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      print("QR CODE ::: ${this.qrCode}");
        if(this.qrCode != null && this.qrCode != -1)
          {
            this.qrCode = qrCode;
            _montant(qrCode);
          }
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int _selectedItemIndex = 0;

    Widget buildHeader(BuildContext context, SheetState state) => Material(
      child: Container(
        color: Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16,),
            Center(
              child: Container(
                width: 32,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
    Widget buildSheet(context, state) => Material(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            child: const Text(
              "Veuillez spécifier la quantité à commander",
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: taille2,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF575E67)
              ),
            ),
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                height: 50,
                width: 50,
                child: Icon(Icons.qr_code, size: 20, color: Colors.white,),
              ),
              title: const Text(
                "Paiement Course",
                style: TextStyle(fontWeight: FontWeight.bold),
               ),
            ),
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              scanQRCode();
            },
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                height: 50,
                width: 50,
                child: Icon(Icons.send_outlined, size: 20, color: Colors.white,),
              ),
              title: const Text(
                "Paiement Commande",
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ],
      ),
    );
    Future showSheet() => showSlidingBottomSheet(context, builder: (context) => SlidingSheetDialog(
      cornerRadius: 16,
      avoidStatusBar: true,
      snapSpec: const SnapSpec(
          initialSnap: 1,
          snappings: [0.4, 0.7, 0.9]
      ),
      builder: buildSheet,
      headerBuilder: buildHeader,
    ));
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
            onPressed: ()
            {
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
                  color: index == _selectedItemIndex ? text_color0 : text_color2,),
                Text(message, style: TextStyle(color: Colors.grey),),
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
            onPressed: ()
            {
              showSheet();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (conetext) => Pay()),
              // );
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
              Navigator.of(context).pop();
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
                Icon(iconLink, color:
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
      body: Column(
        children: [
          SizedBox(height: 10,),
          Solde(),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opérations Récentes',
                    style: TextStyle(
                        color: Colors.black45,
                      fontWeight: FontWeight.bold
                    )),
                Row(children: const [
                  Text(
                    'Plus',
                     style: TextStyle(
                        color: Colors.green,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.green),
                ])
              ],
            ),
          ),
          const SizedBox(height: 15,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView.builder(
              itemCount: listData.length,
              itemBuilder: (BuildContext context, int index)
              {
                if(listData.length == 0)
                {
                  // ignore: prefer_const_constructors
                  return Center(
                    child: const Text('Aucune Opération',
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        )),
                  );
                }
                else
                {
                  var ops = listData[index]["operateur"];
                  String operateur = '';

                  if(ops != null)
                  {
                    var op = ops["operateur"].toString().toLowerCase();
                    switch (op)
                    {
                      case "visa":
                        operateur = "images/mastercard.png";
                        break;
                      case "mastercard":
                        operateur = "images/mastercard.png";
                        break;
                      case "illico cash":
                        operateur = "images/mastercard.png";
                        break;
                      case "m-pesa":
                        operateur = "images/vodacom.png";
                        break;
                      case "airtel money":
                        operateur = "images/airtel.png";
                        break;
                      case "orange money":
                        operateur = "images/orange.png";
                        break;
                      default:
                        operateur = "oasis pay";
                    }
                  }
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _listCryptoItem(
                          iconUrl: operateur,
                          myCrypto: "${listData[index]["montant"]}",
                          myBalance: "${listData[index]["type"]}",
                          myProfit: "${listData[index]["trans_id"]}",
                          precent: "Appro",
                        ),
                      ],
                    ),
                  );
                }
              },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
              right: 10,
              bottom: 10,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225),degTwoTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: text_color3,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => homepage.HomePage()));
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180),degThreeTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degThreeTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: Colors.orangeAccent,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.add_business_rounded,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const homecatalog.Home()));
                        },
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: CircularButton(
                      color: text_color,
                      width: 50,
                      height: 50,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onClick: ()
                      {
                        if (animationController.isCompleted)
                        {
                          animationController.reverse();
                        }
                        else
                        {
                          animationController.forward();
                        }
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
      bottomNavigationBar: Container(
        color: text_color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavBarHome(Icons.home, 0, "Accueil"),
            buildNavBarAppro(Icons.account_balance_wallet, 1, "Appro"),
            buildNavBarTrans(Icons.send, 2, "Pay"),
            buildNavBarHist(Icons.history, 3, "Historique"),
          ],
        ),
      ),
    );
  }
  Widget _listCryptoItem({required String iconUrl, required String precent, required String myCrypto, myBalance, myProfit}) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(iconUrl != '' ? iconUrl : 'images/logo.png',
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
                    myCrypto,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
          ],
        ),
      ),
    );
  }
}