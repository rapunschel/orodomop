import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_item.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_section_title.dart';
import 'package:orodomop/screens/settings_screen/widgets/timer_mode_toggle.dart';
import 'package:provider/provider.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, ({bool usePomodoro})>(
      selector: (context, model) => (usePomodoro: model.usePomodoro),
      builder: (context, value, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "General"),
            SettingsItem(
              text: "Use Pomodoro",
              widget: TimerModeToggle(model: model),
            ),
          ],
        );
      },
    );
  }
}
