import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue);

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  bool _passwordVisible = true;
  bool _showError = false;

  Future<bool> _submit() async{
    dynamic result = await Navigator.pushNamed(context, '/load_login', arguments: {'email': _controller1.text, 'password': _controller2.text});

    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        alignment:  Alignment.center,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // Add this line to stretch the Column to full width
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Image.asset('assets/images/logo.png'),
            ),
            Text('Welcome Back!', style: TextStyle(color: Color(0xFF53197B), fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'ABeeZee')),
            Text('Enter your credential to login', style: TextStyle(color: Color(0xFF53197B), fontSize: 20, fontFamily: 'ABeeZee')),
            SizedBox(
              height: 60,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Material(
                color: Colors.transparent,
                elevation: 20.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('assets/images/E-mail.png', width: 30, height: 30)
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Material(
                color: Colors.transparent,
                elevation: 20.0,
                shadowColor: Colors.blue,
                child:TextFormField(
                    controller: _controller2,
                    obscureText: _passwordVisible ,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image.asset('assets/images/Password.png', width: 30, height: 30)
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Enter your Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF53197B),
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )
                    )
                ),
              ),
            ),

            Visibility(visible: _showError,
                child: Text("Username or Password Incorrect",
                    style: TextStyle(color: Colors.red, fontFamily: 'Inter-Black'))
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                child: IconButton(
                  icon: Image.asset('assets/images/Login_button.png'),
                  onPressed: () async {
                    bool show = await _submit();
                    if(show==true){
                      setState(() {
                        _showError = show;
                      });
                    }
                  },
                  highlightColor: Colors.purple, // Disable highlight color
                  hoverColor: Colors.transparent,
                )
            ),

          ],
        ),
      ),
    );
  }

}
