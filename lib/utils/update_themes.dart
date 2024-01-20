Future getInstanceMetaAndUpdateThemes() async {
  // var response = await NetWork.meta();
  //
  // if (response.data != null) {
  //   var res = response.data;
  //
  //   ServerMetaModel.metaData.value = res;
  //
  //   if (res["defaultLightTheme"] != null) {
  //     var themes = jsonDecode(res["defaultLightTheme"])["props"];
  //     ThemeColorModel.accentColor.value = parseColor(themes["accent"]);
  //     ThemeColorModel.bgColor.value = parseColor(themes["bg"]);
  //     ThemeColorModel.fgColor.value = parseColor(themes["fg"]);
  //     ThemeColorModel.themeColor.value = ThemeColorModel.accentColor.value;
  //   } else {
  //     if (res["themeColor"] != null) {
  //       ThemeColorModel.themeColor.value =
  //           const Color.fromARGB(255, 152, 201, 52);
  //     }
  //   }
  //
  //   var theme = ThemeData(
  //       useMaterial3: true,
  //       colorScheme:
  //           ColorScheme.fromSeed(seedColor: ThemeColorModel.themeColor.value),
  //       fontFamily: "微软雅黑",
  //       textTheme: TextTheme(
  //         bodyMedium: TextStyle(
  //           color: ThemeColorModel.fgColor.value,
  //         ),
  //       ),
  //       textSelectionTheme: TextSelectionThemeData(
  //         selectionColor: ThemeColorModel.themeColor.value.withOpacity(0.3),
  //       ));
  //   Get.changeTheme(theme);
  // }
  //
  // return response.data;
}
