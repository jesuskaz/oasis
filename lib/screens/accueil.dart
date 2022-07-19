import 'package:flutter/material.dart';
import 'package:oasisapp/screens/chat.dart';
import '../tool.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
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
              child: const Text('Status Récents', style: style_init1,
              )
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
            child: ListView(
              children: const [
                MessageWidget(family: 'Emeline', msg: 'Hello how are you ? i am going to market. do you want burgers?', pic: 'user2.jpg', time: '23min', count: 1),
                MessageWidget(family: 'Selma', msg: 'We were on the runways at the military hanger, there is a plane in it.', pic: 'user1.jpg', time: '26min'),
                MessageWidget(family: 'Jean', msg: 'i received my new watch that i ordered from Amazon.', pic: 'user9.jpg', time: '33min'),
                MessageWidget(family: 'Sonia', msg: 'i just arrived in front of the school. i\'m waiting for you hurry up !', pic: 'user3.jpg', time: '46min'),
                MessageWidget(family: 'Emeline', msg: 'Hello how are you ? i am going to market. do you want burgers?', pic: 'user2.jpg', time: '23min', count: 1),
                MessageWidget(family: 'Selma', msg: 'We were on the runways at the military hanger, there is a plane in it.', pic: 'user1.jpg', time: '26min'),
                MessageWidget(family: 'Jean', msg: 'i received my new watch that i ordered from Amazon.', pic: 'user9.jpg', time: '33min'),
                MessageWidget(family: 'Sonia', msg: 'i just arrived in front of the school. i\'m waiting for you hurry up !', pic: 'user3.jpg', time: '46min'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class MessageWidget extends StatelessWidget {
  const MessageWidget({required this.family, required this.msg, required this.pic, required this.time, this.count = 0});

  final String family;
  final String msg;
  final String pic;
  final String time;
  final int count;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
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
                      image: DecorationImage(image: AssetImage('images/$pic'))
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(family, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(msg, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(time, style: TextStyle(fontSize: 12,  color: count==0 ? Colors.grey.shade800 : Colors.green),),
                  const SizedBox(height: 10),
                  count ==  0
                      ? Container()
                      : CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green.shade600,
                    child: Text('$count', style: const TextStyle(color: Colors.white),),
                  )
                ],
              ),
            )
          ],
        ),
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
