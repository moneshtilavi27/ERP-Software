import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPress;
  final String btnText;
  final Color btnColor;
  Color? textColor;
  bool? loading;
  Alignment? textAlign;
  double? btnHeight, fontSize, btnWidth;
  FontWeight? fontWeight;
  Button(
      {Key? key,
      required this.onPress,
      required this.btnText,
      required this.btnColor,
      this.btnHeight,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.textColor,
      this.btnWidth,
      this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust this value to make it square
        ),
      ),
      onPressed: () => onPress(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: textAlign ?? Alignment.center,
          child: loading == true
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  btnText,
                  style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontWeight: fontWeight ?? FontWeight.bold,
                      fontSize: fontSize ?? 14.0),
                ),
        ),
      ),
    );
  }
}
