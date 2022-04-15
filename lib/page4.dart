import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projectr1/Navbar.dart';
import 'package:projectr1/getx/speedController.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/page2.dart';
import 'package:projectr1/settingble.dart';
import 'package:projectr1/page10.dart';
import 'package:projectr1/page3.dart';
import 'package:projectr1/page5.dart';
import 'package:projectr1/page6.dart';
import 'package:projectr1/page7.dart';
import 'package:projectr1/page8.dart';
import 'package:projectr1/page9.dart';

class page4 extends StatefulWidget {
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  final double value1;
  final double value2;
  final double value3;
  final double value4;
  final double value5;
  final double value6;
  final double value7;
  final double value8;
  final double value9;
  const page4(
      {Key? key,
      this.valueTx,
      required this.characteristic,
      required this.value1,
      required this.value2,
      required this.value3,
      required this.value4,
      required this.value5,
      required this.value6,
      required this.value7,
      required this.value8,
      required this.value9,
      required this.device})
      : super(key: key);

  @override
  _page4State createState() => _page4State();
}

class _page4State extends State<page4> {
  BluetoothCharacteristic? characteristic;
  bool statusconnect = false;
  final double min = 0;
  final double max = 99;
  double value1 = 10;
  double value2 = 20;
  double value3 = 30;
  double value4 = 40;
  double value5 = 50;
  double value6 = 60;
  double value7 = 70;
  double value8 = 80;
  double value9 = 90;
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
    setState(() {
      value1 = widget.value1;
      value2 = widget.value2;
      value3 = widget.value3;
      value4 = widget.value4;
      value5 = widget.value5;
      value6 = widget.value6;
      value7 = widget.value7;
      value8 = widget.value8;
      value9 = widget.value9;
      characteristic = widget.characteristic;
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
          'lib/img/logo.png',
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
                        "โหมดการจูนกราฟ",
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
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ตำแหน่งคันเร่งช่วงต้น',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13, fontFamily: 'Kanit'),
                  ),
                  Text(
                    'ตำแหน่งคันเร่งช่วงปลาย',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13, fontFamily: 'Kanit'),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 5),
                child: Wrap(
                  children: [
                    Container(
                      height: 200,
                      child: Wrap(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 15,
                              thumbShape: SliderComponentShape.noOverlay,
                              overlayShape: SliderComponentShape.noOverlay,
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.grey[800],
                            ),
                            child: Container(
                              height: 270,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value1,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value1
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value1) {
                                                      if (value1 <= 50) {
                                                        setState(() => this
                                                            .value1 = value1);
                                                      }
                                                    },
                                                    onChangeEnd: (value1) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //แท่ง1
                                          Text(
                                            '10',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 7,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value2,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value2
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value2) =>
                                                        setState(() => this
                                                            .value2 = value2),
                                                    onChangeEnd: (value2) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '20',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value3,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value3
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value3) =>
                                                        setState(() => this
                                                            .value3 = value3),
                                                    onChangeEnd: (value3) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '30',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value4,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value4
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value4) =>
                                                        setState(() => this
                                                            .value4 = value4),
                                                    onChangeEnd: (value4) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '40',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value5,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value5
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value5) =>
                                                        setState(() => this
                                                            .value5 = value5),
                                                    onChangeEnd: (value5) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '50',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value6,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value6
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value6) =>
                                                        setState(() => this
                                                            .value6 = value6),
                                                    onChangeEnd: (value6) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '60',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value7,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value7
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value7) =>
                                                        setState(() => this
                                                            .value7 = value7),
                                                    onChangeEnd: (value7) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '70',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value8,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value8
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value8) =>
                                                        setState(() => this
                                                            .value8 = value8),
                                                    onChangeEnd: (value8) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '80',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value9,
                                                    activeColor: Colors.white,
                                                    min: min,
                                                    max: max,
                                                    divisions: 99,
                                                    label: value9
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value9) =>
                                                        setState(() => this
                                                            .value9 = value9),
                                                    onChangeEnd: (value9) {
                                                      if (characteristic !=
                                                          null) {
                                                        widget.characteristic!
                                                            .write(utf8.encode(
                                                                'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));

                                                        print(
                                                            'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '90',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
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
                    // Center(
                    //   child: Text(
                    //     'send to esp RY03${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}#',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              value1 = 10;
                              value2 = 20;
                              value3 = 30;
                              value4 = 40;
                              value5 = 50;
                              value6 = 60;
                              value7 = 70;
                              value8 = 80;
                              value9 = 90;
                            });
                            if (characteristic != null) {
                              widget.characteristic!.write(utf8.encode(
                                  'RB${value1.toStringAsFixed(0).padLeft(2, '0') + value2.toStringAsFixed(0).padLeft(2, '0') + value3.toStringAsFixed(0).padLeft(2, '0') + value4.toStringAsFixed(0).padLeft(2, '0') + value5.toStringAsFixed(0).padLeft(2, '0') + value6.toStringAsFixed(0).padLeft(2, '0') + value7.toStringAsFixed(0).padLeft(2, '0') + value8.toStringAsFixed(0).padLeft(2, '0') + value9.toStringAsFixed(0).padLeft(2, '0')}'));
                            }
                          },
                          icon: Image.asset('lib/item/reset.png'),
                          iconSize: 50,
                        ),
                        Center(
                          child: Text(
                            'โหมดจูนกราฟ DIY',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Kanit'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'กำลังทำงานสามารถปรับแต่งคันเร่งช่วงต้นและช่วงปลายได้ตามความต้องการ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Kanit'),
                          ),
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
