import 'package:flutter/material.dart';
import 'package:oasisapp/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tool.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil>
{

  var users;
  List user_final = [];
  String user_id = '';

  bool checker = false;

  void getUser_id() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getString("user_id").toString();
    });
  }

  Future getContact() async {
    String url = apiUrl + "users";
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token").toString();

    final response = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token", "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200)
    {
      var r = jsonDecode(response.body);
      if(r["status"] == true)
      {
        users = r["data"];
        if(users["current_page"] >= 1)
        {
            user_final = users["data"];
        }
      }
    }
    return user_final;
  }

  @override
  initState()
  {
    getUser_id();
  }
  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.only(right: size.width * 0.60),
              child: const Text('Status Récents', style: style_init1)
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                UserWidget(family: 'Selma', pic: 'user1.jpg',),
                UserWidget(family: 'Emeline', pic: 'user2.jpg',),
                UserWidget(family: 'Sonia', pic: 'user3.jpg',),
                UserWidget(family: 'Jean', pic: 'user9.jpg',),
                UserWidget(family: 'Jack', pic: 'user5.jpg',),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(height: 25),
          Expanded(
              child: FutureBuilder(
                future: getContact(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData ?  ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext ctx, index)
                      {
                        String receiver_id = user_final[index]["id"].toString();
                        String name = user_final[index]["name"].toString();
                        
                         return user_id != receiver_id ?
                        GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiver_id, name)));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(color: text_color, borderRadius: BorderRadius.circular(40),),
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child: Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(45),
                                          image: DecorationImage(image: AssetImage('images/user2.jpg'))
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user_final[index]["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text("Hello how are you ?", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),)
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Text('23min', style: TextStyle(fontSize: 12,  color: 1==0 ? Colors.grey.shade800 : Colors.green),),
                                      const SizedBox(height: 10),
                                      1 ==  0
                                          ? Container()
                                          : CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.green.shade600,
                                        child: Text('1', style: const TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ) : Container();
                      }
                  ) : Container(
                    height: 400,
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
                },
              )
          )
        ],
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({required this.family, required this.pic});
  final String family;
  final String pic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: text_color,
            borderRadius: BorderRadius.circular(45),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45),
            ),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  color: text_color,
                  borderRadius: BorderRadius.circular(45),
                  image: DecorationImage(image: AssetImage('images/$pic'))
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(family, style: const TextStyle(fontWeight: FontWeight.bold),)
      ],
    );
  }
}
