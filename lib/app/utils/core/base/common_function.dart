import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class CommonFunction {
  static String getFormattedDateTime(String timestamp) {
    // Parse the timestamp string
    DateTime dateTime = DateTime.parse(timestamp);

    // Format the date and time
    return DateFormat('MM-dd-yy HH:mm').format(dateTime);
  }
}
