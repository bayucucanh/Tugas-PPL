String parseFromSeconds(double timeRemaining) {
  Duration time = Duration(seconds: timeRemaining.toInt());
  int seconds = time.inSeconds % 60;
  return '${time.inMinutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
}
