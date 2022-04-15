import 'dart:convert' show json, utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projectr1/Configs/config.dart';
import 'package:projectr1/Navbar.dart';
import 'package:projectr1/page1.dart';
import 'package:projectr1/page10.dart';
import 'package:projectr1/page2.dart';
import 'package:projectr1/page3.dart';
import 'package:projectr1/page4.dart';
import 'package:projectr1/page5.dart';
import 'package:projectr1/page6.dart';
import 'package:projectr1/page8.dart';
import 'package:projectr1/page9.dart';
import 'package:projectr1/settingble.dart';

import 'valueProvider.dart';
import 'package:get/get.dart';
import 'package:projectr1/getx/speedController.dart';

class page7 extends StatefulWidget {
  final BluetoothDevice? device;
  final double value;
  final double value1;
  final double value2;
  final double value3;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page7({
    Key? key,
    this.valueTx,
    required this.characteristic,
    required this.value,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.device,
  }) : super(key: key);

  @override
  _page7State createState() => _page7State();
}

class _page7State extends State<page7> {
  bool isSwitched = false;
  final double minlevel = 1;
  final double maxlevel = 24;
  final double minsound = 0;
  final double maxsound = 50;
  final double mintime = 10;
  final double maxtime = 60;
  double? value;
  double value1 = 10;
  double value2 = 10;
  double value3 = 10;
  BluetoothCharacteristic? characteristic;
  bool status = false;
  int index = 0;
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

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  sendData(String value) async {
    if (widget.characteristic != null) {
      widget.characteristic!.write(utf8.encode(value));
    }
  }

  void readC() {
    if (widget.characteristic != null) {
      widget.characteristic!.value.listen((data) {
        final command = _dataParser(data).toString();
        print('data page7 ========= > ${data}');
        if (command.contains('HX01')) {
          // print('index --------------- #######---------> ${index}');
          var data = dataValue[index]![1];
          data = data.replaceAll(
              'HY', 'HY${value1.round().toString().padLeft(2, '0')}');
          print('#### DART ----- > ${data}');
          // await _characteristicTX!.write(
          //   utf8.encode(data),
          // );
          sendData(data);
        } else if (command.contains('HX02')) {
          var data = dataValue[index]![2];
          data = data.replaceAll(
              'HY', 'HY${value1.round().toString().padLeft(2, '0')}');
          print('#### DART ----- > ${data}');
          // await _characteristicTX!.write(
          //   utf8.encode(data),
          // );
          sendData(data);
        } else if (command.contains('HX03')) {
          var data = dataValue[index]![3];
          data = data.replaceAll(
              'HY', 'HY${value1.round().toString().padLeft(2, '0')}');
          print('#### DART ----- > ${data}');
          // await _characteristicTX!.write(
          //   utf8.encode(data),
          // );
          sendData(data);
        } else if (command.contains('HX04')) {
          var data = dataValue[index]![4];
          data = data.replaceAll(
              'HY', 'HY${value1.round().toString().padLeft(2, '0')}');
          print('#### DART ----- > ${data}');
          // await _characteristicTX!.write(
          //   utf8.encode(data),
          // );
          sendData(data);
        } else if (command.contains('HX05')) {
          var data = dataValue[index]![5];
          data = data.replaceAll(
              'HY', 'HY${value1.round().toString().padLeft(2, '0')}');
          print('#### DART ----- > ${data}');
          // await _characteristicTX!.write(
          //   utf8.encode(data),
          // );
          sendData(data);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    readC();
    statusconnecttion();
    setState(() {
      status = widget.value == 0 ? false : true;
      if (widget.characteristic != null) {
        value = widget.value;
        value1 = widget.value1;
        value2 = widget.value2;
        value3 = widget.value3;
        characteristic = widget.characteristic;
      }
    });
  }

  final dataValue = {
    1: [
      'HY0103000200#',
      'HY0203000200#',
      'HY0303000200#',
      'HY0403000200#',
      'HY0503000200#',
      'HY0603000200#'
    ],
    2: [
      'HY0102000260#',
      'HY0202000260#',
      'HY0302000260#',
      'HY0402000260#',
      'HY0502000260#',
      'HY0602000260#',
    ],
    3: [
      'HY0102000320#',
      'HY0202000320#',
      'HY0302000320#',
      'HY0402000320#',
      'HY0502000320#',
      'HY0602000320#'
    ],
    4: [
      'HY0102000380#',
      'HY0202000380#',
      'HY0302000380#',
      'HY0402000380#',
      'HY0502000380#',
      'HY0602000380#',
    ],
    5: [
      'HY0102000440#',
      'HY0202000440#',
      'HY0302000440#',
      'HY0402000440#',
      'HY0502000440#',
      'HY0602000440#',
    ],
    6: [
      'HY0102000500#',
      'HY0202000500#',
      'HY0302000500#',
      'HY0402000500#',
      'HY0502000500#',
      'HY0602000500#',
    ],
    7: [
      'HY0102000560#',
      'HY0202000560#',
      'HY0302000560#',
      'HY0402000560#',
      'HY0502000560#',
      'HY0602000560#',
    ],
    8: [
      'HY0102000620#',
      'HY0202000620#',
      'HY0302000620#',
      'HY0402000620#',
      'HY0502000620#',
      'HY0602000620#',
    ],
    9: [
      'HY0102000680#',
      'HY0202000680#',
      'HY0302000680#',
      'HY0402000680#',
      'HY0502000680#',
      'HY0602000680#',
    ],
    10: [
      'HY0102000740#',
      'HY0202000740#',
      'HY0302000740#',
      'HY0402000740#',
      'HY0502000740#',
      'HY0602000740#',
    ],
    11: [
      'HY0102000800#',
      'HY0202000800#',
      'HY0302000800#',
      'HY0402000800#',
      'HY0502000800#',
      'HY0602000800#',
    ],
    12: [
      'HY0102000860#',
      'HY0202000860#',
      'HY0302000860#',
      'HY0402000860#',
      'HY0502000860#',
      'HY0602000860#',
    ],
    13: [
      'HY0102000860#',
      'HY0202000860#',
      'HY0302000860#',
      'HY0402000860#',
      'HY0502000860#',
      'HY0602000860#',
    ],
    14: [
      'HY0102000980#',
      'HY0202000980#',
      'HY0302000980#',
      'HY0402000980#',
      'HY0502000980#',
      'HY0602000980#',
    ],
    15: [
      'HY0101001000#',
      'HY0201001000#',
      'HY0301001000#',
      'HY0401001000#',
      'HY0501001000#',
      'HY0601001000#',
    ],
    16: [
      'HY0101000300#',
      'HY0201000300#',
      'HY0301000300#',
      'HY0401000300#',
      'HY0501000300#',
      'HY0601000300#',
    ],
    17: [
      'HY0101000200#',
      'HY0201000200#',
      'HY0301000200#',
      'HY0401000200#',
      'HY0501000200#',
      'HY0601000200#',
    ],
    18: [
      'HY0101000100#',
      'HY0201000200#',
      'HY0301000100#',
      'HY0401000200#',
      'HY0501000100#',
      'HY0601000200#',
    ],
    19: [
      'HY0100500100#',
      'HY0201000150#',
      'HY0300500100#',
      'HY0401000150#',
      'HY0500500100#',
      'HY0601000150#',
    ],
    20: [
      'HY0100500100#',
      'HY0201000150#',
      'HY0300500100#',
      'HY0401000150#',
      'HY0500500100#',
      'HY0601000150#',
    ],
    21: [
      'HY0101002500#',
      'HY0201000500#',
      'HY0301000500#',
      'HY0401000500#',
      'HY0501002500#',
      'HY0601000550#',
    ],
    22: [
      'HY0101000500#',
      'HY0201002500#',
      'HY0301000500#',
      'HY0401000500#',
      'HY0501000500#',
      'HY0601002500#',
    ],
    23: [
      'HY0101000250#',
      'HY0201001500#',
      'HY0301000250#',
      'HY0401000250#',
      'HY0501000250#',
      'HY0601002500#',
    ],
    24: [
      'HY0101000200#',
      'HY0201000200#',
      'HY0301002500#',
      'HY0401002500#',
      'HY0501000200#',
      'HY0601000200#',
    ],
  };

  @override
  Widget build(BuildContext context) {
    // print(dataValue[2]![1]);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    var arry = 1;
    var statusval;
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
                        "โหมดเดินหอบ",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Kanit',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      // Text(
                      //   '  ${index}',
                      //   style: TextStyle(
                      //       color: Colors.white, fontWeight: FontWeight.bold),
                      // )
                    ],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 30, bottom: 0),
                  child: FlutterSwitch(
                    activeColor: Colors.red[900]!,
                    toggleColor: Colors.white,
                    valueFontSize: 10.0,
                    height: 25,
                    width: 60,
                    value: status,
                    borderRadius: 30.0,
                    padding: 5.0,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                        print(status);
                        statusval = val == true ? '01' : '00';
                        print(statusval);
                        if (characteristic != null) {
                          // status.toString().padLeft(2, '0')
                          widget.characteristic!.write(
                            utf8.encode(
                                'RY06${'${statusval}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                          );
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 15),
                child: Wrap(
                  children: [
                    Container(
                      height: 200,
                      child: Wrap(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 70,
                              thumbShape: SliderComponentShape.noOverlay,
                              overlayShape: SliderComponentShape.noOverlay,
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.grey[800],
                            ),
                            child: Container(
                              height: 270,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value1.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'Ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
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
                                                    min: minlevel,
                                                    max: maxlevel,
                                                    divisions: 24,
                                                    label: value1
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value1) =>
                                                        setState(() => this
                                                            .value1 = value1),
                                                    onChangeEnd:
                                                        (value1) async {
                                                      setState(() {
                                                        index = value1.round();
                                                        // widget.characteristic!
                                                        //     .write(
                                                        //         utf8.encode(
                                                        //             'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                        //         withoutResponse:
                                                        //             true);
                                                      });
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#');
                                                      if (widget
                                                              .characteristic !=
                                                          null) {
                                                        print(value1.toInt());

                                                        var data = dataValue[
                                                            value1.toInt()]![0];
                                                        data = data.replaceAll(
                                                            'HY',
                                                            'HY${value1.round().toString().padLeft(2, '0')}');
                                                        print(
                                                            '#### DATA ----- > ${data}');
                                                        widget.characteristic!
                                                            .write(
                                                          utf8.encode(data),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/signal.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ระดับ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value2.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'Ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value2,
                                                    activeColor: Colors.white,
                                                    min: minsound,
                                                    max: maxsound,
                                                    divisions: 50,
                                                    label: value2
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value2) =>
                                                        setState(() => this
                                                            .value2 = value2),
                                                    onChangeEnd: (value2) => {
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                      if (characteristic !=
                                                          null)
                                                        {
                                                          widget.characteristic!
                                                              .write(
                                                            utf8.encode(
                                                                'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                          ),
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/sound.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ความดัง',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value3.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'Ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
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
                                                    min: mintime,
                                                    max: maxtime,
                                                    divisions: 60,
                                                    label: value3
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value3) =>
                                                        setState(() => this
                                                            .value3 = value3),
                                                    onChangeEnd: (value3) => {
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                      if (characteristic !=
                                                          null)
                                                        {
                                                          widget.characteristic!
                                                              .write(
                                                            utf8.encode(
                                                                'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                          ),
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/clock.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ตั้งเวลา',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
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
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "โหมดเดินหอบ",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  "สามารถเลือกปรับได้ตามความต้องการ",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
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
                    // widget.characteristic!.write(utf8.encode('RY06#'));
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page7(
                    //               characteristic: widget.characteristic,
                    //               value: 0,
                    //               value1: 0,
                    //               value2: 0,
                    //               value3: 0,
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon7.1.png'),
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
                    // } else {

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
