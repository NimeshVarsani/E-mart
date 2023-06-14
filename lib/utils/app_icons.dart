// ignore_for_file: non_constant_identifier_names, file_names

class AppIcons {
  AppIcons._();

  //for png
  static const String _basePathPng = "assets/images/";

  static String splash_logo = _jpgPath("emart");
  static String home_filled = _pngPath("home_filled");
  static String home_outlined = _pngPath("home_outlined");
  static String categories_outline = _pngPath("categories_outline");
  static String categories_fill = _pngPath("categories_fill");
  static String bell_outline = _pngPath("bell_outline");
  static String bell_fill = _pngPath("bell_fill");
  static String trolley_outlined = _pngPath("trolley_outlined");
  static String trolley_filled = _pngPath("trolley_filled");
  static String user_outlined = _pngPath("user_outlined");
  static String user_filled = _pngPath("user_filled");
  static String profile_user = _pngPath("profile_user");

  static String _pngPath(String name) {
    return "$_basePathPng$name.png";
  }
  static String _jpgPath(String name) {
    return "$_basePathPng$name.jpg";
  }

}





