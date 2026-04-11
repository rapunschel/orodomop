import 'package:flutter/material.dart';

class SettingsDurationTextForm extends StatefulWidget {
  const SettingsDurationTextForm({
    super.key,
    required this.seconds,
    required this.onSubmit,
  });

  final int seconds;
  final Function({required int seconds}) onSubmit;

  @override
  State<SettingsDurationTextForm> createState() =>
      _SettingsDurationTextFormState();
}

class _SettingsDurationTextFormState extends State<SettingsDurationTextForm> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late String originalValue;
  String _newVal = "";

  @override
  void initState() {
    super.initState();
    originalValue = (widget.seconds ~/ 60).toString();
    _controller = TextEditingController(text: originalValue);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        onValueChanged(_newVal);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onValueChanged(String value) {
    int? minutes = int.tryParse(value);

    if (minutes != null && minutes > 0) {
      widget.onSubmit(seconds: minutes * 60);
      originalValue = minutes.toString();
    } else {
      _controller.text = originalValue;
    }

    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      onFieldSubmitted: onValueChanged,
      onChanged: (value) => _newVal = value,
    );
  }
}
