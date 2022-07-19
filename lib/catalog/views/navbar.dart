import 'package:oasisapp/catalog/views/boutique.dart';
import 'package:oasisapp/catalog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:oasisapp/catalog/views/option_boutique.dart';
import 'package:oasisapp/tool.dart';
import 'package:http/http.dart' as http;
import 'package:oasisapp/page/qr_create_page.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';
// import 'package:mbangu/utilities/dbHelper.dart';
// import 'package:mbangu/utilities/utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  var boolVal;
  var response;
  var state = false;

  String token = '';

  String compte = '';

  Future getCompte() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    String url = apiUrl + "numero-compte";
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': "Bearer $token", 'Accept': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      if(r["status"] == true)
      {
        compte = r["data"];

        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => QRCreatePage(compte)));
      }
    }
    else {
      AlertDialog alert = AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text(
                "Note",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                "Aucun numéro de compte n'est lié à ce compte pour le moment",
                style: TextStyle(
                  color: Colors.black
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
            },
            color: Colors.redAccent,
            textColor: Colors.white,
            child: const Text(
              'Ok',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return alert;
          });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                  margin: EdgeInsets.only(left: 5, top: 30),
                  child: const Text(
                    "User 001",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            accountEmail: Container(
              margin: EdgeInsets.only(left: 5),
              child: const Text(
                "jesuskazkid@gmail.com",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/casque.jpeg",
                  width: 95,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/shoes.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add_business_rounded),
              title: const Text(
                "Boutique",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Option_boutique()));
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.notifications_none),
              title: const Text(
                "Notification",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Container()));
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.history),
              title: const Text(
                "Historique",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Container()));
              }),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: const Text(
                "Compte",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              }),
          ListTile(
            leading: Icon(Icons.qr_code),
            title: const Text(
              "Qr Code",
              style: TextStyle(
                color: color_grey,
                fontSize: taille2,
              ),
            ),
            onTap: () {
              getCompte();
            },
          ),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text(
                "Se Connecte/Se Deconnecter",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                // showAlertDialog(context);
              })
        ],
      ),
    );
  }
}


