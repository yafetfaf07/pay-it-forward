import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatelessWidget {
  final void Function(int)? onChange;
  final int selectedIndex;

  const BottomNavigation({
    super.key,
    required this.onChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
      color: Colors.grey.shade50,
      ),
      child: GNav(
        tabBackgroundGradient: LinearGradient(colors: [const Color.fromARGB(255, 219, 124, 235),const Color.fromARGB(255, 133, 194, 244)]),
        selectedIndex: selectedIndex,
        activeColor: const Color.fromARGB(255, 255, 255, 255),
        tabBorderRadius: 20,
        onTabChange: onChange,
        gap: 8,
        tabs: const [
          GButton(iconSize: 20, icon: Icons.home, text: "Home",),
          GButton(iconSize: 20, icon: Icons.attach_money, text: "Charity"),
          GButton(iconSize: 20, icon: Icons.person, text: "Profile"),
        ],
      ),
    );
  }
}
