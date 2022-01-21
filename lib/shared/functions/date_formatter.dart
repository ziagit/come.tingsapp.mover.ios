import 'package:intl/intl.dart';

String dateFormatter(date) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return formattedDate;
}

String roomDate(date) {
  var dt = DateTime.parse(date);
  DateTime now = DateTime.now();

  int day = dt.day;
  int month = dt.month;
  int year = dt.year;
  int daysDiff = now.day - day;
  int monthsDiff = now.month - month;
  int yearsDiff = now.year - year;

  if (yearsDiff == 0 && daysDiff == 0 && monthsDiff == 0) {
    int h = dt.hour == 0 ? 12 : dt.hour;
    var suffix = h >= 12 ? "PM" : "AM";
    return h.toString() + ":" + dt.minute.toString() + " " + suffix;
  } else if (yearsDiff == 0 && monthsDiff == 0 && daysDiff == 1) {
    return "Yesterday";
  } else if (yearsDiff == 0 &&
      monthsDiff == 0 &&
      daysDiff > 1 &&
      daysDiff <= 7) {
    return getDay(dt.day);
  } else if (yearsDiff == 0 && monthsDiff != 0) {
    return getMonth(dt.month);
  } else if (yearsDiff >= 1) {
    return getMonth(month) + " " + date + ", " + dt.year.toString();
  } else {
    return month.toString();
  }
}

String getMonth(month) {
  var m = "";
  switch (month) {
    case 0:
      m = "January";
      break;
    case 1:
      m = "February";
      break;
    case 2:
      m = "March";
      break;
    case 3:
      m = "April";
      break;
    case 4:
      m = "May";
      break;
    case 5:
      m = "June";
      break;
    case 6:
      m = "July";
      break;
    case 7:
      m = "August";
      break;
    case 8:
      m = "September";
      break;
    case 9:
      m = "October";
      break;
    case 10:
      m = "Novermber";
      break;
    case 11:
      m = "December";
      break;
  }
  return m;
}

String getDay(day) {
  var d = "";
  switch (day) {
    case 0:
      d = "Sunday";
      break;
    case 1:
      d = "Monday";
      break;
    case 2:
      d = "Tuesday";
      break;
    case 3:
      d = "Wednesday";
      break;
    case 4:
      d = "Thursday";
      break;
    case 5:
      d = "Friday";
      break;
    case 6:
      d = "Saturday";
      break;
    default:
      d = day.toString();
      break;
  }
  return d;
}
