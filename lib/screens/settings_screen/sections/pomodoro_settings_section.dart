import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_duration_text_form.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_item.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_section_title.dart';
import 'package:provider/provider.dart';

class PomodoroSettingsSection extends StatelessWidget {
  const PomodoroSettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, ({int focusDuration, int breakDuration})>(
      selector:
          (context, model) => (
            focusDuration: model.focusDuration,
            breakDuration: model.breakDuration,
          ),
      builder: (context, value, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "Pomodoro"),
            SettingsItem(
              text: "Focus duration (m)",
              widget: SettingsDurationTextForm(
                seconds: model.focusDuration,
                onSubmit: ({required seconds}) {
                  model.focusDuration = seconds;
                },
              ),
            ),

            SettingsItem(
              text: "Break duration (m)",
              widget: SettingsDurationTextForm(
                seconds: model.breakDuration,
                onSubmit: ({required seconds}) {
                  model.breakDuration = seconds;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
