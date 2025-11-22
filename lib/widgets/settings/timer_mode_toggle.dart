import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class TimerModeToggle extends StatelessWidget {
  const TimerModeToggle({super.key, required this.model});

  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, ({bool usePomodoro})>(
      selector: (context, model) => (usePomodoro: model.usePomodoro),
      builder: (context, value, child) {
        return Switch(
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
                  content: Text("Timer in progress will be reset. Proceed?"),
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
        );
      },
    );
  }
}
