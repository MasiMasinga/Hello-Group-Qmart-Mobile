import 'package:flutter/material.dart';

// Constants
import 'package:hello_group_qmart_mobile/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 55.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                    color: AppColors.primaryColor), // Add this line
              ),
            ),
          ),
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}