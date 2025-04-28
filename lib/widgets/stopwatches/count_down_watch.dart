import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orodomop/timer_model.dart';
import 'package:provider/provider.dart';

class CountDownWatch extends StatelessWidget {
  const CountDownWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, int>(
      selector: (context, timerModel) => timerModel.breakTimeRemaining,
      builder: (context, time, child) {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: AutoSizeText(
                TimerModel.formatTime(time),
                maxLines: 1,
                maxFontSize: 68,
                style: TextStyle(fontSize: 68),
              ),
            ),
          ),
        );
      },
    );
  }
}
