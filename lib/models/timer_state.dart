enum TimerState {
  idle,
  onFocus,
  onBreak,
  paused;

  get isOnFocus => this == onFocus;
  get isIdle => this == idle;
  get isOnBreak => this == onBreak;
  get isPaused => this == paused;

  static TimerState fromString(String? timerState) {
    return TimerState.values.firstWhere(
      (state) => state.name == timerState,
      orElse: () => TimerState.idle,
    );
  }
}
