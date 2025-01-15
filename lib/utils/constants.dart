// config.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For platform
// Enum for color index types
enum ColorType {
  background,
  selectedItem,
  unselectedItem,
  text,
}

class Constants {
  // Determine whether the app is running on web or mobile
  static bool isWebOrDesktop = (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  static const double menuExpandedSize =160;//MediaQuery.of(context).size.width * 0.1;
  static const double menuCollapsedSize =70;//MediaQuery.of(context).size.width * 0.04;

  static final ValueNotifier<double> menuWidth = ValueNotifier(menuExpandedSize); // Initial width of the menu
  static final ValueNotifier<String> selectedKeyNotifier =
      ValueNotifier("members");
  //static int? employeeId; // Example: This can be loaded from an environment variable or a secure storage
  static late String
      employeeOid; // Nullable until assigned after successful login
  static late String
      employeeName; // Nullable until assigned after successful login
  static const String appName = "Admin52Switch";
  static const String noDataFoundMessage = "No data found.";
  static const String notificationsTitle = "Notifications";

// Fixed tab indices for navigation

  static final List<Map<String, dynamic>> tabConfig = [
    {
      'label': '팀원관리',
      'icon': Icons.person,
      'key': 'members',
      'idx': 0,
      'appbarTitle': '팀원관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '그룹관리',
      'icon': Icons.group_add,
      'key': 'groups',
      'idx': 1,
      'appbarTitle': '그룹관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '신청관리',
      'icon': Icons.content_paste_search,
      'key': 'requests',
      'idx': 1,
      'appbarTitle': '신청관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '수퍼어드민',
      'icon': Icons.admin_panel_settings,
      'key': 'superadmin',
      'idx': 2,
      'appbarTitle': '수퍼어드민',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
  ];
  static String getAppbarTitle(String selectedKey) {
    return tabConfig
        .firstWhere((tab) => tab['key'] == selectedKey)['appbarTitle'];
  }

  //Unified function to get colors
  static Color getColor(
    ColorType type, {
    String? selectedKey,
  }) {
    // Determine the selected tab's key or use the current selected key
    String key = selectedKey ?? selectedKeyNotifier.value;

    // Check if the key exists in tabConfig
    final tab = tabConfig.firstWhere(
      (tab) => tab['key'] == key,
      orElse: () => {
        'error': 'Key not found'
      }, // Ensure this returns null if no match is found
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
    List<Color> palette = tab['colorPalette'];

    // Return the color based on the type
    return palette[colorIndex];
  }


  // Fixed tab indices for DB collection

  static final List<Map<String, dynamic>> collectionConfig = [
    {
      'label': '팀원관리',
      'icon': Icons.person,
      'key': 'Employee',
      'idx': 0,
      'appbarTitle': '팀원관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '그룹관리',
      'icon': Icons.group_add,
      'key': 'Attendance',
      'idx': 1,
      'appbarTitle': '그룹관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '신청관리',
      'icon': Icons.content_paste_search,
      'key': 'Dayoff',
      'idx': 1,
      'appbarTitle': '신청관리',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '수퍼어드민',
      'icon': Icons.admin_panel_settings,
      'key': 'Group',
      'idx': 2,
      'appbarTitle': '수퍼어드민',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
    {
      'label': '수퍼어드민',
      'icon': Icons.admin_panel_settings,
      'key': 'Location',
      'idx': 2,
      'appbarTitle': '수퍼어드민',
      'colorPalette': [Colors.white, Colors.blue, Colors.black, Colors.black],
    },
  ];
}
