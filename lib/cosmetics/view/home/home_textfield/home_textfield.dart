import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'dart:async';

class HomeTextfield extends StatefulWidget {
  const HomeTextfield({super.key});

  @override
  State<HomeTextfield> createState() => _HomeTextfieldState();
}

class _HomeTextfieldState extends State<HomeTextfield> {
  String searchText = '';
  String fullHintText = 'Find something here';
  String visibleHintText = '';
  int hintIndex = 0;
  Timer? typingTimer;
  Duration typingSpeed = const Duration(milliseconds: 100);
  bool isTyping = true;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  void _startTypingEffect() {
    typingTimer = Timer.periodic(typingSpeed, (timer) {
      setState(() {
        if (isTyping) {
          if (hintIndex < fullHintText.length) {
            visibleHintText += fullHintText[hintIndex];
            hintIndex++;
          } else {
            isTyping = false;
          }
        } else {
          if (hintIndex > 0) {
            visibleHintText = visibleHintText.substring(0, hintIndex - 1);
            hintIndex--;
          } else {
            isTyping = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    typingTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        textInputAction: TextInputAction.done,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          fillColor: Acolors.textfield,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Acolors.textfield),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Acolors.primary)),
          filled: true,
          hintText: visibleHintText,
          prefixIcon: const Icon(
            Icons.search,
            color: Acolors.primary,
          ),
        ),
      ),
    );
  }
}
