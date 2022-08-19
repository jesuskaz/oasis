import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import 'package:oasisapp/tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

class Categorie extends StatefulWidget {
  @override
  _Categorie createState() => _Categorie();
}

class _Categorie extends State<Categorie> with TickerProviderStateMixin {

  var file_image;
  // late String type;
  TextEditingController categorie = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Connectivity connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> subscription;
  bool networkOK = false;
  var noInternet = '';
  Dio dio = new Dio();


  var _selected = "1";
  bool process = false;
  late ProgressDialog progressDialog;
  String url = "";

  String token = '';
  bool processCat = false;
  late http.Response responseCat;
  var tab = [];

  Widget _entreprise(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(Icons.arrow_drop_down,
                    color: _selected == null ? Colors.grey : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: text_color2,
                      ),
                    ),
                    hintStyle: TextStyle(color: text_color2),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(2.0),
                  ),
                  isDense: true,
                  isExpanded: true,
                  hint: Text(
                    "Selectionnez une Entreprise",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected.toString(),
                  items: tab.map((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data["entreprise"]),
                      value: data["id"].toString(),
                    );
                  }).toList(),
                  onChanged: (value)
                  {
                    setState(() {
                      _selected = value.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Currency required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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
  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
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

  Future getEntreprise() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token").toString();

    setState(() {
      processCat = true;
    });

    url = apiUrl + "entreprise";

    responseCat = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    if (responseCat.statusCode == 200)
    {
     var data = jsonDecode(responseCat.body);

      if(data["status"] == true)
        {
          if(mounted)
            {
              setState(() {
                tab = data["data"];
                _selected = tab[0]["id"].toString();
              });
            }
        }
    }
  }
  Future createCategorie() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = apiUrl + "categorie-article";
      if(file_image != null)
      {
        FormData data = FormData.fromMap({
          "categorie": categorie.text,
          "entreprise_id": _selected.toString(),
          "image": await MultipartFile.fromFile(
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
                msg: "La catégorie a été ajoutée avec succès.",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
            else
            {
              Fluttertoast.showToast(
                msg: "Veuillez réesayer de charger la catégorie.",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
          }
          else
          {
            Fluttertoast.showToast(
              msg: "Veuillez réesayer de charger la catégorie.",
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
      progressDialog.dismiss();
      Fluttertoast.showToast(
        msg: "Vérifiez votre connexion internet.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
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
        // await save();
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
              "Voulez-vous ajouter l'entreprise a votre compte ?",
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

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
  @override
  initState() {
    getEntreprise();
    checkNetwork();
    super.initState();
  }

  Widget _categorie(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        child: Center(
          child: TextFormField(
            controller: categorie,
            style: TextStyle(color: Colors.blueGrey),
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez renseigner le Nom de la catégorie svp";
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
              prefixIcon: Icon(
                icon,
                size: 20,
                color: color_grey,
              ),
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
      ),
    );
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
        title: const Text('Option Catalog',
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
            onTap: (){
              // _showPickOptionsDialog_back(context);
              pickFiles();
            },
            child: file_image == null ? Container(
              height: size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.blue.shade50,
              ),
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                  SizedBox(height: 10,),
                  const Text(
                      "Ajoutez l'image de la catégorie",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey
                      ),
                  )
                ],
              ),
            ) : Container(
              height: size.height * 0.4,
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
            padding: EdgeInsets.all(10.0),
            child: _categorie(
              Icons.category,
              'Entrez la catégorie',
              TextInputType.name,
                TextInputAction.done,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: _entreprise(
                Icons.currency_franc_rounded,
                'Devise'
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: size.height * 0.1,
          child: RaisedButton(
              color:  text_color0,
              child: const Text(
                "Sauvegarder",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: ()
              {
                if(_formKey.currentState!.validate())
                  {
                    createCategorie();
                  }
              }
          ),
        ),
      ),
    );
  }
}

class ListItemCategorie {
  String id;
  String entreprise;
  ListItemCategorie(this.id, this.entreprise);
}