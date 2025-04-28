import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';

class PauseOrResumeButton extends StatelessWidget {
  const PauseOrResumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, bool>(
      selector: (context, timerModel) => timerModel.isCounting,
      builder: (context, isCounting, child) {
        return ElevatedButton(
          onPressed: () {
            TimerModel model = context.read<TimerModel>();

            if (isCounting) {
              // Pause
              model.pause();
            } else {
              model.resume();
            }
          },
          child: Text(isCounting ? "Pause" : "Resume"),
        );
      },
    );
  }
}
