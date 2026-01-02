import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  
  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppConstant.primaryBlue,
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppConstant.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.layers_rounded,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
        if (showText) ...[
          SizedBox(height: AppConstant.spacing24),
          Text(
            'TaskFlow',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
