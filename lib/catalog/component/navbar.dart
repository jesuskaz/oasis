import 'package:oasisapp/catalog/views/boutique.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:oasisapp/tool.dart';
import 'package:http/http.dart' as http;
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

  @override
  Widget build(BuildContext context) {
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
                  "images/casque.jpeg",
                  width: 95,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/shoes.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add_business_rounded),
              title: const Text(
                "Catalogue",
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
                        builder: (BuildContext context) => Boutique()));
              }),
          ListTile(
              leading: Icon(Icons.assignment_sharp),
              title: const Text(
                "Infos",
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
              leading: Icon(Icons.help_outline_rounded),
              title: const Text(
                "Centre d'aide",
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
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: const Text(
                "Contactez-nous",
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
                "Terme et Condition ",
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
              leading: Icon(Icons.vpn_key),
              title: const Text(
                "Compte",
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
                    builder: (BuildContext context) => Container(),
                  ),
                );
              }),
          ListTile(
            leading: Icon(Icons.forum_outlined),
            title: const Text(
              "Faq",
              style: TextStyle(
                color: color_grey,
                fontSize: taille2,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
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


