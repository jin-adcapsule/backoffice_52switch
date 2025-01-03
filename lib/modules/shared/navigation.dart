import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/members/member_screen.dart';
import 'package:backoffice52switch/utils/constants.dart'; // For app configuration
class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  final String objectId = Constants.objectId; // Use from config
    // Cache for storing created screens
  //final Map<String, Widget> _screenCache = {};
  final Map<String, Widget Function()> _screenCache = {};

  void _onItemTapped(String key) {
    setState(() {
      Constants.selectedKeyNotifier.value = key; // Update the notifier
    });
  }
  List<Map<String, dynamic>> getTabs() {
    return Constants.tabConfig.toList();
  }

  Widget _getSelectedScreen(String selectedKey) {
  if (_screenCache.containsKey(selectedKey)) {
    return _screenCache[selectedKey]!(); // Call the cached function to create a fresh screen
  }
  // If the screen isn't cached, create a factory function and store it in the Map
  Widget Function() screenFactory;
  switch (selectedKey) {
    case 'members':
      screenFactory = () => createMemberScreen();
      break;
    
    default:
      screenFactory = () => createMemberScreen();
      break;
  }
  // Store the factory in the cache
  _screenCache[selectedKey] = screenFactory;

  return screenFactory();
}



//buildformat
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Constants.selectedKeyNotifier,
      builder: (context, selectedKey, child) {
        final tabs = getTabs();
        return Scaffold(
          body: _getSelectedScreen(selectedKey),//bodyscreen load from each screen file

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Constants.getColor(ColorType.background),
            elevation: 0,
            items: tabs.map((tab) {
              return BottomNavigationBarItem(
                icon: Icon(tab['icon']),
                label: tab['label'],
              );
            }).toList(),
            currentIndex: tabs.indexWhere((tab) => tab['key'] == selectedKey),
            onTap: (index) => _onItemTapped(tabs[index]['key']),
            selectedItemColor: Constants.getColor(ColorType.selectedItem),
            unselectedItemColor: Constants.getColor(ColorType.unselectedItem),
            showUnselectedLabels: true,
          ),
        );
      }
    );
  }
}
