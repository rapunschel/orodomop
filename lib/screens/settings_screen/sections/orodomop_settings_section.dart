import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_item.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_section_title.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/screens/settings_screen/widgets/settings_duration_text_form.dart';

class OrodomopSettingsSection extends StatelessWidget {
  const OrodomopSettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<
      SettingsProvider,
      ({bool rememberX, bool reminderEnabled, int breakReminderSeconds})
    >(
      selector:
          (context, model) => (
            rememberX: model.rememberX,
            reminderEnabled: model.breakReminderEnabled,
            breakReminderSeconds: model.breakReminderSeconds,
          ),
      builder: (context, values, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "Orodomop"),
            SettingsItem(
              text: "Remember X",
              widget: Switch(
                value: values.rememberX,
                onChanged: (value) {
                  model.rememberX = value;
                },
              ),
            ),
            SettingsItem(
              text: "Enable break reminder",
              widget: Switch(
                value: values.reminderEnabled,
                onChanged: (value) {
                  model.breakReminderEnabled = value;
                },
              ),
            ),
            SettingsItem(
              text: "Break reminder (m)",
              widget: SettingsDurationTextForm(
                seconds: values.breakReminderSeconds,
                onSubmit: ({required seconds}) {
                  model.breakReminderSeconds = seconds;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
