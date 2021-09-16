import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormFieldInputIcon extends StatelessWidget {
  FormFieldInputIcon({
    Key? key,
    this.svgIcon,
    this.backGroundColor,
  }) : super(key: key);

  final String? svgIcon;
  final Color? backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 5.0,
        top: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(9.0),
          child: SvgPicture.asset(
            svgIcon!,
          ),
        ),
      ),
    );
  }
}
