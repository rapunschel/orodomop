import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class ToggleHideSettingsButton extends StatelessWidget {
  const ToggleHideSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, bool>(
      selector: (context, model) => model.hideSettingsButton,
      builder: (context, hideSettingsButton, child) {
        return Switch(
          value: hideSettingsButton,

          onChanged: (_) {
            if (hideSettingsButton) {
              context.read<SettingsProvider>().hideSettingsButton =
                  !hideSettingsButton;
              return;
            }

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    textAlign: TextAlign.center,
                    "Hide the settings icon",
                  ),
                  content: Text(
                    "To navigate to settings, double tap the timer",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        context.read<SettingsProvider>().hideSettingsButton =
                            !hideSettingsButton;
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
