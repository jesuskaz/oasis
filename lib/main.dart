import 'package:oasisapp/catalog/credential/signin.dart';
import 'package:oasisapp/module/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>MyProvider()),
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OasisApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff154a99),
        ),
        home: SigninScreen(),
        // home: MyHomePage(),
        // home: HomePage(),
        // home: Voice(),
    );
  }
}
