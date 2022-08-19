import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oasisapp/catalog/credential/signin.dart';

import 'package:oasisapp/tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  var noInternet = '';
  bool networkOK = false;
  late ProgressDialog progressDialog;
  late SharedPreferences preferences;

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

      },
      color: text_color0,
      textColor: Colors.white,
      child: const Text(
        'Confirmez',
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
              "Voulez-vous enregistrer cet article ?",
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

    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = apiUrl + "auth/logout";

      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("token").toString();

      http.post(Uri.parse(url),
          headers: <String, String> {"Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"}).
      timeout(const Duration(seconds: 40)).then((res) async
      {
        progressDialog.dismiss();

        if (res.statusCode == 400)
        {
          var data = jsonDecode(res.body);
          Fluttertoast.showToast(
              msg: "",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: Colors.grey);
        }
        if (res.statusCode == 200)
        {
          var data = jsonDecode(res.body);

          if(data["status"] == true)
          {
            String token = data["data"]["token"];
            var user = data["data"]["user"];
            String user_id = user["id"].toString();
            String avatar = user["avatar"].toString();

            preferences = await SharedPreferences.getInstance();
            preferences.setString("token", "");

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SigninScreen(),));
          }
        }
      }).catchError((onError){
        progressDialog.dismiss();

        print(onError);

        Fluttertoast.showToast(
          msg: "Impossible d'atteindre le serveur distant.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      });
    }
    else
    {
      Fluttertoast.showToast(
        msg: "Vérifiez votre connexion internet.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
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
  Widget build(BuildContext context) {
    return Container();
  }
}
