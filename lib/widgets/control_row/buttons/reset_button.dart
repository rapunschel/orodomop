import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Reset timer?"),
              actions: [noButton(context), yesButton(context)],
            );
          },
        );
        //
      },
      child: Text("Reset", style: Theme.of(context).textTheme.bodySmall),
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
