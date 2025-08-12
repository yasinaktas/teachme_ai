import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class HtmlWithLatex extends StatelessWidget {
  final String htmlWithLatex;

  const HtmlWithLatex({super.key, required this.htmlWithLatex});

  @override
  Widget build(BuildContext context) {
    // Metni parçala: block $$...$$ önce, sonra inline $...$
    final parts = _parseHtmlAndLatex(htmlWithLatex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        if (part.isLatex) {
          return Math.tex(
            part.content,
            mathStyle: part.isBlock ? MathStyle.display : MathStyle.text,
            textStyle: TextStyle(fontSize: part.isBlock ? 20 : 16),
          );
        } else {
          return Html(data: part.content);
        }
      }).toList(),
    );
  }

  List<_Part> _parseHtmlAndLatex(String text) {
    final List<_Part> parts = [];

    // Regex ile önce block $$...$$ ayır
    final blockRegex = RegExp(r"\$\$(.+?)\$\$", dotAll: true);
    int currentIndex = 0;

    for (final match in blockRegex.allMatches(text)) {
      // Önce block öncesi normal metin
      if (match.start > currentIndex) {
        final before = text.substring(currentIndex, match.start);
        parts.addAll(_splitInlineLatex(before));
      }

      // Block latex
      final blockLatex = match.group(1)!;
      parts.add(_Part(blockLatex, true, true));

      currentIndex = match.end;
    }

    // Son kalan kısım
    if (currentIndex < text.length) {
      final after = text.substring(currentIndex);
      parts.addAll(_splitInlineLatex(after));
    }

    return parts;
  }

  List<_Part> _splitInlineLatex(String text) {
    final List<_Part> parts = [];
    final inlineRegex = RegExp(r"\$(.+?)\$");

    int currentIndex = 0;
    for (final match in inlineRegex.allMatches(text)) {
      if (match.start > currentIndex) {
        final before = text.substring(currentIndex, match.start);
        parts.add(_Part(before, false, false));
      }

      final inlineLatex = match.group(1)!;
      parts.add(_Part(inlineLatex, true, false));

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      parts.add(_Part(text.substring(currentIndex), false, false));
    }

    return parts;
  }
}

class _Part {
  final String content;
  final bool isLatex;
  final bool isBlock;

  _Part(this.content, this.isLatex, this.isBlock);
}
