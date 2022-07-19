import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:badges/badges.dart';
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
  Widget build(BuildContext context)
  {
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
