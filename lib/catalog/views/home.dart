import 'package:badges/badges.dart';
import 'package:oasisapp/catalog/credential/signup.dart';
import 'package:oasisapp/screens/homepage.dart';
import 'package:oasisapp/wallet/screen/appro.dart';
import 'package:oasisapp/wallet/screen/historique.dart';
import 'package:oasisapp/wallet/screen/home.dart';
import 'package:oasisapp/wallet/screen/pay.dart';
import 'package:flutter/material.dart';
import 'package:oasisapp/catalog/views/detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../loading.dart';
import '../../tool.dart';
import 'cartdetail.dart';
import 'navbar.dart';

class Home extends StatefulWidget {
  String id;
  String iconUrl;
  String phone;
  String email;
  String titre;

  Home(this.id, this.iconUrl, this.phone, this.email, this.titre);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  int numOfItems = 1;
  int quantiteValue = 1;
  int quantiteValue2 = 0;
  int quantitee = 0;

  late AnimationController animationController;
  late Animation degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  late Animation rotationAnimation;

  late String token;
  late http.Response response;

  Future getQuantite() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    var quantite;
    String url = apiUrl + "panier";
    response = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200)
    {
      var d = jsonDecode(response.body);
      if (d['status'] == true)
      {
        var a = d['data']['panier'] as List;

        for (int j = 0; j < a.length; j++)
        {
          quantite = a[j]['qte'].toString();
        }
        quantitee = int.parse(quantite);
      }
    }
    return quantitee;
  }
  Future addPanier() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    String url = apiUrl + "panier";
    var res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': "Bearer $token", 'Accept': 'application/json; charset=UTF-8',
        },
        body: {
          "id": "452",
          "qte": "1",
        });

    if (res.statusCode == 200)
    {
      var data = jsonDecode(res.body);
      if(data["status"] == true)
      {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Text(
                "${data['message']}\nVoulez-vous procédé au paiement maintenant ?"),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("NON"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("OUI"),
                textColor: Colors.white,
                color: text_color0,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartDetail(""),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
      else
      {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("${data['message']}"),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("Ok"),
                textColor: Colors.white,
                color: text_color0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
    else
    {
      Fluttertoast.showToast(
        msg: "Echec lors de l'ajout au panier",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }
  Future getArticle() async {

    String url = apiUrl + "article/entreprise/${widget.id}";

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'});

    var rep;
    if (response.statusCode == 200) {

      var r = jsonDecode(response.body);
      if(r["status"] == true)
        {
          rep = r["data"]["data"];
        }
    }

    return rep ?? [];
  }

  int _selectedItemIndex = 0;
  GestureDetector buildNavBarAppro(IconData iconLink, int index, String message) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
            border:
            Border(bottom: BorderSide(width: 4, color: text_color0)),
            gradient: LinearGradient(colors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.016),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
            : BoxDecoration(),
        // ignore: deprecated_member_use
        child: RaisedButton(
          padding: EdgeInsets.only(top: 5),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Appro()),
            );
          },
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Icon(
                iconLink,
                color:
                index == _selectedItemIndex ? text_color0 : text_color2,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
  GestureDetector buildNavBarTrans(IconData iconLink, int index, String message) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
            border:
            Border(bottom: BorderSide(width: 4, color: text_color0)),
            gradient: LinearGradient(colors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.016),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
            : BoxDecoration(),
        // ignore: deprecated_member_use
        child: RaisedButton(
          padding: EdgeInsets.only(top: 5),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (conetext) => Pay()),
            );
          },
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Icon(
                iconLink,
                color:
                index == _selectedItemIndex ? text_color0 : text_color2,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
  GestureDetector buildNavBarHome(IconData iconLink, int index, String message) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
            border:
            Border(bottom: BorderSide(width: 4, color: text_color0)),
            gradient: LinearGradient(colors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.016),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
            : BoxDecoration(),
        // ignore: deprecated_member_use
        child: RaisedButton(
          padding: EdgeInsets.only(top: 5),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (conetext) => HomeScreen()),
            );
          },
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Icon(
                iconLink,
                color:
                index == _selectedItemIndex ? text_color0 : text_color2,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
  GestureDetector buildNavBarHist(IconData iconLink, int index, String message) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 60,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
            border:
            Border(bottom: BorderSide(width: 4, color: text_color0)),
            gradient: LinearGradient(colors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.016),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
            : BoxDecoration(),
        // ignore: deprecated_member_use
        child: RaisedButton(
          padding: EdgeInsets.only(top: 5),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (conetext) => Historique()),);
          },
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Icon(
                iconLink,
                color:
                index == _selectedItemIndex ? text_color0 : text_color2,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener((){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void showAlertDialog(BuildContext context) {
      // ignore: deprecated_member_use
      Widget continueButton = FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Ok",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: text_color0,
            ),
          ));
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text(
          "Information ! ",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: const [
              Text(
                "Votre panier est encore vide. Veuillez le remplir pour en savoir plus",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                textAlign: TextAlign.justify,
              ),
            ]),
          ],
        ),
        actions: [
          continueButton,
        ],
      );
      // Show the dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          });
    }

    bool _folded = true;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Container(
        color: Colors.red,
        width: size.width * 0.72,
        child: NavBar(),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
            '${widget.titre}',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Colors.white)),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                if (quantiteValue == 0) {
                  showAlertDialog(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartDetail("token"),),);
                }
              },
              child: Badge(
                badgeContent: FutureBuilder(
                  future: getQuantite(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text('');
                    }
                    else
                      {
                        quantitee = snapshot.data;
                        return Text(
                          "${snapshot.data}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        );
                      }
                  },
                ),
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCFAF8),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          setState(() {});
        },
        child: Column(
          children: [
            Hero(
                tag: widget.iconUrl,
                child: Container(
                    height: size.height * 0.2, width: double.infinity,
                    decoration: BoxDecoration(image:
                    DecorationImage(image: NetworkImage(widget.iconUrl), fit: BoxFit.cover)))
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.email, color: text_color0,),
                    Text(widget.email, style: TextStyle(color: text_color0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [Icon(Icons.phone, color: text_color0,),
                    Text(widget.phone, style: TextStyle(color: text_color0, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            Divider(thickness: 10,),
            Divider(),
            FutureBuilder(
                future: getArticle(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      height: size.height * 0.4,
                      child: const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            color: text_color,
                          ),
                          height: 40,
                          width: 40,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data.length <= 0) {
                    return Center(
                      child: const Text('Aucun Article existant',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold
                          )),
                    );
                  }
                  return Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          final liste = snapshot.data[index];
                          return Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 3.0,
                                            blurRadius: 5.0)
                                      ],
                                      color: Colors.white),
                                  child: Column(children: [
                                    Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [ IconButton(
                                              onPressed: (){
                                                addPanier();
                                              },
                                              icon: const Icon(Icons.shopping_cart_rounded,
                                                  color: text_color0),
                                            ), IconButton(
                                              onPressed: () async {
                                                const url = "https://pub.dev/packages/share_plus/install";

                                                final parser = Uri.parse(url);
                                                final response = await http.get(parser);
                                                // await Share.share(url);
                                                final byte = response.bodyBytes;

                                                // final temp = await getTemporaryDirectory();
                                                final path = '${liste["image"]}';
                                                // File(path).writeAsBytesSync(byte);

                                              },
                                              icon: Icon(Icons.share, color: text_color0),
                                            )])),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail(assetPath: liste["image"], prix:liste["prix"], devise: liste["devise"], titre: liste["article"], description: liste["description"], id_article: liste["id"])));
                                      },
                                      child: Hero(
                                          tag: liste["image"],
                                          child: Container(
                                              height: 80.0, width: 80.0,
                                              decoration: BoxDecoration(image:
                                              DecorationImage(image: NetworkImage(liste["image"]), fit: BoxFit.cover)))
                                      ),
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(liste["article"], style: const TextStyle(color: text_color0,
                                        fontFamily: 'Varela',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 10,),
                                    Text("${liste["prix"].toString()} ${liste["devise"]}", style: const TextStyle(color: text_color0, fontFamily: 'Varela', fontSize: 14.0)),
                                    Padding(padding: EdgeInsets.all(8.0), child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                                    Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0), child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,))])));
                        }
                    ),
                  );
                }
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: text_color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavBarHome(Icons.home, 0, "Accueil"),
            buildNavBarAppro(Icons.account_balance_wallet, 1, "Appro"),
            buildNavBarTrans(Icons.send, 2, "Pay"),
            buildNavBarHist(Icons.history, 3, "Historique"),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
              right: 10,
              bottom: 10,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225),degTwoTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: text_color3,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180),degThreeTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degThreeTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: Color(0xFFEF7532),
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        },
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: CircularButton(
                      color: text_color,
                      width: 50,
                      height: 50,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onClick: ()
                      {
                        if (animationController.isCompleted)
                        {
                          animationController.reverse();
                        }
                        else
                        {
                          animationController.forward();
                        }
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}