import 'package:oasisapp/catalog/component/navbar.dart';
import 'package:oasisapp/catalog/views/home.dart' as homeView;
import 'package:oasisapp/catalog/views/list_entreprise.dart';

import 'package:oasisapp/screens/accueil.dart';
import 'package:oasisapp/screens/appel.dart';
import 'package:oasisapp/screens/look.dart';

import 'package:oasisapp/wallet/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:permission_handler/permission_handler.dart';
import '../tool.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin
{

  bool chat = true;
  bool look = false;
  bool appel = false;

  late AnimationController animationController;
  late Animation degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  late Animation rotationAnimation;

  PageController _pageController = PageController();
  List<Widget> _screens = [Accueil(), Look(), Appel(),];
  List<String> names = [];

  List<String> phones = [];

  _onItemTapped(int selectedIndex) {
    setState(() {
      _pageController.jumpToPage(selectedIndex);
    });
  }
  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }
  Future getContact() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.granted && permission.isGranted)
    {
      Iterable<Contact> _contacts = await ContactsService.getContacts(withThumbnails: false);
      _contacts.forEach((contact)
      {
        setState((){
          contact.phones?.toSet().forEach((phone)
          {
            names.add(contact.givenName.toString());
            phones.add(phone.value.toString());
          });
        });
      });
    }
    else
    {
      print("Error ::: ${permission.isGranted}");
    }
  }

  Future getCredit() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    getContact();
    getCredit();
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController
        , curve: Curves.easeOut));
    super.initState();
    animationController.addListener((){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Container(
        color: Colors.red,
        width: size.width * 0.72,
        child: NavBar(),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color_white),
        backgroundColor: text_color,
        elevation: 1.0,
        centerTitle: true,
        title: const Text('OasisApp', style: style_init),
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: const Icon(
                Icons.search,
                size: 28,
                color: color_white,
              )
          )
        ],
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: _screens,
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
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.add_business_rounded,
                          color: Colors.white,
                        ),
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => List_Entreprise()));
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
      bottomNavigationBar: Container(
        height: size.height * 0.085,
        color: text_color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(1),
                  child: IconButton(
                      onPressed: (){},
                      icon: const Icon(
                          Icons.camera_alt,
                          color: color_grey,
                      )
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  appel = false;
                  look = false;
                  chat = true;
                });
                _onItemTapped(0);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                          "Chat",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: chat == true ? color_white : color_grey
                        ),
                      ),
                      if (chat == true) Container(
                        margin: EdgeInsets.only(top: 3),
                        height: 2,
                        width: 55,
                        color: color_white,
                      ) else Container(),
                    ],
                  ),
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  chat = false;
                  appel = false;
                  look = true;
                });
                _onItemTapped(1);
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                        "Look",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: look ? color_white : color_grey
                        )),
                    look ? Container(
                      margin: EdgeInsets.only(top: 3),
                      height: 2,
                      width: 55,
                      color: color_white,
                    ) : Container()
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  chat = false;
                  look = false;
                  appel = true;
                });
                _onItemTapped(2);
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                          "Appel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: appel ? color_white : color_grey
                          ),
                      ),
                      appel ? Container(
                        margin: EdgeInsets.only(top: 3),
                        height: 2,
                        width: 55,
                        color: color_white,
                      ) : Container(),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final VoidCallback  onClick;

  CircularButton({required this.color, required this.width, required this.height, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
          icon: icon,
          enableFeedback: true,
          onPressed: onClick
      ),
    );
  }
}