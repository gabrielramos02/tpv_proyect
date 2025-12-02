import 'package:flutter/material.dart';

class ProyectStyles {
  static ButtonStyle buttonStyles(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColorLight,
      alignment: AlignmentGeometry.center,
      side: BorderSide(color: Colors.black),
      padding: EdgeInsets.all(14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
    );
  }
}
