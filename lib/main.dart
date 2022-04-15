import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectr1/splash.dart';
import 'package:projectr1/valueProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider<valueProvider>(
          create: (_) => valueProvider(),
        ),
      ], child: MyApp()),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setPassword();
  }

  _setPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var statuslock = prefs.getString('statuslock');
    print(statuslock);
    if (statuslock != 'true') {
      prefs.setString('passwordCode', '1234');
      prefs.setString('uidble', '');
      prefs.setString('bleStep', '0');
      setState(() {
        prefs.setString('statuslock', 'true');
      });
    }
    var code = prefs.getString('passwordCode');
    print('Codepassword : ${code}');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Splash(),
    );
  }
}
