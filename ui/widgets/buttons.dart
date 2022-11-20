import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF4e5ae8),
        ),
        padding: EdgeInsets.only(right: 10.0, bottom: 1.0, top: 20),
        child: Text(
          label,textAlign: TextAlign.center, style: TextStyle(
          color: Colors.white,
        ),
        ),
      ),
    );
  }
}
