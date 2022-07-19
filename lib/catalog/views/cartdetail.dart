import 'package:oasisapp/catalog/views/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/tool.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable

class CartDetail extends StatefulWidget
{
  var cart;
  String login;
  CartDetail(this.login);
  @override
  _CartDetail createState() => _CartDetail();
}

class _CartDetail extends State<CartDetail>
{
  int quantitee = 0;

  String baseUrl = apiUrl;
  late http.Response response;
  List listEleve = [];
  bool start = false;

  late ProgressDialog progressDialog;
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
  payMode() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddAmount2(),
    //   ),
    // );
  }
  void removeP(idarticle, ideleve) async {
    String url = apiUrl + "cart/delete/";
    var d = {
      "type": "p",
      "matricule": "${widget.login}",
      "article": "$idarticle",
      "eleve": "$ideleve",
    };
    response = await http.post(Uri.parse(url), body: d, headers: await userHeaders());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Une petite erreur s'est produite.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
    setState(() {});
  }

  Future getQuantite() async
  {
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

  @override
  Widget build(BuildContext context) {
    var tab = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getQuantite(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      );
                    }

                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Articles dans le panier",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              fontSize: taille3,
                                              fontWeight: FontWeight.bold,
                                              color: text_color2,
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var cart = snapshot.data[index];
                                            String devise = cart['devise'];
                                            var img = cart['image'].split(',');
                                            var _el = cart['ideleve'];

                                            var nom = '';
                                            for (int i = 0;
                                            i < listEleve.length;
                                            i++) {
                                              var el = listEleve[i];
                                              if (el['ideleve'] == _el) {
                                                nom =
                                                "${el['nom']} ${el['prenom']}";
                                                break;
                                              }
                                            }

                                            var q = int.parse(cart['qte']);
                                            return Container(
                                              child: Card(
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: Container(
                                                        height: 40,
                                                      ),
                                                      title: Text(
                                                        "${cart['article']}",
                                                        style: TextStyle(
                                                            fontSize: taille2,
                                                            color: text_color3,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              "${cart['prix']} $devise X $q =${formatPrice(montant: cart['prix_total'], devise: devise)}"),
                                                          Container(
                                                            child: Text("$nom"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 60,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left: 15,
                                                                  bottom:
                                                                  10),
                                                              child:
                                                              DropdownButtonFormField(
                                                                isExpanded:
                                                                true,
                                                                value: q,
                                                                items: tab
                                                                    .map((i) {
                                                                  return DropdownMenuItem(
                                                                    value: i,
                                                                    child: Text(
                                                                      "$i",
                                                                      style:
                                                                      TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (value) {
                                                                  // updateCart(
                                                                  //     cart[
                                                                  //     'idarticle'],
                                                                  //     cart[
                                                                  //     'ideleve'],
                                                                  //     value);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // Row(
                                                        //   children: [
                                                        //     IconButton(
                                                        //       onPressed: () {},
                                                        //       icon: FaIcon(
                                                        //         FontAwesomeIcons
                                                        //             .heart,
                                                        //         size: 15,
                                                        //       ),
                                                        //     ),
                                                        //     Text("Payer après")
                                                        //   ],
                                                        // ),
                                                        Container(
                                                          margin:
                                                          EdgeInsets.only(
                                                              right: 10),
                                                          child: Row(
                                                            children: [
                                                              // ignore: deprecated_member_use
                                                              RaisedButton.icon(
                                                                onPressed: () {
                                                                  removeP(
                                                                      cart[
                                                                      'idarticle'],
                                                                      cart[
                                                                      'ideleve']);
                                                                },
                                                                icon: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .trashAlt,
                                                                  size: 15,
                                                                ),
                                                                label: Text(
                                                                    "Supprimer"),
                                                                color: Colors
                                                                    .white,
                                                                elevation: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: FutureBuilder(
        future: montant(),
        builder: (BuildContext context, AsyncSnapshot snapshot)
        {
          if (snapshot.data == null)
          {
            return Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    // child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData)
          {
            return Container();
          }

          if (snapshot.data.length == 0)
          {
            return Container();
          }

          var t = snapshot.data;
          return MaterialButton(
            padding: EdgeInsets.all(20),
            onPressed: t[0] == true ? payMode : null,
            color: Colors.orange,
            textColor: Colors.white,
            child: Text(
              'Acheter ${t[1]}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  montant() {}
}
