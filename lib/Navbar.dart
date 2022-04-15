import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:projectr1/Configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/settingble.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  TextEditingController? phoneController;
  TextEditingController? phonemainController;
  TextEditingController? nameController;

  void _showDialogStart(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ตั้งค่าเริ่มต้นการใช้งาน',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'Kanit'),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/img/resetpage.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget cancelButton = FlatButton(
          child: Text("ยกเลิก"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        Widget continueButton = FlatButton(
          child: Text("ตกลง"),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('uidble', '');
            prefs.setString('passwordCode', '1234');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => page1(
                          characteristic: null,
                          device: null,
                        )));
          },
        );
        return AlertDialog(
          title: new Text("ล้างค่าการเชื่อมต่อ"),
          content: new Text(
            'ต้องการล้างค่าการเชื่อมต่อหรือไม่ ?',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontFamily: 'Kanit'),
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  void showAlertBar() {
    Flushbar(
      title: "กรุณากรอกเบอร์โทรศัพท์ 10 หลัก",
      message: "กรุณาลองใหม่อีกครั้ง",
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
      padding: EdgeInsets.all(8.0),
    ).show(context);
  }

  void showAlertSuccess() {
    Flushbar(
      title: "เพิ่มเบอร์Sms เรียบร้อยแล้ว",
      icon: Icon(
        Icons.check,
        size: 28.0,
        color: Colors.green[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
      padding: EdgeInsets.all(8.0),
    ).show(context);
  }

  void _showDialogPhone(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phone = prefs.get('phone');
    final _name = prefs.get('name');
    final _phonemain = prefs.get('phonemain');

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Widget cancelButton = FlatButton(
          child: Text("ยกเลิก"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        Widget continueButton = FlatButton(
          child: Text("ตกลง"),
          onPressed: () async {
            String phone = phoneController!.text;
            String phonemain = phonemainController!.text;
            String name = nameController!.text;

            if (phone.length != 10 && phonemain.length != 10 && name.isEmpty) {
              print("กรุณากรอกเบอร์โทร 10 หลัก");
              setState(() {});
              showAlertBar();
            }

            if (phone.length == 10 &&
                phonemain.length == 10 &&
                name.isNotEmpty) {
              print('setString phone');
              // showAlertSuccess();
              prefs.setString("phone", phone);
              prefs.setString("phonemain", phonemain);
              prefs.setString("name", name);
              Navigator.of(context).pop();
            } else {
              print('setString phone faild');
              setState(() {});
            }

            // prefs.setString('phone',);
          },
        );
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text("เพิ่มเบอร์โทรศัพท์สำหรับแจ้งเตือน SMS"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('ชื่อ:'),
                  Text(_name == null ? "ยังไม่ได้เพิ่ม" : _name.toString()),
                ],
              ),
              Row(
                children: [
                  Text('เบอร์โทรผู้รับSMS:'),
                  Text(_phone == null ? "ยังไม่ได้เพิ่ม" : _phone.toString()),
                ],
              ),
              Row(
                children: [
                  Text('เบอร์โทรเจ้าของเครื่อง:'),
                  Text(_phonemain == null
                      ? "ยังไม่ได้เพิ่ม"
                      : _phonemain.toString()),
                ],
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ',
                  hintText: '',
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรผู้รับSMS',
                  hintText: '',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: phonemainController,
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรเจ้าของเครื่อง',
                  hintText: '',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    phoneController = TextEditingController();
    phonemainController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phoneController?.dispose();
    phonemainController?.dispose();
    nameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _launchURLBrowser(String url) async {
      // const url = 'https://www.raceone.net';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // throw 'Could not launch $url';
      }
    }

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  Config.MAIN_IMAGE_APPBAR,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _showDialogStart(context);
                },
                child: Text(
                  'ตั้งค่าเริ่มต้นการใช้งาน',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingBle()));
                },
                child: Text(
                  'เชื่อมต่ออุปกรณ์',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _showDialogPhone(context);
                },
                child: Text(
                  'เพิ่มเบอร์โทรศัพท์',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _launchURLBrowser('https://www.raceone.net/manual');
                },
                child: Text(
                  'คู่มือการใช้งาน',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  // _launchURLBrowser('https://www.raceone.net');
                  _showDialog(context);
                },
                // ต้องการคืนค่าโรงงาน
                //  ยืนยัน    ยกเลิก
                child: Text(
                  'ล้างค่าการเชื่อมต่อ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _launchURLBrowser('https://www.raceone.net/contactus');
                },
                child: Text(
                  'ติดต่อเรา',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
