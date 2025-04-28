import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';

class EndBreakButton extends StatelessWidget {
  const EndBreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerModel>().endBreak();
      },
      child: Text("Stop"),
    );
  }
}
