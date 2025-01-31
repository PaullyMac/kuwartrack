import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadLogin extends StatefulWidget {
  const LoadLogin({super.key});

  @override
  State<LoadLogin> createState() => _LoadLoginState();
}

class _LoadLoginState extends State<LoadLogin> {
  Map data = {};

  String time = 'loading';

  // void loadHomePage(email, password) async {
  //   Response response = await get(Uri.parse('http://192.168.0.15/login?Query=${email}&Query2=${password}'));
  //   Map auth = jsonDecode(response.body);
  //   if(auth['user_matched']==true){
  //     Navigator.pushReplacementNamed(context, '/home');
  //   }
  //   else{
  //     Navigator.pop(context, true);
  //   }
  // }

  Future<bool> login(String user, String password) async {
    final url = Uri.parse("https://7611-130-105-115-165.ngrok-free.app/api/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user": user, "password": password}),
    );

    if (response.statusCode == 200) {
      if(jsonDecode(response.body)!=null){ // returns a dictionary-like structure. In this case, Returns true or false
        // Decoding the JSON response
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);

        var userId = decodedResponse['id'];

        Navigator.pushReplacementNamed(context, '/home', arguments: {'user_id': userId});

        return true; // user credentials is correct.
      }
      else{ // user credentials is wrong
        Navigator.pop(context, false);
        return false;
      }
    }
    else {// user credentials is wrong
      Navigator.pop(context, false);
      return false;
      throw Exception("Failed to login: ${response.reasonPhrase}");
    }
  }


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty? data : ModalRoute.of(context)?.settings?.arguments as Map;
    login(data['email'], data['password']);
    return Scaffold(
        backgroundColor: Color(0xFF53197B),
        body: Center(
          child: SpinKitPouringHourGlass(
            color: Colors.white,
            size: 50.0,
          ),
        )
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:kuwartrack/services/world_time.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'dart:convert';
//
// class Loading extends StatefulWidget {
//   @override
//   State<Loading> createState() => _LoadingState();
// }
//
// class _LoadingState extends State<Loading> {
//
//   String time = 'loading';
//
//   void setupWorldTime() async {
//     WorldTime instance = WorldTime(location: 'Berlin', flag: 'germany.png', url: 'Europe%2FBerlin');
//     await instance.getTime();
//     Navigator.pushReplacementNamed(context, '/home', arguments: {
//       'location': instance.location,
//       'flag': instance.flag,
//       'time': instance.time,
//       'isDaytime': instance.isDaytime
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setupWorldTime();
//     print('hey there!');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: Center(
//         child: SpinKitRotatingCircle(
//           color: Colors.white,
//           size: 50.0
//         )
//       ),
//     );
//   }
// }