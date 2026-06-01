import 'package:flutter/material.dart';

class TypeInfo {
  final Color color;
  final int iconIdx;

  const TypeInfo({required this.color, required this.iconIdx});
}

const Map<String, TypeInfo> typesInfo = {
  'bug': TypeInfo(color: Color(0xFF90C12C), iconIdx: 6),
  'dark': TypeInfo(color: Color(0xFF5A5366), iconIdx: 16),
  'dragon': TypeInfo(color: Color(0xFF096DC4), iconIdx: 15),
  'electric': TypeInfo(color: Color(0xFFF3D23B), iconIdx: 12),
  'fairy': TypeInfo(color: Color(0xFFEC8FE6), iconIdx: 17),
  'fire': TypeInfo(color: Color(0xFFFF9C54), iconIdx: 9),
  'fighting': TypeInfo(color: Color(0xFFCE4069), iconIdx: 1),
  'flying': TypeInfo(color: Color(0xFF92AADE), iconIdx: 2),
  'grass': TypeInfo(color: Color(0xFF63BB5B), iconIdx: 11),
  'ground': TypeInfo(color: Color(0xFFD97746), iconIdx: 4),
  'ghost': TypeInfo(color: Color(0xFF5269AC), iconIdx: 7),
  'ice': TypeInfo(color: Color(0xFF74CEC0), iconIdx: 14),
  'normal': TypeInfo(color: Color(0xFF9099A1), iconIdx: 0),
  'poison': TypeInfo(color: Color(0xFFAB6AC8), iconIdx: 3),
  'psychic': TypeInfo(color: Color(0xFFF97176), iconIdx: 13),
  'rock': TypeInfo(color: Color(0xFFC7B78B), iconIdx: 5),
  'steel': TypeInfo(color: Color(0xFF5A8EA1), iconIdx: 8),
  'water': TypeInfo(color: Color(0xFF4D90D5), iconIdx: 10),
};
