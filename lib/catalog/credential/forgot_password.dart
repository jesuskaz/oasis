import 'package:firebase_auth/firebase_auth.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/catalog/credential/new_password.dart';
import 'package:oasisapp/catalog/credential/next_signup.dart';
import 'package:oasisapp/catalog/credential/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasisapp/tool.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Password_forgot extends StatefulWidget {
  const Password_forgot({Key? key}) : super(key: key);
  @override
  _Password_forgotState createState() => _Password_forgotState();
}

class _Password_forgotState extends State<Password_forgot> with CodeAutoFill {

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  String initialCountry = 'CD';
  PhoneNumber number = PhoneNumber(isoCode: 'CD');
  final _formKey = GlobalKey<FormState>();
  String codeValue = "";
  String? appSignature;

  bool isTrue = false;
  var tel;
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

  @override
  void codeUpdated() {
    setState(() {
      codeValue = code!;
    });

    print("Update code $code");
    setState(() {
      print("Code updated");
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("UnregisterListener");
    super.dispose();
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    await SmsAutoFill().listenForCode;
    print("LISTEN CODE");
  }

  Future checkPhone(String phone, BuildContext context) async
  {
    await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;

    showProgress();

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          progressDialog.dismiss();

          var result = await _auth.signInWithCredential(credential);
          var user = result.user;

          if(user != null)
          {
            setState(() {
              isTrue = true;
            });
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => NextSignup(tel, email.text)));
          }
          else
          {
            print("Error");
          }
        },
        verificationFailed: (FirebaseAuthException exception)
        {
          progressDialog.dismiss();
          AlertDialog alert = AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text("Message",),
                  SizedBox(height: 3,),
                  Text("Erreur lors de la reception du code OTP. Veuillez reésayer",),
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
                color: Colors.blue,
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
        },
        codeSent: (String verificationId, [int? forceResendingToken])
        {
          progressDialog.dismiss();
          showDialog(context: context, barrierDismissible: false, builder: (context) {
            return AlertDialog(
              title: Text("Veuillez saisir le code à 6 chiffres envoyé à votre numéro"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PinFieldAutoFill(
                    currentCode: codeValue,
                    codeLength: 6,
                    onCodeChanged: (code){
                      print("OnChanged $code");
                      codeValue = code.toString();
                    },
                    onCodeSubmitted: (val){
                      print("OnCodeSubmitted $val");
                    },
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text(
                    "Fermer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text(
                    "Verifiez Code",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  textColor: Colors.white,
                  color: text_color,
                  onPressed: () async {
                    // Navigator.pop(context);

                    showProgress();
                    final code = codeValue.trim();

                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                    try
                    {
                      var result = await _auth.signInWithCredential(credential);
                      var user = result.user;
                      print("USER DATA ::: ${user != null}");
                      if(user != null)
                      {
                        setState(() {
                          isTrue = true;
                        });
                        progressDialog.dismiss();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => New_password(tel)));
                      }
                      else
                      {
                        progressDialog.dismiss();
                        print("============>>>>>>>>> EEEEEERRRRRROOOOOOORRRR ${user}");
                      }
                    }
                    catch (e)
                    {
                      progressDialog.dismiss();
                      print(e);
                    }
                  },
                ),
              ],
            );
          }
          );
        },
        codeAutoRetrievalTimeout: (String verificationId)
        {
          if(isTrue)
          {
            return ;
          }
          progressDialog.dismiss();
          AlertDialog alert = AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text(
                    "Message",
                  ),
                  SizedBox(height: 3,),
                  Text(
                    "Code OTP incorrect. Veuillez reéssayer le code OTP",
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
                color: Colors.blue,
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
    );
  }

  Widget _telephone(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child:  InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number)
          {
            tel = number.phoneNumber;
          },
          onInputValidated: (bool value)
          {
            print(value);
          },
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          spaceBetweenSelectorAndTextField: 0,
          inputDecoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            prefixIconConstraints:
            BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(),
            hintText: "Ex: 991234567",
            hintStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
                left: 10, top: 10, bottom: 10),
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
          selectorTextStyle: TextStyle(color: Colors.white),
          initialValue: number,
          textFieldController: phone,
          formatInput: false,
          keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
          inputBorder: OutlineInputBorder(),
          onSaved: (PhoneNumber number) {
          },
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
                        SizedBox(height: size.height * 0.1,),
                        Container(
                          height: size.height * 0.12,
                          child: Text(
                              "Veuillez entrez votre numéro de téléphone de récupération",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color_white,

                            ),
                          ),
                        ),
                        _telephone(Icons.email, 'Téléphone', TextInputType.name, TextInputAction.next,),
                        const SizedBox(height: 5,),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SigninScreen()));
                                  },
                                  child: Container(
                                    child: RichText(
                                      textAlign: TextAlign.start,
                                      text: const TextSpan(
                                          text: "Se Connecter",
                                          style: TextStyle(
                                              color: text_color0,
                                              fontSize: 18,
                                            fontWeight: FontWeight.bold
                                          ),
                                          children: [
                                          ]),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Row(
                                      children: [
                                        const Text(
                                          "Vérifier",
                                          style: TextStyle(
                                              color: text_color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                      ]
                                  ),
                                  onTap: ()
                                  {
                                    if(_formKey.currentState!.validate())
                                    {
                                      // submit(context);
                                      checkPhone(tel, context);
                                    }
                                  },
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Text("Make with Heart by K Inc"),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
        },
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
}