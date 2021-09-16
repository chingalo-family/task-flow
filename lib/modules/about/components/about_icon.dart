import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutIcon extends StatelessWidget {
  const AboutIcon({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      height: size.height * 0.2,
      child: SvgPicture.asset(
        'assets/logos/todo-logo.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
