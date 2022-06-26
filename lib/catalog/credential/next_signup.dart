import 'package:chat_project/catalog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_project/tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:chat_project/tool.dart';

class NextSignup extends StatefulWidget {
  String tel;
  String email;
  NextSignup(this.tel, this.email, {Key? key}) : super(key: key);

  @override
  _NextSignupState createState() => _NextSignupState();
}

class _NextSignupState extends State<NextSignup>
{

  late SharedPreferences preferences;

  bool? _rememberMe = false;
  bool isHidePassword = true;
  bool isHidePasswordConfirm = true;
  late ProgressDialog progressDialog;

  TextEditingController password = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    String url = apiUrl+"auth/register";
    showProgress();
    var res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
        },
        body: {
          "name": nom.text,
          "email": widget.email,
          "phone": widget.tel,
          "password": password.text,
          "cpassword": confirm.text,
          "user_role": "marchand"
        });
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
          msg: " Votre Compte a été crée avec succès",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.grey);

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
  Widget _motdePasse(
      IconData icon,
      String hint,
      TextInputType inputType,
      TextInputAction inputAction,
      ) {
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
              return "Mot de passe Obligatoire";
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
              onTap: () => getHiddenPass(),
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
  Widget _nom(
      IconData icon,
      String hint,
      TextInputType inputType,
      TextInputAction inputAction,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: nom,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return "Nom Obligatoire";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_grey,
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
  Widget _confirm(
      IconData icon,
      String hint,
      TextInputType inputType,
      TextInputAction inputAction,
      ) {
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
              return "Mot de passe Obligatoire";
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
                    vertical: 100,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: size.height * 0.12,
                          child: const CircleAvatar(
                              backgroundColor: text_color,
                              child: ClipOval(
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  )
                              )
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _nom(
                          Icons.account_circle,
                          'Nom complet',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        _motdePasse(
                          Icons.lock_outline_sharp,
                          'Mot de passe',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        _confirm(
                          Icons.lock_outline_sharp,
                          'Confirmez Mot de passe',
                          TextInputType.name,
                          TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: ()
                                              {

                                              },
                                              icon: Icon(Icons.arrow_back),
                                              color: text_color,
                                            ),
                                            const Text(
                                              "Retour",
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
                                      'S\'enregistrer',
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