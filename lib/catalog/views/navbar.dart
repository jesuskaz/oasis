import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:oasisapp/Logout.dart';
import 'package:oasisapp/catalog/views/option_boutique.dart';
import 'package:oasisapp/tool.dart';
import 'package:http/http.dart' as http;
import 'package:oasisapp/page/qr_create_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oasisapp/catalog/credential/signin.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  late final Logout logout;

  var boolVal;
  var response;
  var state = false;

  var noInternet = '';
  bool networkOK = false;
  late ProgressDialog progressDialog;
  late SharedPreferences preferences;

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

  void showAlertDialog(BuildContext context) {
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
              color: text_color0,
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
              color: text_color0,
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
      color: text_color0,
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

        preferences = await SharedPreferences.getInstance();
        preferences.setString("token", "");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen(),));
      },
      color: Colors.red,
      textColor: Colors.white,
      child: const Text(
        'Oui',
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
              "Message ",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10,),
            const Text(
              "Voulez-vous vous deconnecter ?",
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

  Future login() async {

    preferences = await SharedPreferences.getInstance();
    preferences.setString("token", "");

    Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen(),));

    // setState(() {
    //   noInternet = '';
    // });
    //
    // if(networkOK)
    // {
    //   showProgress();
    //   String url = apiUrl + "auth/logout";
    //
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   String token = pref.getString("token").toString();
    //
    //   http.post(Uri.parse(url),
    //       headers: <String, String> {"Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"}).
    //   timeout(const Duration(seconds: 40)).then((res) async
    //   {
    //     progressDialog.dismiss();
    //
    //     if (res.statusCode == 400)
    //     {
    //       var data = jsonDecode(res.body);
    //       Fluttertoast.showToast(
    //           msg: "",
    //           toastLength: Toast.LENGTH_LONG,
    //           backgroundColor: Colors.white,
    //           textColor: Colors.grey);
    //     }
    //     if (res.statusCode == 200)
    //     {
    //       var data = jsonDecode(res.body);
    //
    //       if(data["status"] == true)
    //       {
    //         String token = data["data"]["token"];
    //         var user = data["data"]["user"];
    //         String user_id = user["id"].toString();
    //         String avatar = user["avatar"].toString();
    //
    //         preferences = await SharedPreferences.getInstance();
    //         preferences.setString("token", "");
    //
    //         Navigator.push(
    //             context, MaterialPageRoute(builder: (context) => SigninScreen(),));
    //       }
    //     }
    //   }).catchError((onError){
    //     progressDialog.dismiss();
    //
    //     print(onError);
    //
    //     Fluttertoast.showToast(
    //       msg: "Impossible d'atteindre le serveur distant.",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.white,
    //       textColor: Colors.black,
    //     );
    //   });
    // }
    // else
    // {
    //   Fluttertoast.showToast(
    //     msg: "Vérifiez votre connexion internet.",
    //     toastLength: Toast.LENGTH_LONG,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black,
    //   );
    // }
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
                // child: Image.asset(
                //   "assets/casque.jpeg",
                //   width: 95,
                //   height: 90,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/oasis.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add_business_rounded),
              title: const Text(
                "Entreprise",
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
          // ListTile(
          //     leading: Icon(Icons.notifications_none),
          //     title: const Text(
          //       "Notification",
          //       style: TextStyle(
          //         color: color_grey,
          //         fontSize: taille2,
          //       ),
          //     ),
          //     onTap: () {
          //       Navigator.of(context).pop();
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (BuildContext context) => Container()));
          //     }),
          // const Divider(height: 1),
          // ListTile(
          //     leading: Icon(Icons.history),
          //     title: const Text(
          //       "Historique",
          //       style: TextStyle(
          //         color: color_grey,
          //         fontSize: taille2,
          //       ),
          //     ),
          //     onTap: () {
          //       Navigator.of(context).pop();
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (BuildContext context) => Container()));
          //     }),
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
                "Se Deconnecter",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                showAlertDialog(context);
              })
        ],
      ),
    );
  }
}


