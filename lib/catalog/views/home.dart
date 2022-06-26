import 'package:badges/badges.dart';
import 'package:chat_project/catalog/credential/signup.dart';
import 'package:chat_project/screens/homepage.dart';
import 'package:chat_project/wallet/screen/appro.dart';
import 'package:chat_project/wallet/screen/home.dart';
import 'package:chat_project/wallet/screen/pay.dart';
import 'package:flutter/material.dart';
import 'package:chat_project/catalog/views/detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../tool.dart';
import 'cartdetail.dart';
import 'navbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  int numOfItems = 1;
  int quantiteValue = 1;
  int quantiteValue2 = 0;
  int quantitee = 0;

  late String token;
  late http.Response response;

  Future getQuantite() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    var quantite;
    String url = apiUrl + "panier";
    response = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200)
    {
      var d = jsonDecode(response.body);
      if (d['status'] == true)
      {
        var a = d['data']['panier'] as List;

        for (int j = 0; j < a.length; j++)
        {
          quantite = a[j]['qte'].toString();
        }
        quantitee = int.parse(quantite);
      }
    }
    return quantitee;
  }
  Future addPanier() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    String url = apiUrl + "panier";
    var res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': "Bearer $token", 'Accept': 'application/json; charset=UTF-8',
        },
        body: {
          "id": "452",
          "qte": "1",
        });

    if (res.statusCode == 200)
    {
      var data = jsonDecode(res.body);
      if(data["status"] == true)
      {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Text(
                "${data['message']}\nVoulez-vous procédé au paiement maintenant ?"),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("NON"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("OUI"),
                textColor: Colors.white,
                color: Colors.orange,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartDetail(""),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
      else
      {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("${data['message']}"),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("Ok"),
                textColor: Colors.white,
                color: Colors.orange,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
    else
    {
      Fluttertoast.showToast(
        msg: "Echec lors de l'ajout au panier",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

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
                MaterialPageRoute(builder: (context) => SignupScreen()),
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
              MaterialPageRoute(builder: (conetext) => Pay()),
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

  @override
  Widget build(BuildContext context)
  {
    void showAlertDialog(BuildContext context) {
      // ignore: deprecated_member_use
      Widget continueButton = FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Ok",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ));
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text(
          "Information ! ",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: const [
              Text(
                "Votre panier est encore vide. Veuillez le remplir pour en savoir plus",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                textAlign: TextAlign.justify,
              ),
            ]),
          ],
        ),
        actions: [
          continueButton,
        ],
      );

      // Show the dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          });
    }

    bool _folded = true;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Container(
        color: Colors.red,
        width: size.width * 0.72,
        child: NavBar(),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('Oasis Shop',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                if (quantiteValue == 0) {
                  showAlertDialog(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartDetail("token"),),);
                }
              },
              child: Badge(
                badgeContent: FutureBuilder(
                  future: getQuantite(),
                  builder: (BuildContext context,
                      AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text('');
                    }
                    else
                      {
                        quantitee = snapshot.data;
                        return Text(
                          "${snapshot.data}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        );
                      }
                  },
                ),
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(height: 12.0),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                width: MediaQuery.of(context).size.width - 30.0,
                height: MediaQuery.of(context).size.height - 180,
                child: GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.8,
                  children: <Widget>[
                    _buildCard('Cookie mint', '\$3.99', 'images/cookiemint.jpg',
                        false, false, context),
                    _buildCard('Cookie cream', '\$5.99', 'images/cookiecream.jpg',
                        true, false, context),
                    _buildCard('Cookie classic', '\$1.99',
                        'images/cookieclassic.jpg', false, true, context),
                    _buildCard('Cookie choco', '\$2.99', 'images/cookiechoco.jpg',
                        false, false, context),

                    _buildCard('Cookie mint', '\$3.99','images/cookievan.jpg', false, false, context),
                    _buildCard('Cookie mint', '\$3.99','images/vodacom.png', false, false, context),
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
            buildNavBarHome(Icons.home, 0, "Accueil"),
            buildNavBarAppro(Icons.person_outline, 2, "Compte"),
            buildNavBarTrans(Icons.send, 3, "Pay"),
            buildNavBarHist(Icons.history, 4, "Historique"),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "t1",
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: const Icon(Icons.message),
          ),
          const SizedBox(height: 10.0,),
          FloatingActionButton(
            heroTag: "t2",
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: const Icon(Icons.account_balance_wallet),
          ),
        ],
      ),
    );
  }
  Widget _buildCard(String name, String price, String imgPath, bool added, bool isFavorite, context) {
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
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: (){
                              addPanier();
                            },
                          icon: const Icon(Icons.shopping_cart_rounded,
                              color: Color(0xFFEF7532)),
                        ),
                        IconButton(
                          onPressed: () async
                          {
                            const url = "https://pub.dev/packages/share_plus/install";

                            final parser = Uri.parse(url);
                            final response = await http.get(parser);
                            await Share.share(url);
                            final byte = response.bodyBytes;

                            final temp = await getTemporaryDirectory();
                            final path = '${temp.path}/image.jpg';
                            // File(path).writeAsBytesSync(byte);

                          },
                          icon: Icon(Icons.share, color: Color(0xFFEF7532)),
                        )
                      ])),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Detail(
                          assetPath: imgPath,
                          cookieprice:price,
                          cookiename: name
                      )));
                },
                child: Hero(
                    tag: imgPath,
                    child: Container(
                        height: 75.0,
                        width: 75.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(imgPath),
                                fit: BoxFit.contain)))),
              ),
              SizedBox(height: 7.0),
              Text(price,
                  style: const TextStyle(
                      color: Color(0xFFCC8053),
                      fontFamily: 'Varela',
                      fontSize: 14.0)),
              Text(name,
                  style: const TextStyle(
                      color: Color(0xFF575E67),
                      fontFamily: 'Varela',
                      fontSize: 14.0)),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
              Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.shopping_basket,
                            color: Color(0xFFD17E50), size: 12.0),
                        Text('Ajouter au panier',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Color(0xFFD17E50),
                                fontSize: 12.0))
                      ]))
            ])));
  }
}