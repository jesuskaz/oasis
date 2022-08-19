import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/tool.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class Entreprise extends StatefulWidget {
  @override
  _Entreprise createState() => _Entreprise();
}

class _Entreprise extends State<Entreprise> with TickerProviderStateMixin {

  TextEditingController nom_entreprise = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController localisation = TextEditingController();
  TextEditingController site_web = TextEditingController();

  String token = '';
  late String _selectedCat;
  bool process = false;
  bool processCat = false;
  var noInternet = '';
  bool networkOK = false;
  var file_image;

  Dio dio = new Dio();
  late ProgressDialog progressDialog;


  late http.Response response;
  late http.Response responseCat;

  // Categorie
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;


  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'gif']
    );

    if(result != null)
    {
      final file = result.files.first;
      // openFile(file);

      setState(() {
        file_image = File(result.files.single.path!);
        // type = file.extension.toString();
      });
    }
  }
  Future getcategorie() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token").toString();

    setState(() {
      processCat = true;
    });
    String url = apiUrl + "categorie-article";

    responseCat = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    var tab = [];
    if (responseCat.statusCode == 200) {
      try {
        tab = [jsonDecode(responseCat.body)];
      } catch (e) {}
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
  showAlertDialog(BuildContext context) {
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
        Navigator.pop(context);
        await save();
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
            Text(
              "Voulez-vous ajouter l'entreprise ${nom_entreprise.text.toString()} a votre compte ?",
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

  Future save() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = apiUrl + "entreprise";
      if(file_image != null)
      {
        FormData data = FormData.fromMap({
          "entreprise": nom_entreprise.text,
          "adresse": adresse.text,
          "telephone": phone.text,
          "email": email.text,
          "description": description.text,
          "localisation": localisation.text,
          "site_web": site_web.text,
          "logo": await MultipartFile.fromFile(
            file_image.path, filename: path.basename(file_image.path),
            // contentType:  MediaType("image", "$type")
          ),
        });

        dio.options.headers["Authorization"] = "Bearer ${token}";
        await dio.post(url, data: data).timeout(Duration(seconds: 30)).then((res)
        {
          progressDialog.dismiss();

          if(res.statusCode == 200)
          {
            if(res.data["status"] == true)
            {
              Fluttertoast.showToast(
                msg: "Votre Entreprise a été enregistrée avec succès",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
            else
            {
              Fluttertoast.showToast(
                msg: "Veuillez réesayer votre requête",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
          }
          else
          {
            Fluttertoast.showToast(
              msg: "Veuillez réesayer de charger l'article.",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            );
          }
        }).catchError((onError) async {

          progressDialog.dismiss();
          if(onError.response.statusCode == 400)
          {
            var body = await onError.response.data;
            List msg = body["data"]["errors_msg"];
            var msg2 = msg.join(',');

            Fluttertoast.showToast(
              msg: "$msg2",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            );
            return ;
          }
          print(onError.response!.data);
          print(onError.response!.headers);
          print(onError.response!.requestOptions);

          Fluttertoast.showToast(
            msg: "Erreur de connexion réseau.",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
        });
      }
      else
      {
        progressDialog.dismiss();
        Fluttertoast.showToast(
          msg: "Veuillez choisir l'image de la catégorie",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
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
  Widget _article(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: nom_entreprise,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Nom est obligatoir";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _description(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: description,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Nom est obligatoir";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _phone(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: phone,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Renseignez le numéro de téléphone svp";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _email(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: email,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Veuillez insérer l'adresse E-mail svp";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _adresse(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: adresse,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return null;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _localisation(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: localisation,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return null;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  Widget _site(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: site_web,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return null;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(icon, size: 20, color: color_grey,),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
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
  initState() {
    checkNetwork();
    getcategorie();
    super.initState();
  }
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
        title: const Text('Parametrez votre Entreprise',
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
          InkWell(
            onTap: () {
              pickFiles();
              // _showPickOptionsDialog_back(context);
            },
            child: file_image == null ? Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.blue.shade50,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04,),
                  Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                  SizedBox(height: 10,),
                  const Text(
                    "Ajoutez le logo de l'Entreprise",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey
                    ),
                  )
                ],
              ),
            ) : Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.blue.shade50,
              ),
              child: Image(
                image: FileImage(file_image),
                // fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _article(
              Icons.article,
              'Entrez le nom de l\'Entreprise',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _description(
              Icons.article,
              'Entrez la description',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _phone(
              Icons.article,
              'Entrez le numéro de téléphone',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _email(
              Icons.article,
              'Entrez l\'adresse E-mail',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _site(
              Icons.article,
              'Entrez le lien du site Internet',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _localisation(
              Icons.article,
              'Entrez la Localisation',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _adresse(
              Icons.location_city_sharp,
              'Entrez l\'adresse',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: size.height * 0.1,
          child: RaisedButton(
              color: text_color0,
              child: const Text(
                "Sauvegarder",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                showAlertDialog(context);
              }
          ),
        ),
      ),
    );
  }
}