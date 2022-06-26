import 'package:chat_project/catalog/credential/next_signup.dart';
import 'package:chat_project/catalog/credential/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_project/tool.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
{
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  String initialCountry = 'CD';
  PhoneNumber number = PhoneNumber(isoCode: 'CD');
  final _formKey = GlobalKey<FormState>();

  var tel;

  Widget _email(
      IconData icon,
      String hint,
      TextInputType inputType,
      TextInputAction inputAction,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: email,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return "Email est obligatoir";
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
  Widget _telephone(
      IconData icon,
      String hint,
      TextInputType inputType,
      TextInputAction inputAction,
      ) {
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
                        _telephone(
                          Icons.email,
                          'Téléphone',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        _email(
                          Icons.email,
                          'Email',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
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
                                          text:
                                          "Avez-vous un ",
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
                                ),
                                GestureDetector(
                                  child: Row(
                                      children: [
                                        const Text(
                                          "Suivant",
                                          style: TextStyle(
                                              color: text_color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: ()
                                          {
                                          },
                                          icon: Icon(Icons.arrow_forward),
                                          color: text_color,
                                        )
                                      ]
                                  ),
                                  onTap: ()
                                  {
                                    if(_formKey.currentState!.validate())
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NextSignup(tel, email.text)));
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