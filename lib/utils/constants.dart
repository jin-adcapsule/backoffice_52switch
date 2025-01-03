
// config.dart
import 'package:flutter/material.dart';

// Enum for color index types
enum ColorType {
  background,
  selectedItem,
  unselectedItem,
  text,
}

class Constants {
  static final ValueNotifier<String> selectedKeyNotifier = ValueNotifier(
      "attendance");
  //static int? employeeId; // Example: This can be loaded from an environment variable or a secure storage
  static late String objectId; // Nullable until assigned after successful login
  static late String employeeName; // Nullable until assigned after successful login
  static const String appName = "52SWITCH";
  static const String noDataFoundMessage = "No data found.";
  static const String notificationsTitle = "Notifications";


// Fixed tab indices for navigation

  static final List<Map<String, dynamic>> tabConfig = [
    {
      'label': '출/퇴근관리',
      'icon': Icons.access_time,
      'key': 'attendance',
      'idx': 0,
      'appbarTitle': '52SWITCH',
      'colorPalette': [Color.fromRGBO(224, 94, 102, 1.0), Colors.white, Color.fromRGBO(230, 138, 139, 1.0), Colors.white],
      'colorPaletteDark': [Color.fromRGBO(42, 42, 42, 1.0), Colors.white, Color.fromRGBO(105, 105, 105, 1.0), Colors.white],
    },
    {
      'label': '신청관리',
      'icon': Icons.content_paste_search,
      'key': 'dayoff',
      'idx': 1,
      'appbarTitle': '신청관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
      'colorPaletteDark': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '관리자',
      'icon': Icons.admin_panel_settings,
      'key': 'supervisor',
      'idx': 2,
      'appbarTitle': '팀원관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
      'colorPaletteDark': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '나의 정보',
      'icon': Icons.person,
      'key': 'myinfo',
      'idx': 3,
      'appbarTitle': '나의 정보',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
      'colorPaletteDark': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '더보기',
      'icon': Icons.add_rounded,
      'key': 'more',
      'idx': 4,
      'appbarTitle': '더보기',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
      'colorPaletteDark': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
  ];
  static String getAppbarTitle(String selectedKey) {
    return tabConfig.firstWhere((tab) => tab['key'] == selectedKey)['appbarTitle'];
  }

  //Unified function to get colors
static Color getColor(
  ColorType type, {
  String? selectedKey,
  bool? isAttendanceMarked,
}) {
  // Determine the selected tab's key or use the current selected key
  String key = selectedKey ?? selectedKeyNotifier.value;

  // Check if the key exists in tabConfig
  final tab = tabConfig.firstWhere(
        (tab) => tab['key'] == key,
    orElse: () => {'error': 'Key not found'}, // Ensure this returns null if no match is found
  );
  if (tab.containsKey('error')) {
    throw ArgumentError('Error: ${tab['error']}');
  }

  // Map ColorType to the index in the color palette
  int colorIndex;
  switch (type) {
    case ColorType.background:
      colorIndex = 0;
      break;
    case ColorType.selectedItem:
      colorIndex = 1;
      break;
    case ColorType.unselectedItem:
      colorIndex = 2;
      break;
    case ColorType.text:
      colorIndex = 3;
      break;
  }

  // Retrieve the correct palette based on attendance status
  List<Color> palette =  tab['colorPalette'];

  // Return the color based on the type
  return palette[colorIndex];
}


}



