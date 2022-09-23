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

  Future getSolde() async {
    String url = apiUrl + "solde";

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'});

    print("TOKKKKKENNNNN :::: ${token}");

    if (response.statusCode == 200)
    {
      var r = json.decode(response.body);
      listData = r["data"];
    }
    return listData;
  }
  @override
  void initState() {
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
            height: size.height * 0.20,
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
                        FutureBuilder(
                            future: getSolde(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              print("SNAPSHOT DATA :::: ${snapshot.data}");
                              if (snapshot.data == null) {
                                return const Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(
                                      color: color_white,
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                );
                              }
                              if (snapshot.data.length <= 0) {
                                return Text('USD 0',
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 18, color: color_white));
                              }
                              else
                                {
                                  return Text("${snapshot.data[0]["devise"]} ${snapshot.data[0]["montant"]}",
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 18, color: color_white)
                                  );

                                }
                            }
                        )
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
            height: size.height * 0.20,
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
                              splashColor: text_color, // inkwell color
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
                        FutureBuilder(
                            future: getSolde(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              print("SNAPSHOT DATA :::: ${snapshot.data}");
                              if (snapshot.data == null) {
                                return const Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(
                                      color: color_white,
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                );
                              }
                              if (snapshot.data.length <= 0) {
                                return Text('CDF 0',
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 18, color: color_white));
                              }
                              else
                              {
                                return Text("${snapshot.data[1]["devise"]} ${snapshot.data[1]["montant"]}",
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 18, color: color_white)
                                );
                              }
                            }
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