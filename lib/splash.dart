import 'package:flutter/material.dart';
import 'package:projectr1/page1.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(seconds: 6), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => page1(
                  characteristic: null,
                  device: null,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            // image: AssetImage("lib/itemol/splash.png"),
            image: AssetImage("assets/image/intro/air-v2-intro.gif"),
          ),
        ),
      ),
    );
  }
}
