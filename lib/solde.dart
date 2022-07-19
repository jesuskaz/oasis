import 'package:oasisapp/tool.dart';
import 'package:oasisapp/wallet/component/card.dart';
import 'package:oasisapp/wallet/screen/detail_wallet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Solde extends StatefulWidget
{
  const Solde({Key? key}) : super(key: key);

  @override
  State<Solde> createState() => _SoldeState();
}

class _SoldeState extends State<Solde>
{

  List listData = [];

  Future getSolde() async
  {
    String url = apiUrl + "solde";

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'});

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      if(mounted)
        setState(() {
          listData = r["data"];
        });
    }
  }
  @override
  void initState() {
    getSolde();
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    getSolde();

    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        const SizedBox(width: 20,),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailWalletScreen()),
            );
          },
          child: SizedBox(
            height: size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: cardUSD(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Material(
                            color: text_color1,
                            child: InkWell(
                              splashColor: Colors.orange, // inkwell color
                              child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.money,
                                    color: Colors.orange,
                                    size: 20.0,
                                  )),
                              onTap: () {},
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text('Solde Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: text_color1,
                                  fontSize: taille1
                              )),
                        ),
                        Row(children: const [
                          Text("USD", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text_color1
                          ),),],)
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(listData.isEmpty ? "USD 0" : "${listData[0]["devise"]} ${listData[0]["montant"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 18, color: text_color1),)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailWalletScreen()),
            );
          },
          child: SizedBox(
            height: size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: cardCDF(
                width: MediaQuery.of(context).size.width - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Material(
                            color: text_color1,
                            child: InkWell(
                              splashColor: Colors.orange, // inkwell color
                              child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.money,
                                    color: Colors.green,
                                    size: 20.0,
                                  )),
                              onTap: () {},
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text('Solde Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: text_color1,
                                  fontSize: taille1
                              )),
                        ),
                        Row(children: const [
                          Text("CDF",
                            style: TextStyle(
                                color: text_color1,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],)
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: listData.isEmpty ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      color: Colors.green,
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              )) : Text(listData.isEmpty ? "CDF 0 " : "${listData[1]["devise"]} ${listData[1]["montant"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 18, color: text_color1),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}