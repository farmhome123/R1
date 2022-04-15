// To parse this JSON data, do
//
//     final presetMode1 = presetMode1FromJson(jsonString);

import 'dart:convert';

PresetMode1 presetMode1FromJson(String str) =>
    PresetMode1.fromJson(json.decode(str));

String presetMode1ToJson(PresetMode1 data) => json.encode(data.toJson());

class PresetMode1 {
  PresetMode1({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.value6,
    required this.value7,
    required this.value8,
    required this.value9,
  });

  String value1;
  int value2;
  int value3;
  int value4;
  int value5;
  int value6;
  int value7;
  int value8;
  int value9;

  factory PresetMode1.fromJson(Map<String, dynamic> json) => PresetMode1(
        value1: json["value1"],
        value2: json["value2"],
        value3: json["value3"],
        value4: json["value4"],
        value5: json["value5"],
        value6: json["value6"],
        value7: json["value7"],
        value8: json["value8"],
        value9: json["value9"],
      );

  Map<String, dynamic> toJson() => {
        "value1": value1,
        "value2": value2,
        "value3": value3,
        "value4": value4,
        "value5": value5,
        "value6": value6,
        "value7": value7,
        "value8": value8,
        "value9": value9,
      };
}
