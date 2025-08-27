import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String searchQuery;
  final TextStyle? defaultStyle;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    Key? key,
    required this.text,
    required this.searchQuery,
    this.defaultStyle,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return Text(
        text,
        style: defaultStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = searchQuery.toLowerCase();

    int start = 0;

    while (start < text.length) {
      final int index = lowerText.indexOf(lowerQuery, start);

      if (index == -1) {
        // No more matches, add the rest of the text
        spans.add(TextSpan(
          text: text.substring(start),
          style: defaultStyle,
        ));
        break;
      }

      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: defaultStyle,
        ));
      }

      // Add the highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + searchQuery.length),
        style: highlightStyle ??
            TextStyle(
              backgroundColor: Colors.lightGreen.withOpacity(0.6),
              color: Colors.black,
            ),
      ));

      start = index + searchQuery.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(children: spans),
    );
  }
}
