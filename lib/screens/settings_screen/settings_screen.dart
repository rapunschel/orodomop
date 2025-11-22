import 'package:flutter/material.dart';
import 'package:orodomop/screens/settings_screen/sections/general_settings_section.dart';
import 'package:orodomop/screens/settings_screen/sections/ui_settings_section.dart';
import 'package:orodomop/screens/settings_screen/sections/orodomop_settings_section.dart';
import 'package:orodomop/screens/settings_screen/sections/pomodoro_settings_section.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsProvider model = context.read<SettingsProvider>();
    final double spacing = 24;
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
                SizedBox(height: spacing),
                value.usePomodoro
                    ? PomodoroSettingsSection(model: model)
                    : OrodomopSettingsSection(model: model),
                SizedBox(height: spacing),
                UISettingsSection(model: model),
              ],
            ),
          ),
        );
      },
    );
  }
}
