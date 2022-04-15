import 'package:flutter/material.dart';
import 'package:projectr1/Navbar.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/settingble.dart';

class resetpage extends StatefulWidget {
  const resetpage({Key? key}) : super(key: key);

  @override
  _resetpageState createState() => _resetpageState();
}

class _resetpageState extends State<resetpage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Image.asset(
          'lib/img/logo.png',
          height: 200,
          width: 200,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
             
            },
          )
        ],
      ),
    );
  }
}
