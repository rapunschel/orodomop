import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.text, required this.widget});

  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.08,
        right: MediaQuery.of(context).size.width * 0.25,
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(text, textAlign: TextAlign.right)),
          SizedBox(width: 10),
          Expanded(flex: 1, child: widget),
        ],
      ),
    );
  }
}
