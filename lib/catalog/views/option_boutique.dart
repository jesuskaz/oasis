import 'package:badges/badges.dart';
import 'package:oasisapp/catalog/views/article.dart';
import 'package:oasisapp/catalog/views/categorie.dart';
import 'package:oasisapp/catalog/views/entreprise.dart';
import 'package:oasisapp/tool.dart';
import 'package:oasisapp/wallet/screen/home.dart';
import 'package:oasisapp/wallet/screen/pay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cartdetail.dart';

class Option_boutique extends StatefulWidget {
  @override
  _Option_boutique createState() => _Option_boutique();
}

class _Option_boutique extends State<Option_boutique>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: text_color0,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Option Catalog',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        // physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.05,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Entreprise()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.add_business_rounded,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Créez votre Entreprise",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey
                    ),
                  ),
                ),
                subtitle: const Text(
                  "La création de l'Entreprise permet un fort référecemment pour l'échange de vos produits et Services",
                  style: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Categorie()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                  Icons.add,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                      "Ajoutez catégories Produit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: Text(
                    "Veuillez à toujours ajouter la catégorie avant d'ajouter un article",
                  style: TextStyle(
                    color: Colors.black45
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Article()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Ajoutez un article | Service",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      color: Colors.blueGrey
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Vendez vos services et produits à tout le monde sans aucune contrainte",
                  style: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
