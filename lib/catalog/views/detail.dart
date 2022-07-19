import 'package:badges/badges.dart';
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

class Detail extends StatefulWidget
{
  final assetPath, cookieprice, cookiename;

  Detail({this.assetPath, this.cookieprice, this.cookiename});

  @override
  _Detail createState() => _Detail();
}
class _Detail extends State<Detail> with TickerProviderStateMixin
{

  int numOfItems = 1;
  int quantiteValue = 1;
  int quantiteValue2 = 0;
  late http.Response response;
  int quantitee = 0;
  int qte_init = 0;

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
          "qte": numOfItems.toString(),
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
              content: Text("${data['message']}\nVoulez-vous procédé au paiement maintenant ?"),
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
                  color: text_color0,
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
                  color: text_color0,
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

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;

    Widget buildHeader(BuildContext context, SheetState state) => Material(
      child: Container(
        color: Color(0xFFEF7532),
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
    // Panier rubber

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
        title: const Text('Commande',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Colors.white)),
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
          padding: EdgeInsets.only(bottom: 30),
          children: [
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                      'Cookie',
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                          color: text_color0)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    icon: Icon(Icons.share),
                    color: text_color0,
                    onPressed: (){
                    },
                  ),
                ),
              ]
            ),
            const SizedBox(height: 15.0),
            CarouselSlider(
                options: CarouselOptions(
                  height: 100.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 19 / 10,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 600),
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayCurve: Curves.easeIn,
                  viewportFraction: 2,
                ),
                items: [
                  Container(
                    child: Hero(
                        tag: widget.assetPath,
                        child: Image.asset(widget.assetPath,
                            height: 150.0,
                            width: 100.0,
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  const Image(
                    image: AssetImage("images/shoes.jpg"),
                    fit: BoxFit.cover,
                  ),
                  const Image(
                    image: AssetImage("images/iphone2.jpg"),
                    fit: BoxFit.cover,
                  ),
                  const Image(
                    image: AssetImage("images/bookin.jpg"),
                    fit: BoxFit.cover,
                  ),
                  const Image(
                    image: AssetImage("images/shoes_l.jpg"),
                    fit: BoxFit.cover,
                  ),
                ]
            ),
            SizedBox(height: 20.0),
            Column(
              children: [
                Container(
                  child: Text(widget.cookieprice,
                      style: const TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF17532))),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: Text(widget.cookiename,
                        style: const TextStyle(
                            color: Color(0xFF575E67),
                            fontFamily: 'Varela',
                            fontSize: 24.0)),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height * 0.06,
                              padding: const EdgeInsets.all(0.4),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onPressed: (){
                                  setState(() {
                                    if (quantiteValue < 10)
                                    {
                                      numOfItems++;
                                      quantiteValue++;
                                    }
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                numOfItems.toString().padLeft(2, "0"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              padding: const EdgeInsets.all(0.4),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                onPressed: (){
                                  setState(() {
                                    if (numOfItems > 1)
                                    {
                                      numOfItems--;
                                      quantiteValue--;
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50.0,
                        child: RaisedButton(
                            color:  text_color0,
                            child: const Text(
                              "Ajouter au Panier",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: (){
                              addPanier();
                            }
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  child: const Text(
                      'Cold, creamy ice cream sandwiched between delicious deluxe cookies. '
                          'Pick your favorite deluxe cookies and ice cream flavor.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 16.0,
                          color: Color(0xFFB4B8B9))
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
              ]
            ),
          ]
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Badge(
                  badgeContent: FutureBuilder(
                    future: getQuantite(),
                    builder: (BuildContext context,
                        AsyncSnapshot snapshot)
                    {
                      if (!snapshot.hasData)
                      {
                        return Text('');
                      }
                      else
                        {
                          qte_init = snapshot.data;
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
                )
              ]
            ),
            Container(
              height: 50.0,
              child: RaisedButton(
                color:  text_color0,
                child: const Text(
                    "Passer une commande",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  onPressed: ()
                  {

                    if(qte_init > 0)
                      {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Pay()));
                      }
                    else
                      {
                        AlertDialog alert = AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text(
                                  "Attention",
                                ),
                                SizedBox(height: 3,),
                                Text(
                                  "Votre Panier est vide. Veuillez remplir votre Panier avant de passer une commande",
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
                              color: text_color0,
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
                            builder: (BuildContext context) {
                              return alert;
                            });
                      }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}