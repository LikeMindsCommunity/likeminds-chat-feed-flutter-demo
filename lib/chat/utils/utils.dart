String getExpiryTimeString(DateTime expiryTime) {
  DateTime now = DateTime.now();
  Duration difference = expiryTime.difference(now);
  int inDays = difference.inDays;
  int inHours = difference.inHours;
  int inMinutes = difference.inMinutes;
  int inSeconds = difference.inSeconds;
  if (inDays > 1) {
    return '$inDays days';
  } else if (inDays == 1) {
    return '$inDays day';
  } else if (inHours > 1) {
    return '$inHours hours';
  } else if (inHours == 1) {
    return '$inHours hour';
  } else if (inMinutes > 1) {
    return '$inMinutes minutes';
  } else if (inMinutes == 1) {
    return '$inMinutes minute';
  } else if (inSeconds > 1) {
    return '$inSeconds seconds';
  } else if (inSeconds == 1) {
    return '$inSeconds second';
  }
  return '';
}

bool isPollEnded(DateTime expiryTime) {
  DateTime now = DateTime.now();
  Duration difference = expiryTime.difference(now);
  if (difference.isNegative) {
    return true;
  } else {
    return false;
  }
}
