String secondsToReadableTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  if (minutes == 0) {
    return '${remainingSeconds}s';
  }
  if (remainingSeconds == 0) {
    return '${minutes}m';
  }
  return '${minutes}m, ${remainingSeconds}s';
}
