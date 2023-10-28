import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomAdd extends StatelessWidget {
  IconData? icon;
  Function()? onpressed;

  CustomAdd({Key? key, this.icon, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0.1,
              blurRadius: 0.1,
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black,
          ),
          radius: 12,
        ),
      ),
    );
  }
}
