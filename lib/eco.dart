import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projectr1/Configs/config.dart';

import 'package:projectr1/Navbar.dart';
import 'package:projectr1/comfort.dart';
import 'package:projectr1/page1.dart';
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
import 'package:projectr1/sport2.dart';
import 'package:get/get.dart';
import 'package:projectr1/getx/speedController.dart';

class eco extends StatefulWidget {
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const eco(
      {Key? key,
      this.valueTx,
      required this.characteristic,
      required this.device})
      : super(key: key);

  @override
  _ecoState createState() => _ecoState();
}

class _ecoState extends State<eco> {
  BluetoothCharacteristic? characteristic;
  bool statusconnect = false;
  SpeedController speedController = Get.put(SpeedController());
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
    print('โหมด  AI ECO');
    print('send to esp RY0100#');
    setState(() {
      setState(() {
        characteristic = widget.characteristic;
      });
    });
    statusconnecttion();
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
          // widget.device!.disconnect();
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
          mainAxisAlignment: MainAxisAlignment.end,
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
                        "โหมดคันเร่งอัจฉริยะ",
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 270,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage("lib/item/ai.png")),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0102#'));
                                        }
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: page2(
                                                  characteristic:
                                                      characteristic,
                                                  device: widget.device),
                                            ),
                                            (route) => false);
                                      },
                                      icon: Image.asset('lib/item/SPORT1.png'),
                                      iconSize: 60,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0101#'));
                                        }
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: comfort(
                                                  characteristic:
                                                      characteristic,
                                                  device: widget.device),
                                            ),
                                            (route) => false);
                                      },
                                      icon:
                                          Image.asset('lib/item/COMFORT1.png'),
                                      iconSize: 60,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0103#'));
                                        }
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: sport2(
                                                  characteristic:
                                                      characteristic,
                                                  device: widget.device),
                                            ),
                                            (route) => false);
                                      },
                                      icon: Image.asset('lib/item/SPORT+1.png'),
                                      iconSize: 60,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'lib/item/ECO2.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'โหมด Ai ECO',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                  Text(
                    'โหมดนี้จะปรับแต่งคันเร่งให้เน้นไปที่การประหยัดเชื้อเพลิง',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                  Text(
                    'แต่ยังคงแซงได้ปกติ',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                ],
              ),
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
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
                  },
                  icon: Image.asset('lib/img/icon2.1.png'),
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
                    //   widget.characteristic!.write(utf8.encode('RY00#'));
                    // }else{

                    // }
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
