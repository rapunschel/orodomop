import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:orodomop/widgets/buttons/break_button.dart';
import 'package:orodomop/widgets/buttons/end_break_button.dart';
import 'package:orodomop/widgets/buttons/pause_or_resume_button.dart';
import 'package:orodomop/widgets/buttons/start_button.dart';
import 'package:provider/provider.dart';

class TimerControlRow extends StatelessWidget {
  const TimerControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, List>(
      selector:
          (context, timerModel) => [
            timerModel.focusTime,
            timerModel.breakTimeRemaining,
            timerModel.isCounting,
          ],
      builder: (context, values, child) {
        int focusTime = values[0];
        int breakTime = values[1];
        bool isCounting = values[2];
        if (focusTime == 0 && breakTime <= 0 && !isCounting) {
          return StartButton();
        }

        if (breakTime > 0) {
          return EndBreakButton();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PauseOrResumeButton(),
                SizedBox(width: 16),
                BreakButton(),
              ],
            ),
            ResetButton(),
          ],
        );
      },
    );
  }
}

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
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<TimerModel>().resetTimer();
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No"),
                ),
              ],
            );
          },
        );
        //
      },
      child: Text("Reset", style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
