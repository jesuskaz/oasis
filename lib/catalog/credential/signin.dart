import 'package:chat_project/catalog/credential/signup.dart';
import 'package:chat_project/catalog/views/home.dart';
import 'package:chat_project/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_project/tool.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
{

  bool? _rememberMe = false;
  bool isHidePassword = true;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences preferences;

  late ProgressDialog progressDialog;
  String initialCountry = 'CD';
  PhoneNumber number = PhoneNumber(isoCode: 'CD');
  final _formKey = GlobalKey<FormState>();

  var tel;
  Widget _telephone(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            tel = number.phoneNumber;
          },
          onInputValidated: (bool value) {
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          spaceBetweenSelectorAndTextField: 0,
          inputDecoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(),
            hintText: "Ex: 991234567",
            hintStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Numéro de tel. vide';
            }
            if (value.length < 9) {
              return 'Tel. non valide';
            }
            return null;
          },
          maxLength: 9,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.white),
          initialValue: number,
          textFieldController: phone,
          formatInput: false,
          keyboardType:
              const TextInputType.numberWithOptions(signed: true, decimal: true),
          inputBorder: const OutlineInputBorder(),
          onSaved: (PhoneNumber number) {},
        ),
      ),
      // ),
    );
  }
  Widget _motdePasse(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: password,
          obscureText: isHidePassword,
          style: TextStyle(color: color_grey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Mot de passe Obligatoire";
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
            hintStyle: const TextStyle(color: color_white, fontSize: 12),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
      // ),
    );
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
  Future login() async {
    String url = apiUrl + "auth/login";
    showProgress();

    var res = await http.post(Uri.parse(url), headers: <String, String>{
      'Accept': 'application/json; charset=UTF-8',
    },
        body: {
          "login": tel,
          "password": password.text,
        });

    progressDialog.dismiss();

    if (res.statusCode == 400)
    {
      var data = jsonDecode(res.body);
      Fluttertoast.showToast(
          msg: "${data["data"]["errors_msg"][0]}",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.grey);
    }
    if (res.statusCode == 200)
    {
      var data = jsonDecode(res.body);
      String token = data["data"]["token"];
      preferences = await SharedPreferences.getInstance();
      preferences.setString("token", token);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                        image: const AssetImage(('images/oasis.jpg')),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.darken))),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 120,
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
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _telephone(
                          Icons.account_circle,
                          'Téléphone',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        _motdePasse(
                          Icons.lock_outline_sharp,
                          'Mot de passe',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  onPressed: () => print("Mot de passe oublié"),
                                  padding: EdgeInsets.only(left: 0),
                                  child: Row(children: const [
                                    Text(
                                      "Mot de passe ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "oublié?",
                                      style: TextStyle(color: Colors.orange),
                                    )
                                  ]),
                                ),
                              ),
                            ]),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 15,
                            onPressed: () {
                              if (_formKey.currentState!.validate())
                              {
                                login();
                              }
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            color: text_color,
                            child: const Text(
                              'Se Connecter',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: const TextSpan(
                                  text: "N'avez-vous pas un ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: "Compte ?",
                                      style: TextStyle(
                                          color: text_color0, fontSize: 12),
                                    ),
                                  ]),
                            ),
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
      bottomNavigationBar: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
                text: "Copyright ©2022, All Rights Reserved. ",
                style: TextStyle(color: Colors.white, fontSize: 9),
                children: [
                  TextSpan(
                    text: "Powered by CRESTIF",
                    style: TextStyle(color: text_color, fontSize: 10),
                  ),
                ]),
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
}

class InputEmail extends StatelessWidget {
  final String hintText;
  final String upperText;
  final IconData icon;
  final bool obscuretext;
  final TextInputType inputType;
  InputEmail(this.hintText, this.icon, this.obscuretext, this.upperText,
      this.inputType);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upperText,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.yellowAccent,
                    offset: Offset(0, 2),
                    blurRadius: 10.0),
              ],
              image:
                  DecorationImage(image: AssetImage('images/cookiecream.jpg'))),
          alignment: Alignment.centerLeft,
          // decoration: kBixDecorationStyle,
          height: 60,
          child: TextField(
            obscureText: obscuretext,
            keyboardType: inputType,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
