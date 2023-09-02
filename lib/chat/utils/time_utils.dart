/*
* Calculates the diff between current time and poll expiry time
* converts the difference into a string that can be displayed in the UI
* eg: 1 day, 2 hours, 3 minutes, 4 seconds
*/
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

/* 
* This function is used to check if the poll has ended
* returns true if the poll has ended
*/
bool isPollEnded(DateTime expiryTime) {
  DateTime now = DateTime.now();
  Duration difference = expiryTime.difference(now);
  if (difference.isNegative) {
    return true;
  } else {
    return false;
  }
}
