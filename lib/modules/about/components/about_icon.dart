import 'package:flutter/material.dart';

class AboutIcon extends StatelessWidget {
  const AboutIcon({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      height: size.height * 0.2,
      child: Image.asset(
        'assets/img/app-icon.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
