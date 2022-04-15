import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projectr1/Configs/config.dart';
import 'package:provider/provider.dart';

import 'package:projectr1/Navbar.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/page10.dart';
import 'package:projectr1/page2.dart';
import 'package:projectr1/page4.dart';
import 'package:projectr1/page5.dart';
import 'package:projectr1/page6.dart';
import 'package:projectr1/page7.dart';
import 'package:projectr1/page8.dart';
import 'package:projectr1/page9.dart';
import 'package:projectr1/settingble.dart';
import 'dart:convert' show utf8;

import 'package:projectr1/valueProvider.dart';
import 'package:get/get.dart';
import 'package:projectr1/getx/speedController.dart';

class page3 extends StatefulWidget {
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  final String value;
  const page3(
      {Key? key,
      this.valueTx,
      required this.characteristic,
      required this.value,
      required this.device})
      : super(key: key);

  @override
  _page3State createState() => _page3State();
}

class _page3State extends State<page3> {
  BluetoothCharacteristic? characteristic;
  bool statusconnect = false;
  int number = 0;
  SpeedController speedController = Get.put(SpeedController());

  Timer? _timerup;
  Timer? _timerdown;
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
    // var _value1 = Provider.of<valueProvider>(context, listen: false);
    setState(() {
      if (widget.value != null) {
        number = int.parse(widget.value.toString());
      }
      //number = valueprovider.valuestep!;
      // if (_value1.valuestep != null) {
      //   number = _value1.valuestep;
      // }
      if (widget.characteristic != null) {
        characteristic = widget.characteristic;
      }
    });
    readC();
    statusconnecttion();
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  void readC() {
    if (widget.characteristic != null) {
      widget.characteristic!.value.listen((data) {
        final command = _dataParser(data).toString();
        print('data page3 ========= > ${data}');
        if (command.contains('RX02')) {
          final value1 = '${command[4]}${command[5]}';
          print('Data  page3-----------> ${value1}');
          setState(() {
            number = int.parse(value1);
          });
        }
      });
    }
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
                        "โหมดปรับแต่งคันเร่ง",
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
                height: 270,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("lib/item/max.png")),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              number.toString(),
                              style: TextStyle(
                                  fontFamily: 'ethnocentric',
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.red,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                    Shadow(
                                      color: Colors.red,
                                      blurRadius: 10.0,
                                      offset: Offset(-3.0, 3.0),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "STEP",
                              style: TextStyle(
                                  fontFamily: 'Ethnocentric',
                                  fontSize: 15,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.red,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                    Shadow(
                                      color: Colors.red,
                                      blurRadius: 10.0,
                                      offset: Offset(-3.0, 3.0),
                                    ),
                                  ]),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          // onTap: () {
                          //   setState(() {
                          //     if (number > 0) {
                          //       number--;
                          //     }
                          //   });
                          //   if (characteristic != null) {
                          //     try {
                          //       widget.characteristic!.write(utf8.encode(
                          //         'RY02${number.toString().padLeft(2, '0')}#',
                          //       ));
                          //     } catch (e) {
                          //       print('Error : ' + e.toString());
                          //     }
                          //   }

                          //   print(number.toString().padLeft(2, '0'));
                          //   print(number);
                          // },
                          onTap: () {
                            setState(() {
                              if (number > 0) {
                                number--;
                              }
                            });
                            if (characteristic != null) {
                              try {
                                widget.characteristic!.write(utf8.encode(
                                  'RY02${number.toString().padLeft(2, '0')}#',
                                ));
                              } catch (e) {
                                print('Error : ' + e.toString());
                              }
                            }

                            print(number.toString().padLeft(2, '0'));
                          },
                          onLongPressDown: (e) {
                            print('onLongPressDown');
                            _timerdown = Timer.periodic(
                                const Duration(milliseconds: 100), (timer) {
                              setState(() {
                                if (number > 0) {
                                  number--;
                                }
                              });
                              print(number);
                            });
                          },
                          onLongPressUp: () {
                            print('onLongPressUp');
                            if (characteristic != null) {
                              try {
                                widget.characteristic!.write(utf8.encode(
                                  'RY02${number.toString().padLeft(2, '0')}#',
                                ));
                              } catch (e) {
                                print('Error : ' + e.toString());
                              }
                            }

                            print(number.toString().padLeft(2, '0'));
                            _timerdown?.cancel();
                          },
                          onLongPressCancel: () {
                            print('onLongPressCancel');
                            _timerdown!.cancel();
                          },
                          child: Container(
                            child: Image.asset(
                              'lib/item/minus.png',
                              height: 60,
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       if (number > 0) {
                        //         number--;
                        //       }
                        //     });
                        //     print(number);
                        //     if (characteristic != null) {
                        //       try {
                        //         widget.characteristic!.write(utf8.encode(
                        //           'RY02${number.toString().padLeft(2, '0')}#',
                        //         ));
                        //       } catch (e) {
                        //         print('Error : ' + e.toString());
                        //       }
                        //     }
                        //   },
                        //   icon: Image.asset('lib/item/minus.png'),
                        //   iconSize: 60,
                        // ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('lib/item/slide.png'),
                          iconSize: 80,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (number < 99) {
                                number++;
                              }
                            });
                            print(number);
                            if (characteristic != null) {
                              widget.characteristic!.write(utf8.encode(
                                'RY02${number.toString().padLeft(2, '0')}#',
                              ));
                            }
                            print(number.toString().padLeft(2, '0'));
                          },
                          onLongPressCancel: () {
                            print('onLongPressCancel');
                            _timerup?.cancel();
                          },
                          onLongPressDown: (e) {
                            print('onLongPressDown');
                            _timerup = Timer.periodic(
                                const Duration(milliseconds: 100), (timer) {
                              setState(() {
                                if (number < 99) {
                                  number++;
                                }
                              });
                              print(number);
                            });
                          },
                          onLongPressUp: () {
                            print('onLongPressUp');
                            if (characteristic != null) {
                              widget.characteristic!.write(utf8.encode(
                                'RY02${number.toString().padLeft(2, '0')}#',
                              ));
                            }
                            print(number.toString().padLeft(2, '0'));
                            _timerup?.cancel();
                          },
                          // onTapDown: ((details) {

                          // }),
                          child: Container(
                            child: Image.asset(
                              'lib/item/plus.png',
                              height: 60,
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () async {
                        //     setState(() {
                        //       if (number < 99) {
                        //         number++;
                        //       }
                        //     });
                        //     print(number);
                        //     if (characteristic != null) {
                        //       widget.characteristic!.write(utf8.encode(
                        //         'RY02${number.toString().padLeft(2, '0')}#',
                        //       ));
                        //     }
                        //   },
                        //   icon: Image.asset('lib/item/plus.png'),
                        //   iconSize: 60,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Column(
                      children: [
                        // Text(
                        //   'data ${context.watch<valueProvider>().valuestep}',
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontFamily: 'Kanit',
                        //       fontSize: 15),
                        // ),
                        Text(
                          "โหมดปรับแต่งคันเร่ง",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 15),
                        ),
                        Text(
                          "เป็นโหมดปรับระดับความไวของคันเร่งมีทั้งหมด 100 STEP",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 12),
                        ),
                        Text(
                          "สามารถเลือกระดับความต้องการและทำการทดสอบ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 12),
                        ),
                      ],
                    )),
                  ],
                ),
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
                  icon: Image.asset('lib/img/icon2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // widget.characteristic!.write(utf8.encode('RY02#'));
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page3(
                    //               value: '0',
                    //               characteristic: widget.characteristic,
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon3.1.png'),
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
