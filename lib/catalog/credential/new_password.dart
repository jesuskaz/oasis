import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:oasisapp/catalog/credential/signin.dart';
import 'package:oasisapp/catalog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasisapp/tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/tool.dart';

class New_password extends StatefulWidget {
  String tel;
  New_password(this.tel,);

  @override
  _New_passwordState createState() => _New_passwordState();
}

class _New_passwordState extends State<New_password>
{

  late SharedPreferences preferences;

  bool? _rememberMe = false;
  bool isHidePassword = true;
  bool isHidePasswordConfirm = true;
  late ProgressDialog progressDialog;

  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  bool networkOK = false;
  var noInternet = '';

  void checkNetwork() async {
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          networkOK = result == ConnectivityResult.none ? false : true;
          if (networkOK) {
            noInternet = '';
          }
        });
      }
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        networkOK = true;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
  @override
  initState() {
    checkNetwork();
    super.initState();
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
  Future register() async {
    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = apiUrl+"recovery/check";

      var data = {
        "phone": widget.tel,
        "newpassword": confirm.text,
      };

      await http.post(Uri.parse(url), headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',},
          body: data).timeout(const Duration(seconds: 10)).then((res) async {

        progressDialog.dismiss();
        if(res.statusCode == 400)
        {
          var data = jsonDecode(res.body);
          Fluttertoast.showToast(
              msg: "${data["data"]["errors_msg"][0]}",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: Colors.grey);
        }
        if(res.statusCode == 200)
        {
          var data = jsonDecode(res.body);
          String token = data["data"]["token"];

          preferences = await SharedPreferences.getInstance();
          preferences.setString("token", token);

          Fluttertoast.showToast(
              msg: " Votre Mot de Passe a été réinitialisé avec succès",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: Colors.grey);

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
        }
      }).catchError((onError){
        progressDialog.dismiss();
        Fluttertoast.showToast(
          msg: "Erreur de connexion réseau.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      });
    }
  }
  
  Widget _motdePasse(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: password,
          obscureText: isHidePassword,
          style: TextStyle(color: color_grey),
          validator: (value) {
            if (value!.isEmpty)
            {
              return "Password Required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: color_white,
                )),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_white,
            ),
            suffixIcon: InkWell(
              onTap: () => getHiddenPass(),
              child: const Icon(
                Icons.visibility,
                color: color_white,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: color_white, fontSize: 12),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
      // ),
    );
  }
  Widget _confirm(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: confirm,
          obscureText: isHidePasswordConfirm,
          style: TextStyle(color: color_grey),
          validator: (value) {
            if(value != password.text)
            {
              return "Mot de Passe ne correspond pas";
            }
            if (value!.isEmpty)
            {
              return "Password Required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: color_white,
                )),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_white,
            ),
            suffixIcon: InkWell(
              onTap: () => getHiddenPassConfirm(),
              child: Icon(
                Icons.visibility,
                color: color_white,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: color_white, fontSize: 12),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(('images/oasis.jpg')),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.darken))),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 160,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Text(
                              "Veuillez saisir votre nouveau Mot de Passe",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color_white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35,),
                        _motdePasse(Icons.lock_outline_sharp, 'Mot de passe', TextInputType.name, TextInputAction.next,),
                        _confirm(Icons.lock_outline_sharp, 'Confirmez Mot de passe', TextInputType.name, TextInputAction.done,),
                        const SizedBox(height: 5,),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                                        },
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Se Connecter",
                                              style: TextStyle(
                                                  color: text_color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: RaisedButton(
                                    elevation: 10,
                                    onPressed: () {
                                      if(_formKey.currentState!.validate())
                                      {
                                        register();
                                      }
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    color: text_color,
                                    child: const Text(
                                      'Sauvegarder',
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void getHiddenPass() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }
  void getHiddenPassConfirm() {
    setState(() {
      isHidePasswordConfirm = !isHidePasswordConfirm;
    });
  }
}