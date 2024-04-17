
String secondsToReadableTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  if (minutes == 0) {
    return '${remainingSeconds}s';
  }
  return '${minutes}m, ${remainingSeconds}s';
}
