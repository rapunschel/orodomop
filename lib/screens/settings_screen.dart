import 'package:flutter/material.dart';
import 'package:orodomop/widgets/buttons/toggle_theme_button.dart';
import 'package:orodomop/widgets/settings/settings_item.dart';
import 'package:orodomop/widgets/settings/settings_section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User interface settings
            Column(
              children: [
                SettingsSectionTitle(title: "UI Settings"),
                SettingsItem(text: "Dark mode", widget: ToggleThemeButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
