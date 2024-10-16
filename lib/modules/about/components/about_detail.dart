import 'package:flutter/material.dart';

class AboutDetail extends StatelessWidget {
  const AboutDetail({
    super.key,
    required this.value,
  });

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
            ),
          ),
        ],
      ),
    );
  }
}
