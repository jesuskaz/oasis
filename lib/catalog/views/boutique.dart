import 'package:chat_project/tool.dart';
import 'package:chat_project/catalog/views/detail.dart';
import 'package:chat_project/catalog/views/product_model.dart';
import 'package:flutter/material.dart';

class Boutique extends StatefulWidget {
  const Boutique({Key? key}) : super(key: key);

  @override
  _BoutiqueState createState() => _BoutiqueState();
}

class _BoutiqueState extends State<Boutique> {
  List products = [
    {
      "titre": "Cookie mint",
      "produit": "images/cookiemint.jpg",
      "prix": "100",
      "devise": "\$",
      "type": "p"
    },
    {
      "titre": "Cookie mint",
      "produit": "images/cookiecream.jpg",
      "prix": "150",
      "devise": "\$",
      "type": "p"
    },
    {
      "titre": "Cookie mint",
      "produit": "images/cookieclassic.jpg",
      "prix": "120",
      "devise": "\$",
      "type": "p"
    },
    {
      "titre": "Cookie mint",
      "produit": "images/cookiemint.jpg",
      "prix": "500",
      "devise": "\$",
      "type": "p"
    },
  ];

  List boutiques = [
    {"titre": "Magasin Shoes", "produit": "images/shoes.jpg", "type": "b"},
    {"titre": "Magasin Phone", "produit": "images/iphone2.jpg", "type": "b"},
    {"titre": "Magasin Vr", "produit": "images/casque.jpeg", "type": "b"},
    {"titre": "Magasin Librairie", "produit": "images/bookin.jpg", "type": "b"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_white,
      appBar: AppBar(
        backgroundColor: color_white,
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: InkResponse(
            onTap: () => print("Menu"),
            child: const Icon(
              Icons.menu,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ),
        title: Container(
          child: Text("Logo"),
        ),
        centerTitle: true,
        actions: <Widget>[
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12.0, right: 20),
                child: InkResponse(
                  child: Icon(
                    Icons.shopping_basket,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 8.0,
                right: 16,
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                      color: color_orange,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Center(
                    child: Text(
                      "5",
                      style: TextStyle(
                          color: color_white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkResponse(
              child: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              const Image(image: AssetImage("images/casque.jpeg")),
              Positioned(
                left: 20,
                bottom: 30,
                right: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.0,
                    ),
                    Container(
                      height: 70.0,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage("images/casque_simple.jpeg"),
                            height: 60,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Samsung Gear VR ",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Pour Gamers",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: 70,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(10),
                                    onPressed: () {},
                                    color: Colors.orange,
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          ProductCarousel(title: "Articles Populaires", prod: products),
          ProductCarousel(title: "Magasins disponibles", prod: boutiques),
        ],
      ),
    );
  }
}

class ProductCarousel extends StatelessWidget
{
  late final String title;
  late final List prod;

  ProductCarousel({
    required this.title,
    required this.prod,
  });
  _buildProductCard(int index)
  {
    return Padding(
        padding:
        prod[index]["type"] == "p" ? EdgeInsets.only(top: 10.0, bottom: 80.0, left: 5.0, right: 5.0) :
        EdgeInsets.only(top: 5.0, bottom: 120.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: () => Container()))
            },
            child: prod[index]["type"] == "b" ?
            Container(
              width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            // Icon(Icons.share, color: Color(0xFFEF7532)),
                          ])),
                  Hero(
                      tag: prod[index]["produit"].toString(),
                      child: Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      prod[index]["produit"].toString()),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 7.0),
                  Text(
                      "${prod[index]["prix"]} ${prod[index]["devise"]}",
                      style: const TextStyle(
                          color: Color(0xFFCC8053),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Text(prod[index]["titre"].toString(),
                      style: const TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                                Icons.share,
                                color: Color(0xFFD17E50),
                                size: 20.0
                            ),
                            Icon(
                                Icons.visibility,
                                color: Color(0xFFD17E50
                                ),
                                size: 20.0),
                          ]))
                ])) :
            Container(
                width: 140,
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
                          children: const [
                            Icon(Icons.favorite_border, color: Color(0xFFEF7532)),
                            Icon(Icons.share, color: Color(0xFFEF7532)),
                          ])),
                  Hero(
                      tag: prod[index]["produit"].toString(),
                      child: Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      prod[index]["produit"].toString()),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 7.0),
                  Text(
                      "${prod[index]["prix"]} ${prod[index]["devise"]}",
                      style: const TextStyle(
                          color: Color(0xFFCC8053),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Text(prod[index]["titre"].toString(),
                      style: const TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(Icons.shopping_basket,
                                color: Color(0xFFD17E50), size: 12.0),
                            Text('Ajouter au panier',
                                style: TextStyle(
                                    fontFamily: 'Varela',
                                    color: Color(0xFFD17E50),
                                    fontSize: 12.0))
                          ]))
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: color_orange),
              child: FlatButton(
                onPressed: () => Container(),
                child: const Text(
                  "Voir Plus",
                  style: TextStyle(color: color_white),
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        height: 280.0,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: prod.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildProductCard(index);
            }),
      )
    ]);
  }
}
