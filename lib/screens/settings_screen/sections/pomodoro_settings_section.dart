import 'package:flutter/material.dart';
import 'package:orodomop/providers/settings_provider.dart';
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
              widget: PomodoroDurationTextForm(
                seconds: model.focusDuration,
                onSubmit: ({required seconds}) {
                  model.focusDuration = seconds;
                },
              ),
            ),

            SettingsItem(
              text: "Break duration (m)",
              widget: PomodoroDurationTextForm(
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

class PomodoroDurationTextForm extends StatefulWidget {
  const PomodoroDurationTextForm({
    super.key,
    required this.seconds,
    required this.onSubmit,
  });

  final int seconds;
  final Function({required int seconds}) onSubmit;

  @override
  State<PomodoroDurationTextForm> createState() =>
      _PomodoroDurationTextFormState();
}

class _PomodoroDurationTextFormState extends State<PomodoroDurationTextForm> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late String originalValue;

  @override
  void initState() {
    super.initState();
    originalValue = (widget.seconds ~/ 60).toString();
    _controller = TextEditingController(text: originalValue);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.text = originalValue;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (value) {
        int? minutes = int.tryParse(value);

        if (minutes != null && minutes > 0) {
          widget.onSubmit(seconds: minutes * 60);
          originalValue = minutes.toString();
        } else {
          _controller.text = originalValue;
        }

        _focusNode.unfocus();
      },
    );
  }
}
