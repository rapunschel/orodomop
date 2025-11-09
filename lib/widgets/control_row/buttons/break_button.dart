import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/models/timer_model.dart';

class BreakButton extends StatelessWidget {
  const BreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      child: ElevatedButton(
        onPressed: () {
          _showBreakDialog(context);
        },
        child: Text("Break"),
      ),
    );
  }

  void _showBreakDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BreakDialog();
      },
    );
  }
}

class BreakDialog extends StatelessWidget {
  const BreakDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    void onSubmitted(dynamic value) {
      if (value.isNotEmpty) {
        int x = int.tryParse(value) ?? 0;
        if (x == 0) {
          Navigator.of(context).pop();
          return;
        }
        context.read<TimerModel>().relax(x);
      }
      Navigator.of(context).pop();
    }

    return AlertDialog(
      title: Text("Set Break Duration (1/X)"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            onSubmitted: (_) {
              onSubmitted(controller.text);
            },
            style: Theme.of(context).textTheme.bodyMedium,
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter X'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSubmitted(controller.text);
          },
          child: Text("OK"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
