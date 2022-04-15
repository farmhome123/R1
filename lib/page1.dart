import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:projectr1/Configs/config.dart';
import 'package:projectr1/getx/speedController.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:projectr1/Navbar.dart';
import 'package:projectr1/page10.dart';
import 'package:projectr1/page2.dart';
import 'package:projectr1/page3.dart';
import 'package:projectr1/page4.dart';
import 'package:projectr1/page5.dart';
import 'package:projectr1/page6.dart';
import 'package:projectr1/page7.dart';
import 'package:projectr1/page8.dart';
import 'package:projectr1/page9.dart';
import 'package:projectr1/settingble.dart';
import 'package:url_launcher/url_launcher.dart';

class page1 extends StatefulWidget {
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page1(
      {Key? key,
      this.valueTx,
      required this.characteristic,
      required this.device})
      : super(key: key);

  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  BluetoothCharacteristic? characteristic;
  double? speed;
  double? latitude;
  double? longitude;
  List<int>? speedAlert;
  bool statusconnect = false;
  int? sumValue;
  Random random = new Random();
  bool? isSendline;
  Timer? _timer;
  int _start = 15;
  SpeedController speedController = Get.put(SpeedController());
  void showAlertBrake() {
    Flushbar(
      title: "เกิดการเบรคกระทันหัน",
      message: "เกิดการเบรคกระทันหัน",
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

  Future<Null> _sendSMS(int sms_speed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phoneSms = prefs.get('phone');
    final _phoneSmsmain = prefs.get('phonemain');
    final _name = prefs.get('name');

    final url =
        Uri.parse("https://torqueair.komkawila.com/$_phoneSms/$_phoneSmsmain");

    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      print('locationSettings :android ');
      locationSettings = AndroidSettings(
        // accuracy: LocationAccuracy.best,
        // distanceFilter: 2,
        // forceLocationManager: false,
        intervalDuration: const Duration(milliseconds: 500),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
          // accuracy: LocationAccuracy.high,
          // distanceFilter: 100,
          // pauseLocationUpdatesAutomatically: true,

          );
    } else {
      print('locationSettings orter');
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    try {
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((position) async {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        if (latitude != null && longitude != null) {
          var data = {
            "message":
                "${latitude!.toStringAsFixed(6)},${longitude!.toStringAsFixed(6)}",
            "name": "${_name.toString()}",
            "speed": "${sms_speed.toString()}"
          };
          if (isSendline == true) {
            print("latitude ==> ${latitude}");
            print("longitude ==> ${longitude}");
            var response = await http.post(url, body: data);
            print('url ==> $url');
            print('body ==> $data');
            if (response.statusCode == 200) {
              print('_phoneSms success');
              setState(() {
                isSendline = false;
              });
            } else {
              print('_phoneSms faild');
              setState(() {
                isSendline = true;
              });
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

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
    speedAlert = [];
    checkPermission();
    isSendline = true;
    print('โหมด  AI SPORT');
    print('send to esp RY0102#');
    setState(() {
      setState(() {
        characteristic = widget.characteristic;
      });
    });
    statusconnecttion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;
    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Localtion Service ปิดอยู่ ?'),
              content: Text(
                  'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                    //await Geolocator.openLocationSettings();
                    // exit(0);
                    // Find LatLang
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Find LatLang
          findSpeed();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Localtion Service ปิดอยู่ ?'),
              content: Text(
                  'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                    // await Geolocator.openLocationSettings();
                    // exit(0);
                    // Find LatLang
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Find LatLng
          findSpeed();
        }
      }
    } else {
      print('Service Location Close');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Localtion Service ปิดอยู่ ?'),
          content: Text(
              'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                //await Geolocator.openLocationSettings();
                // exit(0);
                // Find LatLang
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<Null> findSpeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phoneSms = prefs.get('phone');
    final _phoneSmsmain = prefs.get('phonemain');
    if (_phoneSms != null && _phoneSmsmain != null) {
      print('Find findSpeed');
      late LocationSettings locationSettings;
      if (defaultTargetPlatform == TargetPlatform.android) {
        print('locationSettings :android ');
        locationSettings = AndroidSettings(
          // accuracy: LocationAccuracy.best,
          // distanceFilter: 2,
          // forceLocationManager: false,
          intervalDuration: const Duration(milliseconds: 500),
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
            // accuracy: LocationAccuracy.high,
            // distanceFilter: 100,
            // pauseLocationUpdatesAutomatically: true,

            );
      } else {
        print('locationSettings orter');
        locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
      }
      int count = 0;
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((position) async {
        var speedInMps = await position.speed; // this is your speed
        // print('speedInMps = $speedInMps');
        var speedTest = double.parse(speedInMps.toString());
        setState(() {
          speed = double.parse('${speedInMps}');
          if ((speed! * 3.7).toInt() < 0 )
            speed = 0;

          // var speedsum = (speed! * 3.7);
          Get.find<SpeedController>().incrementspeed((speed! * 3.7).toInt());
          // Get.find<SpeedController>().incrementspeed(90);
        });

        if (speed != null) {
          // int randomNumber = random.nextInt(90) + 10;
          print(' ${(speedTest * 10000)} speedTest');
          // print('random speed ==>$randomNumber');

          if (speedAlert!.length < 4) {
            if (speedTest > 0) {
              setState(() {
                // speedAlert!.add((speedTest * 10000).toInt());
                speedAlert!.add((speedTest * 3.7).toInt());
              });
            }
            // speedAlert!.add((randomNumber));
            print("speedAlert!.length ==> ${speedAlert!.length}");
            if (speedAlert!.length == 4) {
              print('speedAlert![${speedAlert!.length}] ===> ${speedAlert!}');
              int sum = speedAlert!.first - speedAlert!.last;
              print('speed 1 - 4 == > ${sum}');
              setState(() {
                sumValue = sum;
              });
              if (sum >= 50) {
                print('แจ้งเตือนแบกกระทันหัน');
                // showAlertBrake();
                _sendSMS(speedAlert![0].toInt());
                _modalCallPhone(context);

                setState(() {});
              } else {
                speedAlert!.removeAt(0);
              }
            }
          }
        }
      });
    } else {
      print('ไม่มีเบอร์SMS');
      showAlertBar();
    }
  }

  void _modalCallPhone(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phoneSms = prefs.get('phone');

    showModalBottomSheet<void>(
        isDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          const oneSec = const Duration(seconds: 1);
          _timer = new Timer.periodic(
            oneSec,
            (Timer timer) {
              if (_start == 0) {
                Navigator.pop(context);
                setState(() {
                  isSendline = true;
                  speedAlert = [];
                  _start = 15;
                  timer.cancel();
                });
              } else {
                setState(() {
                  _start--;
                  print(_start);
                });
              }
            },
          );
          return Container(
            color: Colors.black,
            child: Wrap(
              children: <Widget>[
                ListTile(
                    trailing: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        isSendline = true;
                        _timer!.cancel();
                        speedAlert = [];
                        _start = 15;
                      });
                    }),
                Divider(
                  height: 1,
                  color: Colors.red,
                ),
                ListTile(
                    leading: Text(
                      'ติดต่อฉุกเฉิน',
                      style: TextStyle(color: Colors.white),
                    ),
                    title: Text('$_phoneSms',
                        style: TextStyle(color: Colors.white)),
                    trailing: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      launch(
                        "tel://$_phoneSms",
                      );
                      setState(() {
                        isSendline = true;
                        _timer!.cancel();
                        speedAlert = [];
                        _start = 15;
                      });
                    }),
                Divider(
                  height: 1,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Text('ติดต่อฉุกเฉิน',
                      style: TextStyle(color: Colors.white)),
                  title: Text('191', style: TextStyle(color: Colors.white)),
                  trailing: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    launch("tel://191");
                    setState(() {
                      isSendline = true;
                      _timer!.cancel();
                      speedAlert = [];
                      _start = 15;
                    });
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.red,
                ),
                ListTile(
                  leading: Text('ติดต่อฉุกเฉิน',
                      style: TextStyle(color: Colors.white)),
                  title: Text('1669', style: TextStyle(color: Colors.white)),
                  trailing: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    launch("tel://1669");
                    setState(() {
                      isSendline = true;
                      _timer!.cancel();
                      speedAlert = [];
                      _start = 15;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  // void _modalCallPhone(context) {
  //   final _bildListTile = (
  //     IconData icon,
  //     String title,
  //   ) =>
  //       ListTile(
  //         leading: Icon(icon),
  //         title: Text(title),
  //         onTap: () {
  //           Navigator.pop(context);
  //           // _pickImage(imageSource);
  //         },
  //       );
  //   showBottomSheet(
  //     backgroundColor: Colors.blue[50],
  //     context: context,
  //     builder: (BuildContext bc) => Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         _bildListTile(
  //           Icons.photo_camera,
  //           "Take a picture from camera",
  //         ),
  //         _bildListTile(
  //           Icons.photo_library,
  //           "Take a picture from gallery",
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showAlertBar() {
    Flushbar(
      title: "คุณยังไม่ได้เพิ่มเบอร์ SMS",
      message: "กรุณาเพิ่มเบอร์มือถือ",
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
          Config.MAIN_IMAGE_APPBAR,
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
                        "โหมดการขับขี่เริ่มต้น",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Ethnocentric',
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
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      // height: 300,
                      child: Column(
                        children: [
                          speed != null
                              ? Text(
                                  '${(speed! * 3.7).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontFamily: 'Ethnocentric',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  " ",
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontFamily: 'Ethnocentric',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                          Expanded(
                            child: Text(
                              "กิโลเมตร/ชม.",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Text(
                              "โหมดการขับขี่เริ่มต้น",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Kanit',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              "จะไม่มีการปรับแต่งค่าใดระหว่างการใช้งาน",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // Expanded(
                          //   child: Obx(() => Text(
                          //         "Colors ===> ${speedController.status_speed}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontFamily: 'Kanit',
                          //             color: Colors.white),
                          //         textAlign: TextAlign.start,
                          //       )),
                          // ),
                          // Expanded(
                          //   child: Text(
                          //     "speedAlert $speedAlert",
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         fontFamily: 'Kanit',
                          //         color: Colors.deepOrange),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Text(
                          //     "sumValue $sumValue",
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         fontFamily: 'Kanit',
                          //         color: Colors.deepOrange),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('lib/img/icon1.2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY01#'));
                    } else {
                      // Navigator.push(
                      //     context,
                      //     PageTransition(
                      //       type: PageTransitionType.fade,
                      //       child: page2(
                      //           characteristic: widget.characteristic,
                      //           device: widget.device),
                      //     ));
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            child: page2(
                                characteristic: widget.characteristic,
                                device: widget.device),
                            type: PageTransitionType.fade,
                          ),
                          (route) => false);
                    }
                  },
                  icon: Image.asset('lib/img/icon2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon3.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon4.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                          (route) => false);
                    }
                  },
                  icon: Image.asset('lib/img/icon5.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon6.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon7.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                          (route) => false);
                    }
                  },
                  icon: Image.asset('lib/img/icon8.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon9.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // if (characteristic != null) {
                    //   // widget.characteristic!.write(utf8.encode('RY08#'));
                    // } else {
                    // }
                    print('PageTransition');
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: page10(
                              characteristic: widget.characteristic,
                              value1: '',
                              device: widget.device),
                        ),
                          (route) => false);
                  },
                  icon: Image.asset('lib/img/icon10.png'),
                  iconSize: 70,
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.45,
                //   child: Stack(
                //     children: [
                //       Image.asset(
                //         'assets/image/max-speed/frame.png',
                //         height: 65,
                //       ),
                //       Positioned(
                //         top: 15,
                //         right: 125,
                //         child: Obx(
                //           () => Text(
                //             '${speedController.speed}',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: 'ethnocentric',
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         top: 35,
                //         right: 125,
                //         child: Obx(
                //           () => Text(
                //             '${speedController.max_speed}',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: 'ethnocentric',
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         top: 17,
                //         left: 65,
                //         child: Text(
                //           'Km/hr',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 11,
                //             fontWeight: FontWeight.bold,
                //             fontFamily: 'Kanit',
                //           ),
                //         ),
                //       ),
                //       const Positioned(
                //         top: 38,
                //         left: 65,
                //         child: Text(
                //           'MAX SPEED',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 11,
                //             fontWeight: FontWeight.bold,
                //             fontFamily: 'Kanit',
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         height: 30,
                //         top: 15,
                //         right: 13,
                //         child: Obx(() => Image.asset(
                //               'assets/image/max-speed/alert${speedController.status_speed}.png',
                //             )),
                //       ),
                //     ],
                //   ),
                // ),
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
}




// Wrap(
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Image.asset('lib/img/icon1.2.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY01#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page2(
//                                 characteristic: widget.characteristic,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon2.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY02#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page3(
//                                 value: '0',
//                                 characteristic: widget.characteristic,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon3.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RB#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page4(
//                                 characteristic: widget.characteristic,
//                                 value1: 0,
//                                 value3: 0,
//                                 value2: 0,
//                                 value4: 0,
//                                 value5: 0,
//                                 value6: 0,
//                                 value7: 0,
//                                 value8: 0,
//                                 value9: 0,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon4.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY04#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page5(
//                                 characteristic: widget.characteristic,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon5.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY05#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page6(
//                                 characteristic: widget.characteristic,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon6.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY06#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page7(
//                                 characteristic: widget.characteristic,
//                                 value: 0,
//                                 value1: 0,
//                                 value2: 0,
//                                 value3: 0,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon7.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY07#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page8(
//                                 characteristic: widget.characteristic,
//                                 value1: 0,
//                                 value2: 0,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon8.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (characteristic != null) {
//                       widget.characteristic!.write(utf8.encode('RY08#'));
//                     } else {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                             type: PageTransitionType.fade,
//                             child: page9(
//                                 characteristic: widget.characteristic,
//                                 value1: 0,
//                                 device: widget.device),
//                           ));
//                     }
//                   },
//                   icon: Image.asset('lib/img/icon9.png'),
//                   iconSize: 70,
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // if (characteristic != null) {
//                     //   // widget.characteristic!.write(utf8.encode('RY08#'));
//                     // } else {
//                     // }
//                     print('PageTransition');
//                     Navigator.push(
//                         context,
//                         PageTransition(
//                           type: PageTransitionType.fade,
//                           child: page10(
//                               characteristic: widget.characteristic,
//                               value1: '',
//                               device: widget.device),
//                         ));
//                   },
//                   icon: Image.asset('lib/img/icon10.png'),
//                   iconSize: 70,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.45,
//                   child: Stack(children: [
//                     Image.asset(
//                       'assets/image/max-speed/frame.png',
//                       height: 65,
//                     ),
//                     Positioned(
//                       top: 15,
//                       right: 125,
//                       child: Obx(
//                         () => Text(
//                           '${speedController.speed}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'ethnocentric',
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 35,
//                       right: 125,
//                       child: Obx(
//                         () => Text(
//                           '${speedController.max_speed}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'ethnocentric',
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 17,
//                       left: 65,
//                       child: Text(
//                         'Km/hr',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Kanit',
//                         ),
//                       ),
//                     ),
//                     const Positioned(
//                       top: 38,
//                       left: 65,
//                       child: Text(
//                         'MAX SPEED',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Kanit',
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       height: 30,
//                       top: 15,
//                       right: 13,
//                       child: Obx(() => Image.asset(
//                             'assets/image/max-speed/alert${speedController.status_speed}.png',
//                           )),
//                     ),
//                   ]),
//                 ),
//               ],
//             ),






///// backup maxspeed/////
///
// Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {},
//                           icon: Image.asset('lib/img/icon1.2.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY01#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page2(
//                                         characteristic: widget.characteristic,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon2.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY02#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page3(
//                                         value: '0',
//                                         characteristic: widget.characteristic,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon3.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RB#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page4(
//                                         characteristic: widget.characteristic,
//                                         value1: 0,
//                                         value3: 0,
//                                         value2: 0,
//                                         value4: 0,
//                                         value5: 0,
//                                         value6: 0,
//                                         value7: 0,
//                                         value8: 0,
//                                         value9: 0,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon4.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY04#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page5(
//                                         characteristic: widget.characteristic,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon5.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY05#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page6(
//                                         characteristic: widget.characteristic,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon6.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY06#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page7(
//                                         characteristic: widget.characteristic,
//                                         value: 0,
//                                         value1: 0,
//                                         value2: 0,
//                                         value3: 0,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon7.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY07#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page8(
//                                         characteristic: widget.characteristic,
//                                         value1: 0,
//                                         value2: 0,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon8.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             if (characteristic != null) {
//                               widget.characteristic!.write(utf8.encode('RY08#'));
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     type: PageTransitionType.fade,
//                                     child: page9(
//                                         characteristic: widget.characteristic,
//                                         value1: 0,
//                                         device: widget.device),
//                                   ));
//                             }
//                           },
//                           icon: Image.asset('lib/img/icon9.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         fit: FlexFit.tight,
//                         child: IconButton(
//                           onPressed: () {
//                             // if (characteristic != null) {
//                             //   // widget.characteristic!.write(utf8.encode('RY08#'));
//                             // } else {
//                             // }
//                             print('PageTransition');
//                             Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   type: PageTransitionType.fade,
//                                   child: page10(
//                                       characteristic: widget.characteristic,
//                                       value1: '',
//                                       device: widget.device),
//                                 ));
//                           },
//                           icon: Image.asset('lib/img/icon10.png'),
//                           iconSize: 70,
//                         ),
//                       ),
//                       // Flexible(
//                       //   flex: 2,
//                       //   fit: FlexFit.tight,
//                       //   child: Container(
//                       //     width: _width * 0.45,
//                       //     height: _height / 9,
//                       //     child: Stack(children: [
//                       //       Image.asset(
//                       //         'assets/image/max-speed/frame.png',
//                       //         height: 65,
//                       //       ),
//                       //       Positioned(
//                       //         top: _width * 0.035,
//                       //         right: _width * 0.33,
//                       //         child: Obx(
//                       //           () => Text(
//                       //             '${speedController.speed}',
//                       //             style: TextStyle(
//                       //               color: Colors.white,
//                       //               fontSize: 15,
//                       //               fontWeight: FontWeight.bold,
//                       //               fontFamily: 'ethnocentric',
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       ),
//                       //       Positioned(
//                       //         top: _width * 0.08,
//                       //         right: _width * 0.33,
//                       //         child: Obx(
//                       //           () => Text(
//                       //             '${speedController.max_speed}',
//                       //             style: TextStyle(
//                       //               color: Colors.white,
//                       //               fontSize: 15,
//                       //               fontWeight: FontWeight.bold,
//                       //               fontFamily: 'ethnocentric',
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       ),
//                       //       Positioned(
//                       //         top: _width * 0.045,
//                       //         left: _width * 0.15,
//                       //         child: Text(
//                       //           'Km/hr',
//                       //           style: TextStyle(
//                       //             color: Colors.white,
//                       //             fontSize: 11,
//                       //             fontWeight: FontWeight.bold,
//                       //             fontFamily: 'Kanit',
//                       //           ),
//                       //         ),
//                       //       ),
//                       //       Positioned(
//                       //         top: _width * 0.09,
//                       //         left: _width * 0.15,
//                       //         child: const Text(
//                       //           'MAX SPEED',
//                       //           style: TextStyle(
//                       //             color: Colors.white,
//                       //             fontSize: 11,
//                       //             fontWeight: FontWeight.bold,
//                       //             fontFamily: 'Kanit',
//                       //           ),
//                       //         ),
//                       //       ),
//                       //       Positioned(
//                       //         height: 30,
//                       //         top: _width * 0.04,
//                       //         left: _width * 0.33,
//                       //         child: Obx(() => Image.asset(
//                       //               'assets/image/max-speed/alert${speedController.status_speed}.png',
//                       //             )),
//                       //       ),
//                       //     ]),
//                       //   ),
//                       // ),
//                       Flexible(
//                         flex: 2,
//                         fit: FlexFit.tight,
//                         child: Container(
//                           // width: _width * 0.45,
//                           // height: _height / 9,
//                           child: Stack(children: [
//                             Image.asset(
//                               'assets/image/max-speed/frame.png',
//                               height: 70,
//                             ),
//                             Positioned(
//                               top: _width * 0.035,
//                               right: _width * 0.37,
//                               child: Obx(
//                                 () => Text(
//                                   '${speedController.speed}',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'ethnocentric',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: _width * 0.08,
//                               right: _width * 0.37,
//                               child: Obx(
//                                 () => Text(
//                                   '${speedController.max_speed}',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'ethnocentric',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: _width * 0.045,
//                               left: _width * 0.15,
//                               child: Text(
//                                 'Km/hr',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'Kanit',
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: _width * 0.09,
//                               left: _width * 0.15,
//                               child: const Text(
//                                 'MAX SPEED',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'Kanit',
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               height: 30,
//                               top: _width * 0.04,
//                               left: _width * 0.33,
//                               child: Obx(() => Image.asset(
//                                     'assets/image/max-speed/alert${speedController.status_speed}.png',
//                                   )),
//                             ),
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),