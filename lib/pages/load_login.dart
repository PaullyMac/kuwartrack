import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadLogin extends StatefulWidget {
  const LoadLogin({super.key});

  @override
  State<LoadLogin> createState() => _LoadLoginState();
}

class _LoadLoginState extends State<LoadLogin> {
  Map data = {};
  String time = 'loading';

  Future<bool> login(String user, String password) async {
    if (!mounted) return false;
    
    await Future.delayed(Duration(seconds: 2));

    if (user == 'admin' && password == 'admin') {
      if (!mounted) return false;
      // Change this line back to navigate to home
      Navigator.pushReplacementNamed(context, '/home', arguments: {'user_id': 'admin'});
      return true;
    } else {
      if (!mounted) return false;
      Navigator.pop(context, false);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings?.arguments as Map;
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