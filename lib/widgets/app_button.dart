import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function onClick;
  final Color backgroundColor;
  final String lable;
  const AppButton({super.key, required this.lable,required this.backgroundColor,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(20),
        child: Text(
          lable,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
