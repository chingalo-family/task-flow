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
      margin: const EdgeInsets.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            value,
            style: const TextStyle().copyWith(
              fontSize: 12.0,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
