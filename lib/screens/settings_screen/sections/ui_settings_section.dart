import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/screens/timer_screen/widgets/buttons/toggle_theme_button.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_item.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_section_title.dart';
import 'package:orodomop/screens/settings_screen/widgets/toggle_hide_settings_button.dart';
import 'package:provider/provider.dart';

class UISettingsSection extends StatelessWidget {
  const UISettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<
      SettingsProvider,
      ({bool usePomodoro, bool hideSettingsButton})
    >(
      selector:
          (context, model) => (
            usePomodoro: model.usePomodoro,
            hideSettingsButton: model.hideSettingsButton,
          ),
      builder: (context, value, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "User Interface"),
            SettingsItem(text: "Dark mode", widget: ToggleThemeButton()),
            SettingsItem(
              text: "Hide settings icon",
              widget: ToggleHideSettingsButton(),
            ),
          ],
        );
      },
    );
  }
}
