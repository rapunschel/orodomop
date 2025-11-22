import 'package:flutter/material.dart';
import 'package:orodomop/widgets/buttons/toggle_theme_button.dart';
import 'package:orodomop/widgets/settings/settings_item.dart';
import 'package:orodomop/widgets/settings/settings_section_title.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsProvider model = context.read<SettingsProvider>();
    return Selector<SettingsProvider, ({bool usePomodoro})>(
      selector: (context, model) => (usePomodoro: model.usePomodoro),
      builder: (context, value, child) {
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
                GeneralSettingsSection(model: model),
                UISettingsSection(model: model),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UISettingsSection extends StatelessWidget {
  const UISettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, ({bool usePomodoro})>(
      selector: (context, model) => (usePomodoro: model.usePomodoro),
      builder: (context, value, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "User Interface"),
            SettingsItem(text: "Dark mode", widget: ToggleThemeButton()),
          ],
        );
      },
    );
  }
}

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
              widget: Switch(
                value: value.usePomodoro,
                onChanged: (_) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          textAlign: TextAlign.center,
                          value.usePomodoro
                              ? "Switch to Orodomop"
                              : "Switch to Pomodoro",
                        ),
                        content: Text(
                          "Timer in progress will be reset. Proceed?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                              model.usePomodoro = !value.usePomodoro;
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
