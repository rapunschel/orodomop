import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/models/string_formatter.dart';

class CustomStopWatch extends StatelessWidget {
  const CustomStopWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, int>(
      selector: (context, timerModel) => timerModel.focusTime,
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
                StringFormatter.formatTime(time),
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
