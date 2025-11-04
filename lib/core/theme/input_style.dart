import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
    String label,
    IconData icon, {
      Widget? suffixIcon,
    }) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Colors.white70),
    suffixIcon: suffixIcon,
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white24,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
  );
}
