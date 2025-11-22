import 'package:flutter/material.dart';
import 'package:orodomop/widgets/buttons/toggle_theme_button.dart';
import 'package:orodomop/widgets/settings/settings_item.dart';
import 'package:orodomop/widgets/settings/settings_section_title.dart';
import 'package:orodomop/widgets/settings/timer_mode_toggle.dart';
import 'package:orodomop/widgets/settings/toggle_hide_settings_button.dart';
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
