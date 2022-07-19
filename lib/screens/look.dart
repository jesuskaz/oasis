import 'package:flutter/material.dart';
import 'package:oasisapp/screens/chat.dart';
import '../tool.dart';

class Look extends StatefulWidget
{
  const Look({Key? key}) : super(key: key);
  @override
  State<Look> createState() => _LookState();
}

class _LookState extends State<Look>
{
  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                UserWidget(pic: 'user1.jpg',),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                          "Mon Look",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                            "Appuyer pour ajuter un look",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              color: color_grey
                            ),
                        )
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right:200),
            child: Text("Mises à jour récentes"),
          ),
          SizedBox(height: 25),
          Expanded(
            child: ListView(
              children: const [
                MessageWidget(family: 'Emeline', pic: 'user2.jpg', time: '23min'),
                MessageWidget(family: 'Selma', pic: 'user1.jpg', time: '26min'),
                MessageWidget(family: 'Jean', pic: 'user9.jpg', time: '33min'),
                MessageWidget(family: 'Sonia', pic: 'user3.jpg', time: '46min'),
                MessageWidget(family: 'Emeline', pic: 'user2.jpg', time: '23min'),
                MessageWidget(family: 'Selma', pic: 'user1.jpg', time: '26min'),
                MessageWidget(family: 'Jean',pic: 'user9.jpg', time: '33min'),
                MessageWidget(family: 'Sonia', pic: 'user3.jpg', time: '46min'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class MessageWidget extends StatelessWidget
{
  const MessageWidget({required this.family, required this.pic, required this.time});

  final String family;
  final String pic;
  final String time;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
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
                  Text("Aujourd'hui à $time", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class UserWidget extends StatelessWidget {
  const UserWidget({required this.pic});
  final String pic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: text_color,
                  borderRadius: BorderRadius.circular(45),
                  image: DecorationImage(image: AssetImage('images/$pic'))
              ),
            ),
          ),
        ),
      ],
    );
  }
}
