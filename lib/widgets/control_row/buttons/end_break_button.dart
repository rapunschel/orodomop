import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';

class EndBreakButton extends StatelessWidget {
  const EndBreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("End your break early?"),
              actions: [noButton(context), yesButton(context)],
            );
          },
        );
        //
      },
      child: Text("Stop"),
    );
  }

  TextButton noButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("No"),
    );
  }

  TextButton yesButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<TimerModel>().resetTimer();
        Navigator.of(context).pop();
      },
      child: Text("Yes"),
    );
  }
}
