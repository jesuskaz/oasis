import 'dart:async';

import 'package:badges/badges.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:oasisapp/tool.dart';
import 'dart:io';
import 'package:oasisapp/wallet/screen/home.dart';
import 'package:oasisapp/wallet/screen/pay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class Article extends StatefulWidget {
  @override
  _Article createState() => _Article();
}

class _Article extends State<Article> with TickerProviderStateMixin {

  TextEditingController article = TextEditingController();
  TextEditingController prix = TextEditingController();
  TextEditingController description = TextEditingController();

  String token = '';
  late String _selectedDevise;
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

  List<ListItem> _dropdownItems = [];
  late List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  late ListItem _selectedItem = ListItem('', '');
  // Categorie
  List<ListItemCategorie> _dropdownItemsCat = [];
  late List<DropdownMenuItem<ListItemCategorie>> _dropdownMenuItemsCat;
  late ListItemCategorie _selectedItemCat = ListItemCategorie('', '');
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;


  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.devise),
          value: listItem,
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<ListItemCategorie>> buildDropDownMenuItemsCat(List listItemsCat) {
    List<DropdownMenuItem<ListItemCategorie>> itemsCat = [];
    for (ListItemCategorie listItemCat in listItemsCat) {
      itemsCat.add(
        DropdownMenuItem(
          child: Text(listItemCat.categorie),
          value: listItemCat,
        ),
      );
    }
    return itemsCat;
  }

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
  Future getDevise() async {
    setState(() {
      process = true;
    });

    String url = apiUrl + "devise";
    response = await http.get(Uri.parse(url),);

    var tab = [];
    if (response.statusCode == 200) {
      try {
        tab = [jsonDecode(response.body)];
      } catch (e) {}
    }
    List<ListItem> _tab = [];
    tab[0]["data"].forEach((element) {
      _tab.add(ListItem(element['id'].toString(), element['devise']));
    });

    if (mounted) {
      setState(() {
        process = false;
        _dropdownItems = _tab;
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

    List<ListItemCategorie> _tabCat = [];
    tab[0]["data"].forEach((element) {
      _tabCat.add(ListItemCategorie(element['id'].toString(), element['categorie']));
      // i += 1;
    });

    if (mounted) {
      setState(() {
        processCat = false;
        _dropdownItemsCat = _tabCat;
      });
    }
  }
  Widget _devise(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color:
                    _selectedItem == null && _dropdownMenuItems.length == 0
                        ? Colors.grey
                        : Colors.black,
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
                  hint: process == false
                      ? const Text(
                    "Choisissez la Devise",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  )
                      : const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 20,
                      width: 20,
                    ),
                  ),
                  value: _selectedItem,
                  items: _dropdownMenuItems,
                  onChanged: (value) {
                    setState(() {
                      // _selectedItem = value;
                      _selectedDevise = _selectedItem.id;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veullez selectionner votre option';
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
  Widget _categorie(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color:
                    _selectedItemCat == null && _dropdownMenuItemsCat.length == 0
                        ? Colors.grey
                        : Colors.black,
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
                  hint: process == false
                      ? const Text(
                    "Choisissez la catégorie",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  )
                      : const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 20,
                      width: 20,
                    ),
                  ),
                  value: _selectedItemCat,
                  items: _dropdownMenuItemsCat,
                  onChanged: (value) {
                    setState(() {
                      // _selectedItem = value;
                      _selectedCat = _selectedItemCat.id;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veullez selectionner votre option';
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
  Future save() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = apiUrl + "article";
      if(file_image != null)
      {
        FormData data = FormData.fromMap({
          "article": article.text,
          "categorie_article_id": _selectedCat.toString(),
          "devise_id": _selectedDevise.toString(),
          "description": description.text,
          "prix": prix.text,
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
                msg: "Votre article a été enregistré avec succès",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
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
          controller: article,
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
    );
  }
  Widget _prix(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: prix,
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
    );
  }

  @override
  initState() {
    checkNetwork();
    getDevise();
    getcategorie();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    if (_dropdownMenuItems.isNotEmpty) {
      _selectedItem = _dropdownMenuItems[0].value!;
      _selectedDevise = _selectedItem.id;
    }

    _dropdownMenuItemsCat = buildDropDownMenuItemsCat(_dropdownItemsCat);
    if (_dropdownMenuItemsCat.isNotEmpty) {
      _selectedItemCat = _dropdownMenuItemsCat[0].value!;
      _selectedCat = _selectedItemCat.id;
    }

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
        title: const Text('Ajouter un article',
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
            padding: EdgeInsets.all(10.0),
            child: _categorie(
                Icons.currency_franc_rounded,
                'Devise'
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _devise(
                Icons.currency_franc_rounded,
                'Devise'
            ),
          ), Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _article(
              Icons.article,
              'Entrez nom article',
              TextInputType.name,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: _prix(
              Icons.money,
              'Entrez le prix',
              TextInputType.number,
              TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _description(
              Icons.description_outlined,
              'Entrez la description',
              TextInputType.name,
              TextInputAction.done,
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

class ListItem {
  String id;
  String devise;
  ListItem(this.id, this.devise);
}

class ListItemCategorie {
  String id;
  String categorie;
  ListItemCategorie(this.id, this.categorie);
}