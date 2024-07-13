import 'dart:convert';

import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/meta.dart';
import '../utils/parse_color.dart';

part 'themes.g.dart';

class ThemeColorModel {
  bool isDark = false;
  Color themeColor = const Color.fromARGB(255, 152, 201, 52);
  Color bgColor = const Color.fromARGB(255, 245, 245, 245);
  Color fgColor = const Color.fromARGB(255, 103, 103, 103);
  Color accentColor = const Color.fromARGB(255, 152, 201, 52);
  Color accentDarkenColor = const Color.fromARGB(255, 96, 128, 0);
  Color accentLightenColor = const Color.fromARGB(255, 172, 230, 0);
  Color accentedBgColor = const Color.fromARGB(38, 134, 179, 0);
  Color panelColor = const Color.fromARGB(255, 253, 253, 253);
  Color navBgColor = const Color.fromARGB(255, 253, 253, 253);
  Color headerColor = const Color.fromARGB(178, 255, 255, 255);
  Color dividerColor = const Color.fromARGB(26, 0, 0, 0);
  Color buttonGradateAColor = const Color.fromARGB(255, 134, 179, 0);
  Color buttonGradateBColor = const Color.fromARGB(255, 74, 179, 0);
  Color fgOnAccentColor = const Color.fromARGB(255, 255, 255, 255);
  Color reNoteColor = const Color.fromARGB(255, 34, 158, 130);
  Color buttonBgColor = const Color.fromARGB(12, 0, 0, 0);
  Color buttonHoverBgColor = const Color.fromARGB(25, 0, 0, 0);
  Color mentionColor = const Color.fromARGB(255, 134, 179, 0);
  Color shadowColor = const Color.fromARGB(25, 0, 0, 0);
  Color switchOffBgColor = const Color.fromARGB(25, 0, 0, 0);
  Color switchOffFgColor = const Color.fromARGB(255, 255, 255, 255);
  Color switchOnBgColor = const Color.fromARGB(255, 134, 179, 0);
  Color switchOnFgColor = const Color.fromARGB(255, 255, 255, 255);
  Color warnColor = const Color.fromARGB(255, 236, 182, 55);
  Color successColor = const Color.fromARGB(255, 152, 201, 52);
  Color errorColor = const Color.fromARGB(255, 236, 55, 109);
  Color windowHeaderColor = const Color.fromARGB(216, 255, 255, 255);
  Color modalBgColor = const Color.fromARGB(76, 0, 0, 0);
}

@Riverpod(keepAlive: true)
class ThemeColors extends _$ThemeColors {
  @override
  ThemeColorModel build() {
    return ThemeColorModel();
  }

  updateThemes(MetaDetailedModel metas) {
    var model = ThemeColorModel();
    if (metas.defaultLightTheme != null) {
      var themeData = jsonDecode(metas.defaultLightTheme!);
      Map<String, dynamic> themes = themeData["props"];
      model.isDark = themeData["base"] == "dark";
      model.accentColor =
          getThemesColor(themes["accent"] ?? "", themes) ?? model.accentColor;
      model.bgColor =
          getThemesColor(themes["bg"] ?? "", themes) ?? model.bgColor;
      model.fgColor =
          getThemesColor(themes["fg"] ?? "", themes) ?? model.fgColor;

      model.accentLightenColor =
          getThemesColor(themes["accentLighten"] ?? "", themes) ??
              model.accentLightenColor;
      model.accentedBgColor =
          getThemesColor(themes["accentedBg"] ?? "", themes) ??
              model.accentedBgColor;
      model.panelColor =
          getThemesColor(themes["panel"] ?? "", themes) ?? model.panelColor;
      model.navBgColor =
          getThemesColor(themes["navBg"] ?? "", themes) ?? model.navBgColor;
      model.headerColor =
          getThemesColor(themes["header"] ?? "", themes) ?? model.headerColor;
      model.dividerColor =
          getThemesColor(themes["divider"] ?? "", themes) ?? model.dividerColor;
      model.buttonGradateAColor =
          getThemesColor(themes["buttonGradateA"] ?? "", themes) ??
              model.buttonGradateAColor;
      model.buttonGradateBColor =
          getThemesColor(themes["buttonGradateB"] ?? "", themes) ??
              model.buttonGradateBColor;
      model.fgOnAccentColor =
          getThemesColor(themes["fgOnAccent"] ?? "", themes) ??
              model.fgOnAccentColor;
      model.reNoteColor =
          getThemesColor(themes["reNote"] ?? "", themes) ?? model.reNoteColor;

      model.buttonBgColor = getThemesColor(themes["buttonBg"] ?? "", themes) ??
          model.buttonBgColor;
      model.buttonHoverBgColor =
          getThemesColor(themes["buttonHover"] ?? "", themes) ??
              model.buttonHoverBgColor;
      model.mentionColor =
          getThemesColor(themes["mention"] ?? "", themes) ?? model.mentionColor;
      model.shadowColor =
          getThemesColor(themes["shadow"] ?? "", themes) ?? model.shadowColor;
      model.switchOffBgColor =
          getThemesColor(themes["switchOffBg"] ?? "", themes) ??
              model.switchOffBgColor;
      model.switchOffFgColor =
          getThemesColor(themes["switchOffFg"] ?? "", themes) ??
              model.switchOffFgColor;
      model.switchOnBgColor =
          getThemesColor(themes["switchOnBg"] ?? "", themes) ??
              model.switchOnBgColor;
      model.switchOnFgColor =
          getThemesColor(themes["switchOnFg"] ?? "", themes) ??
              model.switchOnFgColor;
      // Color shadowColor = const Color.fromARGB(25, 0, 0, 0);
      // Color switchOffBgColor = const Color.fromARGB(25, 0, 0, 0);
      // Color switchOffFgColor = const Color.fromARGB(255, 255, 255, 255);
      // Color switchOnBgColor = const Color.fromARGB(255, 134, 179, 0);
      // Color switchOnFgColor = const Color.fromARGB(255, 255, 255, 255);
      // Color warnColor = const Color.fromARGB(255, 236, 182, 55);
      // Color errorColor = const Color.fromARGB(255, 236, 55, 109);
      // Color windowHeaderColor = const Color.fromARGB(216, 255, 255, 255);

      model.themeColor = model.accentColor;
    }
    state = model;
  }
}

@Riverpod(keepAlive: true)
class Themes extends _$Themes {
  @override
  ThemeData build() {
    var colors = ref.watch(themeColorsProvider);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //       statusBarColor: Colors.transparent,
    //       statusBarBrightness:
    //           colors.isDark ? Brightness.dark : Brightness.light,
    //       statusBarIconBrightness:
    //           !colors.isDark ? Brightness.dark : Brightness.light,
    //       systemNavigationBarColor: Colors.black,
    //       systemNavigationBarIconBrightness:
    //           !colors.isDark ? Brightness.dark : Brightness.light,
    //       systemNavigationBarContrastEnforced: false),
    // );
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: colors.accentColor).copyWith(
        surface: colors.bgColor,
        onSurface: colors.fgColor,
        primary: colors.accentColor,
        onPrimary: colors.fgOnAccentColor,
      ),
      canvasColor: colors.bgColor,
      cardColor: colors.panelColor,
      useMaterial3: true,
      // fontFamily: Platform.isWindows ? "微软雅黑" : null,
      fontFamilyFallback: [...SystemChineseFont.fontFamilyFallback],
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: colors.fgColor,
        ),
        bodyLarge: TextStyle(
          color: colors.fgColor,
        ),
        titleMedium: TextStyle(
          color: colors.fgColor,
        ),
        displayMedium: TextStyle(
          color: colors.fgColor,
        ),
      ),
      scaffoldBackgroundColor: colors.bgColor,
      hintColor: colors.fgColor,
    );
  }
}
