import 'package:flutter/material.dart';

Map<int, String> tabName = {
  0: 'Категории',
  1: 'Корзина',
  2: 'Дом',
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  //final TabItem currentTab;
  final int currentTab;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: 0, tabIcon: Icons.list),
        _buildItem(tabItem: 1, tabIcon: Icons.shopping_basket),
        _buildItem(tabItem: 2, tabIcon: Icons.home),
        // _buildItem(tabItem: TabItem.blue),
      ],
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem({int tabItem, IconData tabIcon}) {
    String text = tabName[tabItem];
    IconData icon = tabIcon;
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({int item}) {
    return currentTab == item ? Colors.blue : Colors.grey;
  }
}
