import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';

class RoundedTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hinttext;
  final String? labelText;
  final TextInputType? keyboardType;
  final Color? bgColor;
  final bool obscureText;
  final Widget? left;
  final Widget? suffixIcon;
  const RoundedTextfield(
      {super.key,
      this.bgColor,
      this.controller,
      this.hinttext,
      this.keyboardType,
      this.labelText,
      this.left,
      this.obscureText = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Acolors.textfield,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Acolors.textfield)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Acolors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: hinttext,
          hintStyle: TextStyle(color: Acolors.textfieldText),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
