import 'package:oasisapp/tool.dart';
import 'package:flutter/material.dart';
import 'package:oasisapp/wallet/component.dart';

import 'appro.dart';
import 'home.dart';

class DetailWalletScreen extends StatefulWidget {
  const DetailWalletScreen({Key? key}) : super(key: key);

  @override
  State<DetailWalletScreen> createState() => _DetailWalletScreenState();
}

class _DetailWalletScreenState extends State<DetailWalletScreen>
{
  @override
  Widget build(BuildContext context)
  {
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
                MaterialPageRoute(builder: (conetext) => Appro()),
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
                MaterialPageRoute(builder: (conetext) => DetailWalletScreen()),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => HomeScreen()),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (conetext) => Appro()),
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

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SafeArea(
          child: appBar(
              left: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.black54)),
              title: 'Oasis-Wallet',
              right: Icon(Icons.more_vert, color: Colors.black54)),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              _cardWallet(
                iconUrl:
                'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Bitcoin-icon.png',
                crypto: 'Bitcoin',
                cryptoShort: 'BTC',
                totalCrypto: '3.519020 BTC',
                total: '\$19.153 USD',
                precent: -2.33,
              ),
              SizedBox(
                height: 15,
              ),
              card(
                padding: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _dot(color: Colors.pink),
                              const Text(
                                'Lower: \$4.896',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _dot(color: Colors.green),
                              const Text(
                                'Higher:\$6.857',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Stack(children: [
                        // LineChart(
                        //   sampleData(),
                        // ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Row(
                            children: [
                              _dot(size: 18, color: text_color),
                              Text(
                                '1BTC=\$5.483',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      text: 'Buy',
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _actionButton(
                      text: 'Sell',
                      color: Colors.pink,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: text_color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavBarHome(Icons.home, 3, "Accueil"),
            buildNavBarAppro(Icons.account_balance_wallet, 0, "Appro"),
            buildNavBarTrans(Icons.send, 2, "Pay"),
            buildNavBarHist(Icons.history, 4, "Historique"),
          ],
        ),
      ),
    );
  }

  Widget _dot({double size = 10, Color color = Colors.black}) {
    return Container(
      margin: EdgeInsets.all(10),
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        child: Container(
          color: color,
        ),
      ),
    );
  }
  Widget _cardWallet({required String crypto, cryptoShort, iconUrl, total, totalCrypto, required double precent}) {
    return card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                '$iconUrl',
                width: 50,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text('$crypto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('$cryptoShort')
            ],
          ),
          SizedBox(height: 20),
          Text(
            '$totalCrypto',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black87),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$total',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black38),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: precent >= 0 ? Colors.green : Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  precent >= 0 ? '+ $precent %' : '$precent %',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Center(
            child: Icon(Icons.keyboard_arrow_down,
                size: 30, color: Colors.black45),
          )
        ],
      ),
    );
  }
  Widget _actionButton({required Color color, required String text}) {
    return card(
        child: Column(
          children: [
            ClipOval(
              child: Material(
                color: color,
                child: InkWell(
                  splashColor: Colors.red, // inkwell color
                  child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 25.0,
                      )),
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('$text', style: TextStyle(fontSize: 24, color: Colors.black54))
          ],
        ));
  }
}

