import 'package:flutter/material.dart';
import 'package:orodomop/widgets/buttons/toggle_theme_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Dark mode "), ToggleThemeButton()],
            ),
          ],
        ),
      ),
    );
  }
}
