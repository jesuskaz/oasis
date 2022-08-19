import 'dart:ui';
import 'package:oasisapp/screens/homepage.dart';
import 'package:oasisapp/wallet/screen/appro.dart';

import 'package:flutter/material.dart';
import 'package:oasisapp/wallet/component.dart';
import 'package:oasisapp/tool.dart';

import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/wallet/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:oasisapp/catalog/views/home.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../wallet/screen/historique.dart';
import 'navbar.dart';

class List_Entreprise extends StatefulWidget
{
  @override
  _List_EntrepriseState createState() => _List_EntrepriseState();
}

class _List_EntrepriseState extends State<List_Entreprise> with SingleTickerProviderStateMixin
{

  List listData = [];

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
  Future getEntreprise() async {
    String url = apiUrl + "entreprise/all";

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'});

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      listData = r["data"];
    }
    else
    {
      listData = [];
    }
    return listData;
  }

  @override
  Widget build(BuildContext context) {
    setState((){});

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
                MaterialPageRoute(builder: (conetext) => Historique()),
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
      drawer: Container(
        color: Colors.red,
        width: size.width * 0.72,
        child: NavBar(),
      ),
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('Oasis Business', style: style_init),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15,),
          FutureBuilder(
              future: getEntreprise(),
              builder: (BuildContext context, AsyncSnapshot snapshot)
              {
                if (snapshot.data == null) {
                  return Container(
                    height: 400,
                    child: const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          color: text_color,
                        ),
                        height: 40,
                        width: 40,
                      ),
                    ),
                  );
                }
                if (snapshot.data.length <= 0) {
                  return Center(

                    child: const Text('Aucune Entreprise pour le moment',
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        )),
                  );
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListView.builder(
                      itemCount: listData.length,
                      itemBuilder: (BuildContext context, int index)
                      {
                        var ops = listData[index];

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _listCryptoItem(
                                iconUrl: "${ops["logo"]}",
                                titre: "${ops["entreprise"]}",
                                adresse: "${ops["adresse"]}",
                                trans: "${listData[index]["trans_id"]}",
                                id: ops["id"].toString(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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

  Widget _listCryptoItem({required String iconUrl, required String titre, adresse, trans, required String id}) {

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(id)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 9.0),
        child: card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      iconUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  )
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(adresse, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45,),),
                  ],
                ),
              ),
              Icon(
                  Icons.check_circle_rounded,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}