import 'package:flutter/material.dart';
import 'package:orodomop/timer_model.dart';
import 'package:provider/provider.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerModel>().start();
      },
      child: Text("Start"),
    );
  }
}
