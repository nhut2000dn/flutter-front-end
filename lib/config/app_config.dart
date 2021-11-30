import 'package:flutter/material.dart';

class Colors {
  final Color _mainColor = const Color(0xFF009DB5);
  final Color _mainDarkColor = const Color(0xFF22B7CE);
  final Color _secondColor = const Color(0xFF04526B);
  final Color _secondDarkColor = const Color(0xFFE7F6F8);
  final Color _accentColor = const Color(0xFFADC4C8);
  final Color _accentDarkColor = const Color(0xFFADC4C8);

  Color mainColor(double opacity) {
    return _mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return _secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return _accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return _mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return _secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return _accentDarkColor.withOpacity(opacity);
  }
}
