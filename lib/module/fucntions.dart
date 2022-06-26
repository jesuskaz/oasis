import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> postToServer({required String api, dynamic body, required Map<String,String> header}) async{
  if (header == null)
    header = {'Content-Type': 'application/json'};
  var res = await http.post(Uri.parse("https://codewitharman.herokuapp.com/$api"), headers: header, body: jsonEncode(body));

  if(res.statusCode == 200)
    return {"msg": "Success", "body": json.decode(utf8.decode(res.bodyBytes))};
  else if (res.statusCode == 404)
    return {"msg": "عدم دسترسی به توابع سرور"};
  else
    return {"msg": json.decode(utf8.decode(res.bodyBytes))['message']};
}