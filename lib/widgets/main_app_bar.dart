import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Optional title
  final List<Widget>? actions; // Optional actions

  const MainAppBar({super.key, this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Make AppBar transparent
      elevation: 0, // Remove shadow
      centerTitle: true, // Center the title (optional)
      title: title != null ? Text(title!) : null, // Display title if provided
      actions: actions, // Display actions if provided
      iconTheme: IconThemeData(
        color: Theme.of(context).iconTheme.color, // Inherit icon color from theme
      ),
    );
  }
}