import 'package:flutter/material.dart';

Size calculateTextSize(String text, TextStyle style, {int maxLines = 1}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  return textPainter.size;
}

double calculateAppBarHeight(
  BuildContext? context, {

  double toolbarHeight = 80.0,
  PreferredSizeWidget? bottom,
}) {
  final padding = context != null
      ? MediaQuery.paddingOf(context)
      : MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        ).padding;

  final double statusBarHeight = padding.top;
  final double bottomHeight = bottom?.preferredSize.height ?? 0.0;
  return statusBarHeight + toolbarHeight + bottomHeight;
}

double calculateBottomNavigationBarHeight(
  BuildContext? context, {
  double baseHeight = kBottomNavigationBarHeight,
}) {
  final padding = context != null
      ? MediaQuery.paddingOf(context)
      : MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        ).padding;

  final double bottomPadding = padding.bottom;
  return baseHeight + bottomPadding;
}
