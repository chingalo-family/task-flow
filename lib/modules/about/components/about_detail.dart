import 'package:flutter/material.dart';

class AboutDetail extends StatelessWidget {
  const AboutDetail({
    Key? key,
    required this.textColor,
    required this.value,
  }) : super(key: key);

  final Color textColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            value,
            style: TextStyle().copyWith(
              fontSize: 12.0,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
