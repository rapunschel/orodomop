class StringFormatter {
  static String formatTime(int seconds) {
    int hours;
    int minutes;
    int remSeconds;
    if (seconds < 60) {
      return seconds.toString().padLeft(2, '0');
    } else if (seconds < 3600) {
      minutes = (seconds % 3600) ~/ 60;
      remSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';
    }

    hours = seconds ~/ 3600;
    minutes = (seconds % 3600) ~/ 60;
    remSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';
  }
}
