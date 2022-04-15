import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';

import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:projectr1/Configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectr1/Navbar.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/page2.dart';
import 'package:projectr1/page3.dart';
import 'package:projectr1/page4.dart';
import 'package:projectr1/page5.dart';
import 'package:projectr1/page6.dart';
import 'package:projectr1/page7.dart';
import 'package:projectr1/page8.dart';
import 'package:projectr1/page9.dart';
import 'package:projectr1/settingble.dart';
import 'package:get/get.dart';
import 'package:projectr1/getx/speedController.dart';

class page10 extends StatefulWidget {
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  final String value1;

  const page10({
    Key? key,
    this.valueTx,
    required this.characteristic,
    required this.value1,
    required this.device,
  }) : super(key: key);

  @override
  _page10State createState() => _page10State();
}

class _page10State extends State<page10> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  final StreamController<bool> _verificationNotifierPassword =
      StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  bool? lockscreen = false;
  String? storedPasscode;
  String? passwordnew;
  String? passwordconfrim;
  BluetoothCharacteristic? characteristic;
  bool statusconnect = false;
  SpeedController speedController = Get.put(SpeedController());
  @override
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Bluetooth"),
          content: new Text("โปรดเชื่อมต่อบลูทูธ"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.characteristic != null) {
      characteristic = widget.characteristic;
    }

    setState(() {
      lockscreen = widget.value1 == '01' ? true : false;
      isAuthenticated = widget.value1 == '01' ? true : false;
    });
    print('########## value1 : ${lockscreen}');
    getStorePassword();
    statusconnecttion();
  }

  getStorePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    storedPasscode = prefs.getString('passwordCode');

    print('storedPasscode : ${storedPasscode}');
  }

  void statusconnecttion() async {
    if (widget.device != null) {
      widget.device!.state.listen((status) {
        print('######### -------- Status ble ---- > ${status}');
        if (status == BluetoothDeviceState.connected) {
          print('connected !!!!!!');
          setState(() {
            statusconnect = true;
          });
        } else {
          print('disconnected !!!!!!');
          setState(() {
            statusconnect = false;
          });
          if (widget.device != null) {
            widget.device!.disconnect();
          }
          //
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Image.asset(
         Config.MAIN_IMAGE_APPBAR.toString(),
          height: 200,
          width: 200,
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              IconButton(
                icon: Icon(
                  Icons.bluetooth,
                  size: 30,
                ),
                onPressed: () {
                  // _showDialog(context);
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: SettingBle(),
                      ));
                },
              ),
              Icon(Icons.circle,
                  color: statusconnect == false ? Colors.red : Colors.green,
                  size: 10),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage("lib/itemol/BGJPG.jpg"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.red.shade900),
                        bottom: BorderSide(color: Colors.red.shade900)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "โหมดล็อคกันขโมย",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Kanit',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'คุณ${isAuthenticated ? 'ล็อคกันขโมย!' : 'ยังไม่ล็อคกันขโมย!'}',
                      style: TextStyle(color: Colors.white),
                    ),
                    _defaultLockScreenButton(context),
                  ],
                ),
              ),
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY00#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page1(
                                characteristic: widget.characteristic,
                                device: widget.device,
                              ),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY01#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page2(
                                  characteristic: widget.characteristic,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY02#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page3(
                                  value: '0',
                                  characteristic: widget.characteristic,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon3.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RB#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page4(
                                  characteristic: widget.characteristic,
                                  value1: 0,
                                  value3: 0,
                                  value2: 0,
                                  value4: 0,
                                  value5: 0,
                                  value6: 0,
                                  value7: 0,
                                  value8: 0,
                                  value9: 0,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon4.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY04#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page5(
                                characteristic: widget.characteristic,
                                device: widget.device),
                          ),
                          (route) => false
                        );
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon5.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY05#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page6(
                                  characteristic: widget.characteristic,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon6.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY06#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page7(
                                  characteristic: widget.characteristic,
                                  value: 0,
                                  value1: 0,
                                  value2: 0,
                                  value3: 0,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon7.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY07#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page8(
                                characteristic: widget.characteristic,
                                value1: 0,
                                value2: 0,
                                device: widget.device),
                          ),
                          (route) => false
                        );
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon8.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (!isAuthenticated) {
                      if (characteristic != null) {
                        widget.characteristic!.write(utf8.encode('RY08#'));
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: page9(
                                  characteristic: widget.characteristic,
                                  value1: 0,
                                  device: widget.device),
                            ),
                          (route) => false);
                      }
                    }
                  },
                  icon: Image.asset('lib/img/icon9.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page10(
                    //               characteristic: widget.characteristic,
                    //               value1: '',
                    //               value2: '',
                    //               value3: '',
                    //               value4: '',
                    //               value5: '',
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon10.1.png'),
                  iconSize: 70,
                ),
                Container(
                  width: _width * 0.45,
                  height: _height / 9,
                  child: Stack(children: [
                    Image.asset(
                      'assets/image/max-speed/frame.png',
                      height: 70,
                    ),
                    Positioned(
                      top: _width * 0.035,
                      right: _width * 0.33,
                      child: Obx(
                        () => Text(
                          '${speedController.speed}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ethnocentric',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: _width * 0.08,
                      right: _width * 0.33,
                      child: Obx(
                        () => Text(
                          '${speedController.max_speed}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Ethnocentric',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: _width * 0.045,
                      left: _width * 0.14,
                      child: Text(
                        'Km/hr',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ethnocentric',
                        ),
                      ),
                    ),
                    Positioned(
                      top: _width * 0.09,
                      left: _width * 0.14,
                      child: const Text(
                        'MAX SPEED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Ethnocentric',
                        ),
                      ),
                    ),
                    Positioned(
                      height: 30,
                      top: _width * 0.04,
                      left: _width * 0.33,
                      child: Obx(() => Image.asset(
                            'assets/image/max-speed/alert${speedController.status_speed}.png',
                          )),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
        color: Colors.grey,
        child: Text('เปิดหน้ารหัสผ่าน'),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.reload();
          _showLockScreen(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _showLockScreen(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'โปรดใส่รหัสผ่านของคุณ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontFamily: 'Kanit'),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black,
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
            bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var storpassword = prefs.getString('passwordCode');
    bool isValid = storpassword == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = !isAuthenticated;
        if (characteristic != null) {
          widget.characteristic!
              .write(utf8.encode('LCY0${isAuthenticated ? '1' : '0'}#'));
        }
      });
    }
  }

  _onPasscodeEnterednewConfirm(String enteredPasscode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isValid = passwordnew == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      prefs.setString('passwordconfirm', enteredPasscode);
      passwordconfrim = prefs.getString('passwordconfirm');
      prefs.setString('passwordCode', '${enteredPasscode}');
      print('รหัสผ่านใหม่อีกครั้ง  ==  ${passwordconfrim}');

      print('รหัสผ่าน ==  ${prefs.getString('passwordCode')}');
      getStorePassword();
      Navigator.maybePop(context);
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  _onPasscodeEnterednew(String enteredPasscode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stor = prefs.getString('passwordCode');
    bool isValid = stor != enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      await prefs.setString('passwordnew', enteredPasscode);
      passwordnew = prefs.getString('passwordnew');
      print('รหัสผ่านใหม่  ==  ${passwordnew}');
      _showResetpasswordconfirm(
        context,
        opaque: false,
        cancelButton: Text(
          'Cancel',
          style: const TextStyle(fontSize: 16, color: Colors.white),
          semanticsLabel: 'Cancel',
        ),
      );
    }
  }

  @override
  void dispose() {
    _verificationNotifier.close();

    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: TextButton(
            child: Text(
              "Reset passcode",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),

            onPressed: !isAuthenticated ? _resetAppPassword : null,
            // splashColor: Colors.white.withOpacity(0.4),
            // highlightColor: Colors.white.withOpacity(0.2),
            // ),
          ),
        ),
      );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showResetpasswordnew(
        context,
        opaque: false,
        cancelButton: Text(
          'Cancel',
          style: const TextStyle(fontSize: 16, color: Colors.white),
          semanticsLabel: 'Cancel',
        ),
      );
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                onAccepted();
              },
            ),
          ],
        );
      },
    );
  }

  _showResetpasswordnew(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'โปรดใส่รหัสผ่านใหม่',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontFamily: 'Kanit'),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEnterednew,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black,
            cancelCallback: () {
              Navigator.pop(context);
            },
            digits: digits,
            passwordDigits: 4,
          ),
        ));
  }

  _showResetpasswordconfirm(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'โปรดใส่รหัสผ่านใหม่อีกครั้ง',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontFamily: 'Kanit'),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEnterednewConfirm,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black,
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
          ),
        ));
  }
}
