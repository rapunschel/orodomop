import 'package:flutter/material.dart';
import 'package:orodomop/service_manager.dart';
import 'package:orodomop/timer_model.dart';
import 'package:orodomop/widgets/buttons/timer_control_row.dart';
import 'package:orodomop/widgets/stopwatches/count_down_watch.dart';
import 'package:orodomop/widgets/stopwatches/custom_stop_watch.dart';
import 'package:provider/provider.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(ServiceManager.onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      ServiceManager.requestPermissions();
      ServiceManager.initService();
    });
  }

  @override
  void dispose() {
    // Remove a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.removeTaskDataCallback(
      ServiceManager.onReceiveTaskData,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Selector<TimerModel, int>(
        selector: (context, model) => model.breakTimeRemaining,
        builder: (context, breakTime, child) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  breakTime > 0 ? CountDownWatch() : CustomStopWatch(),
                  SizedBox(height: 16),
                  TimerControlRow(),
                  _buildCommunicationDataText(),
                  _buildServiceControlButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommunicationDataText() {
    return ValueListenableBuilder(
      valueListenable: _taskDataListenable,
      builder: (context, data, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You received data from TaskHandler:'),
              Text('$data', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceControlButtons() {
    buttonBuilder(String text, {VoidCallback? onPressed}) {
      return ElevatedButton(onPressed: onPressed, child: Text(text));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buttonBuilder(
            'start service',
            onPressed: ServiceManager.startService,
          ),
          buttonBuilder('stop service', onPressed: ServiceManager.stopService),
          buttonBuilder(
            'increment count',
            onPressed: ServiceManager.incrementCount,
          ),
          buttonBuilder('time count', onPressed: ServiceManager.incrementCount),
        ],
      ),
    );
  }
}
