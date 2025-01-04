import 'package:flutter/material.dart';

Color parseColor(String colorString) {
  // 去除首尾空格
  colorString = colorString.trim();
  if (colorString.toLowerCase().startsWith('rgb')) {
    // 解析rgb(x,x,x)格式
    final List<String> rgbValues = colorString
        .substring(colorString.indexOf('(') + 1, colorString.indexOf(')'))
        .split(',');

    if (rgbValues.length == 3) {
      final int red = int.parse(rgbValues[0].trim());
      final int green = int.parse(rgbValues[1].trim());
      final int blue = int.parse(rgbValues[2].trim());
      return Color.fromRGBO(red, green, blue, 1.0);
    }
  }
  if (colorString.toLowerCase().startsWith('#')) {
    // 解析#xxxxxx格式
    final String hex = colorString.substring(1);
    if (hex.length == 8) {
      // R G B A
      final int red = int.parse(hex.substring(0, 2), radix: 16);
      final int green = int.parse(hex.substring(2, 4), radix: 16);
      final int blue = int.parse(hex.substring(4, 6), radix: 16);
      final int alpha = int.parse(hex.substring(6, 8), radix: 16);

      return Color.fromRGBO(red, green, blue, alpha / 255.0);
    }
    if (hex.length == 6) {
      final int red = int.parse(hex.substring(0, 2), radix: 16);
      final int green = int.parse(hex.substring(2, 4), radix: 16);
      final int blue = int.parse(hex.substring(4, 6), radix: 16);
      return Color.fromRGBO(red, green, blue, 1.0);
    }
    if (hex.length == 3) {
      final int red =
          int.parse(hex.substring(0, 1) + hex.substring(0, 1), radix: 16);
      final int green =
          int.parse(hex.substring(1, 2) + hex.substring(1, 2), radix: 16);
      final int blue =
          int.parse(hex.substring(2, 3) + hex.substring(2, 3), radix: 16);
      return Color.fromRGBO(red, green, blue, 1.0);
    }
  }
  if (colorString.toLowerCase().startsWith('rgba')) {
    // 解析rgba(x,x,x,x)格式
    final List<String> rgbaValues = colorString
        .substring(colorString.indexOf('(') + 1, colorString.indexOf(')'))
        .split(',');

    if (rgbaValues.length == 4) {
      final int red = int.parse(rgbaValues[0].trim());
      final int green = int.parse(rgbaValues[1].trim());
      final int blue = int.parse(rgbaValues[2].trim());
      final double alpha = double.parse(rgbaValues[3].trim());
      return Color.fromRGBO(red, green, blue, alpha);
    }
  }

  // 默认返回黑色
  return Colors.white;
}

Color transformColor(
  Color color, {
  int lighten = 0,
  int darken = 0,
  double alpha = 1.0,
  double hue = 0.0,
  double saturate = 1.0,
}) {
  assert(lighten >= 0 && lighten <= 100);
  assert(darken >= 0 && darken <= 100);
  assert(alpha >= 0.0 && alpha <= 1.0);
  assert(hue >= -360.0 && hue <= 360.0);
  assert(saturate >= 0.0 && saturate <= 1.0);

  final hslColor = HSLColor.fromColor(color);

  final lightness = (hslColor.lightness + (lighten / 100.0) - (darken / 100.0))
      .clamp(0.0, 1.0);
  final saturation = hslColor.saturation * saturate;
  final hueAngle = hslColor.hue + hue;

  final newHslColor = HSLColor.fromAHSL(alpha, hueAngle, saturation, lightness);
  return newHslColor.toColor();
}

Color? getThemesColor(String color, Map<String, dynamic> colorProps) {
  if (color == "") {
    return null;
  } else if (color.startsWith("@")) {
    return getThemesColor(colorProps[color.substring(1)]!, colorProps);
  } else if (color.startsWith("\$")) {
    return null;
  } else if (color.startsWith(":")) {
    var text = color.substring(1).split("<");
    return transformColor(
      getThemesColor(text[2], colorProps)!,
      lighten: text[0] == "lighten" ? int.parse(text[1]) : 0,
      darken: text[0] == "darken" ? int.parse(text[1]) : 0,
      alpha: text[0] == "alpha" ? double.parse(text[1]) : 1.0,
      hue: text[0] == "hue" ? double.parse(text[1]) : 0.0,
      saturate: text[0] == "saturate" ? double.parse(text[1]) : 1.0,
    );
  } else {
    return parseColor(color);
  }
}
