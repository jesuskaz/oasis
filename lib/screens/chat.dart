import 'dart:convert';

import 'package:oasisapp/send_menu_items.dart';
import 'package:oasisapp/tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class ChatPage extends StatefulWidget {
  String receiver_id;
  String name;

  ChatPage(this.receiver_id, this.name);

  @override
  State<StatefulWidget> createState()
  {
    return ChatPageState();
  }
}
class ChatPageState extends State<ChatPage> {

  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status

  String auth = "chatapphdfgjd34534hjdfk"; //auth key
  String ontap = '';

  List<MessageData> msglist = [];
  TextEditingController msgtext = TextEditingController();

  String user_id = '';
  bool message_not_send = true;

  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    channelconnect();
    getUser_id();
    super.initState();
  }

  void getUser_id() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getString("user_id").toString();
    });
  }
  channelconnect() async {
    //function to connect

    try{
      channel = IOWebSocketChannel.connect("ws://192.168.43.3:6060/${widget.receiver_id}"); //channel IP : Port
      channel.stream.listen((message)
      {
        setState(()
        {
          if(message == "connected")
          {
            connected = true;
            setState(() { });
          }
          else if(message == "send:success")
          {
            setState(() {
              msgtext.text = "";
            });
          }
          else if(message == "send:error")
          {
            setState(() {
              message_not_send = true;
            });
          }
          else if (message.substring(0, 6) == "{'cmd'")
          {
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);

            //on message receive, add data to model
            setState(() { //update UI after adding data to message model
              msglist.add(MessageData(msgtext: jsondata["msgtext"], userid: jsondata["userid"].toString(), receiver_id: jsondata["receiver_id"].toString(), isme: false,));
            });
          }
        });
      },
        onDone: ()
        {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print("Error: ${error.toString()}");
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }
  Future<void> sendmsg(String sendmsg) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    user_id = pref.getString("user_id").toString();

    if(connected == true)
    {
      String msg = "{'auth':'$auth','cmd':'send','userid': '${user_id}', 'receiver_id': '${widget.receiver_id}', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: user_id, receiver_id: widget.receiver_id, isme: true));
      });
      channel.sink.add(msg); //send message to reciever channel
    }
    else
      {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  void showModal(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height/2,
            color: Color(0xff737373),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: 500,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 16,),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListView.builder(
                        itemCount: menuItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: menuItems[index].color.shade50,
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(menuItems[index].icons,size: 20,color: menuItems[index].color.shade400,),
                              ),
                              title: Text(menuItems[index].text),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: text_color,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: color_white,),
                  ),
                  SizedBox(width: 2,),
                  const CircleAvatar(
                    backgroundImage: AssetImage("images/userImage2.jpeg"),
                    maxRadius: 20,
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${widget.name}", style: TextStyle(fontWeight: FontWeight.w600, color: color_white),),
                        const SizedBox(height: 6,),
                        connected ? const Text("Online",style: TextStyle(color: color_white, fontSize: 12),) : Container(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.call, color: color_white,),
                        SizedBox(width: 15,),
                        Icon(Icons.videocam, color: color_white,),
                      ],
                    ),
                  ),
                  Icon(Icons.more_vert,color: color_white),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            child: Stack(
              children: [
                Positioned(
                  top:0,bottom:70,left:0, right:0,
                  child:Container(
                      padding: EdgeInsets.all(2),
                      child: SingleChildScrollView(
                          child: Column(
                            children: msglist.map((onemsg) {
                              return Container(
                                  margin: EdgeInsets.only( //if is my message, then it has margin 40 at left
                                    left: onemsg.isme ? 0:0,
                                    right: onemsg.isme ? 0:0, //else margin at right
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10,right: 16,top: 10,bottom: 10),
                                    child: Align(
                                      alignment: (onemsg.isme ? Alignment.topRight : Alignment.topLeft),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: (onemsg.isme ? text_color : Colors.blueGrey),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Text(onemsg.msgtext, style: const TextStyle(
                                            fontSize: 17,
                                          color: Colors.white
                                        )),
                                      ),
                                    ),
                                  ),
                              );
                            }).toList(),
                          ),
                      )
                  )
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10,bottom: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          showModal();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.attach_file,color: Colors.white,size: 21,),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 300.0,
                            ),
                            child: TextField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: msgtext,
                              decoration: InputDecoration(
                                  hintText: "Message...",
                                  hintStyle: TextStyle(color: Colors.grey.shade500),
                                  border: InputBorder.none
                              ),
                              onChanged: (value){
                                setState(() {
                                  ontap = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                            onPressed: ()
                            {
                              if(msgtext.text != "")
                              {
                                sendmsg(msgtext.text); //send message with webspcket
                              }else {
                                print("Enter message");
                              }
                            },
                            child: Icon(Icons.emoji_emotions,color: Colors.white, size: 18,),
                            backgroundColor: text_color,
                            elevation: 0,
                          ),
                        ),
                      ),
                      ontap != '' ? Container(
                        padding: EdgeInsets.all(5),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                            onPressed: ()
                            {
                              if(msgtext.text != "")
                              {
                                sendmsg(msgtext.text); //send message with webspcket
                              }
                              else
                                {
                                print("Enter message");
                              }
                            },
                            child: Icon(Icons.send,color: Colors.white, size: 18,),
                            backgroundColor: text_color,
                            elevation: 0,
                          ),
                        ),
                      ) :
                      Container(
                        padding: EdgeInsets.all(5),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                            onPressed: ()
                            {
                              if(msgtext.text != ""){
                                sendmsg(msgtext.text); //send message with webspcket
                              }else {
                                print("Enter message");
                              }
                            },
                            child: Icon(Icons.keyboard_voice_rounded,color: Colors.white, size: 18,),
                            backgroundColor: text_color,
                            elevation: 0,
                          ),
                        ),
                      ) ,
                    ],
                  ),
                ),
              ),
            ],),
        ),
    );
  }
}
class MessageData { //message data model
  String msgtext, userid, receiver_id;
  bool isme;
  MessageData({required this.msgtext, required this.userid, required this.receiver_id, required this.isme});
}