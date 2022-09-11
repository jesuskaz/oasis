import 'dart:ui';
import 'package:oasisapp/catalog/views/edit_entreprise/edit_entreprise.dart';
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

class Mes_Entreprise extends StatefulWidget
{
  @override
  _Mes_EntrepriseState createState() => _Mes_EntrepriseState();
}

class _Mes_EntrepriseState extends State<Mes_Entreprise> with SingleTickerProviderStateMixin
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

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('Oasis Business', style: style_init),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height * 1,
          child:  FutureBuilder(
              future: getEntreprise(),
              builder: (BuildContext context, AsyncSnapshot snapshot)
              {
                if (snapshot.data == null) {
                  return Container(
                    height: 50,
                    child: Center(
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
                return RefreshIndicator(
                  // displacement: 250,
                  backgroundColor: text_color0,
                  color: Colors.white,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 1500));
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            "Veuillez apporter une modification a vos entreprises",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          child: ListView.builder(
                            itemCount: listData.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()
                            ),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index)
                            {
                              var ops = listData[index];
                              return Container(
                                child: _listCryptoItem(
                                  iconUrl: "${ops["logo"]}",
                                  titre: "${ops["entreprise"]}",
                                  adresse: "${ops["adresse"]}",
                                  trans: "${listData[index]["trans_id"]}",
                                  id: ops["id"].toString(),
                                  phone: ops["telephone"],
                                  email: ops["email"],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        ),
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
    );
  }

  Widget _listCryptoItem({required String iconUrl, required String titre, adresse, trans, required String id, phone, email}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Entreprise(id)));
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
              // Icon(
              //     Icons.check_circle_rounded,
              //   color: Colors.green,
              // )
            ],
          ),
        ),
      ),
    );
  }
}