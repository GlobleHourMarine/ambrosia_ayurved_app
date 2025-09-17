import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'dart:async';

class HomeTextfield extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String searchQuery;

  const HomeTextfield(
      {super.key, required this.onSearchChanged, required this.searchQuery});

  @override
  State<HomeTextfield> createState() => _HomeTextfieldState();
}

class _HomeTextfieldState extends State<HomeTextfield> {
  String searchText = '';
  String fullHintText = 'Find something here';
  String visibleHintText = '';
  int hintIndex = 0;
  Timer? typingTimer;
  Timer? searchTimer; // Debounce timer for search
  Duration typingSpeed = const Duration(milliseconds: 100);
  bool isTyping = true;
  bool isSearchActive = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode(); // Add FocusNode for better control

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchQuery;
    _startTypingEffect();

    // Add focus listener to handle focus changes
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _controller.text.isEmpty) {
        setState(() {
          isSearchActive = false;
        });
      }
    });
  }

  void _startTypingEffect() {
    // Only show typing effect when search is not active
    typingTimer = Timer.periodic(typingSpeed, (timer) {
      if (!isSearchActive && _controller.text.isEmpty && !_focusNode.hasFocus) {
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
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      isSearchActive = value.isNotEmpty || _focusNode.hasFocus;
      if (isSearchActive) {
        visibleHintText = fullHintText; // Show full hint when typing
      }
    });

    // Debounce search to avoid too many API calls
    searchTimer?.cancel();
    searchTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      isSearchActive = false;
      visibleHintText = '';
      hintIndex = 0;
    });
    widget.onSearchChanged('');
    // Explicitly unfocus the text field
    _focusNode.unfocus();
    _startTypingEffect();
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    searchTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        height: 45,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode, // Use FocusNode
          textInputAction: TextInputAction.search,
          onChanged: _onSearchChanged,
          onTap: () {
            // Handle tap to show search state
            setState(() {
              isSearchActive = true;
            });
          },
          onEditingComplete: () {
            _focusNode.unfocus(); // Use FocusNode to unfocus
          },
          enableInteractiveSelection: true,
          autofocus: false, // Prevent automatic focus
          decoration: InputDecoration(
            fillColor: Acolors.textfield,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Acolors.textfield),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Acolors.primary)),
            filled: true,
            hintText: (isSearchActive || _focusNode.hasFocus)
                ? 'Search products...'
                : visibleHintText,
            prefixIcon: const Icon(
              Icons.search,
              color: Acolors.primary,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            suffixIcon: (isSearchActive && _controller.text.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Acolors.primary),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
