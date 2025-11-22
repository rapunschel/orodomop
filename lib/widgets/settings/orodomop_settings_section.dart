import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
import 'package:orodomop/widgets/settings/settings_item.dart';
import 'package:orodomop/widgets/settings/settings_section_title.dart';
import 'package:provider/provider.dart';

class OrodomopSettingsSection extends StatelessWidget {
  const OrodomopSettingsSection({super.key, required this.model});
  final SettingsProvider model;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, bool>(
      selector: (context, model) => model.rememberX,
      builder: (context, rememberX, child) {
        return Column(
          children: [
            SettingsSectionTitle(title: "Orodomop"),
            SettingsItem(
              text: "Remember X",
              widget: Switch(
                value: rememberX,
                onChanged: (value) {
                  model.rememberX = value;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
