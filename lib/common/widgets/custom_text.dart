import 'package:flutter/material.dart';

// Constants
import 'package:hello_group_qmart_mobile/common/utils/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double width;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.color = AppColors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      ),
    );
  }
}