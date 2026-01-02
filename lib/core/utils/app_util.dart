import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:task_flow/core/services/preference_service.dart';

class AppUtil {
  static bool isPasswordValid(String password) {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%\^&\*~\+\-\=\_\?\.]).{8,}$',
    ).hasMatch(password);
  }

  static Future<void> setLastRecordDownloadDate({required String key}) async {
    try {
      await PreferenceService().setString(
        key,
        AppUtil.formattedDateTimeIntoString(DateTime.now()),
      );
    } catch (e) {
      //
    }
  }

  static Future<String> getLastRecordDownloadDate({required String key}) async {
    String lastDate = '';
    try {
      var date = await PreferenceService().getString(key);
      lastDate = date ?? lastDate;
    } catch (e) {
      //
    }
    return lastDate;
  }

  static List<Map<String, String>> getPaginationFilters({
    required Response response,
    int pageSize = 50,
  }) {
    List<Map<String, String>> pageFilters = [];
    if (response.statusCode == 200) {
      Map body = json.decode(response.body);
      Map pager = body['pager'] ?? {};
      int total = pager['total'] ?? pageSize;
      for (int page = 1; page <= (total / pageSize).ceil(); page++) {
        pageFilters.add({'page': '$page', 'pageSize': '$pageSize'});
      }
    }
    return pageFilters;
  }

  static String getCommaSeparatedValue(dynamic value) {
    String decimalvalue = '$value'.contains('.')
        ? '$value'.split('.').lastOrNull ?? ''
        : '';
    String noDecimalValue = '$value'.contains('.')
        ? '$value'.split('.').first
        : '$value';
    const separator = ',';
    List characters = noDecimalValue.split('');
    String commaSeparatedValue = '';
    for (int index = characters.length - 1; index >= 0; index--) {
      if ((characters.length - 1 - index) % 3 == 0 &&
          index != characters.length - 1) {
        commaSeparatedValue = separator + commaSeparatedValue;
      }
      commaSeparatedValue = characters[index] + commaSeparatedValue;
    }
    if (decimalvalue.length > 2) {
      decimalvalue = decimalvalue.substring(0, 2);
    }
    return decimalvalue.isNotEmpty && decimalvalue != '0'
        ? '$commaSeparatedValue.$decimalvalue'
        : commaSeparatedValue;
  }

  static String getUid() {
    Random rnd = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const allowedChars = '0123456789$letters';
    const numberOfCodePoints = allowedChars.length;
    const codeSize = 11;
    String uid;
    int charIndex = (rnd.nextInt(10) / 10 * letters.length).round();
    uid = letters.substring(charIndex, charIndex + 1);
    for (int i = 1; i < codeSize; ++i) {
      charIndex = (rnd.nextInt(10) / 10 * numberOfCodePoints).round();
      uid += allowedChars.substring(charIndex, charIndex + 1);
    }
    return uid;
  }

  static String getLastSundayDate() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    DateTime lastSunday = now.subtract(Duration(days: weekday));
    return formattedDateTimeIntoString(lastSunday);
  }

  static String formattedDateTimeIntoString(DateTime date) {
    return date.toIso8601String().split('T')[0].trim();
  }

  static DateTime getDateIntoDateTimeFormat(String date) {
    return DateTime.parse(date);
  }

  static String formattedTimeOfDayIntoString(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour > 9
        ? '${timeOfDay.hour}'
        : '0${timeOfDay.hour}';
    String minute = timeOfDay.minute > 9
        ? '${timeOfDay.minute}'
        : '0${timeOfDay.minute}';
    return '$hour:$minute';
  }

  static TimeOfDay getTimeIntoDTimeOfDayFormat(String time) {
    List<String> timeArray = time.split(':');
    int hour = TimeOfDay.now().hour;
    int minute = TimeOfDay.now().minute;
    if (timeArray.length > 1) {
      try {
        hour = int.parse(timeArray[0]);
        minute = int.parse(timeArray[1]);
      } catch (e) {
        //
      }
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  static List<List<dynamic>> chunkItems({
    List<dynamic> items = const [],
    int size = 0,
  }) {
    List<List<dynamic>> groupedItems = [];
    size = size != 0 ? size : items.length;
    for (var count = 1; count <= (items.length / size).ceil(); count++) {
      int start = (count - 1) * size;
      int end = (count * size);
      List<dynamic> subList = items.sublist(
        start,
        end > items.length ? items.length : end,
      );
      groupedItems.add(subList);
    }
    return groupedItems;
  }

  static void showToastMessage({
    required String message,
    ToastGravity position = ToastGravity.BOTTOM,
  }) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: position,
        backgroundColor: const Color(0xFF656565),
      );
    }
  }

  static List<String> getUidsFromExpression(String expression) {
    RegExp regExp = RegExp('(#{.*?})');
    List<String> matchedUids = [];
    Iterable<Match> matches = regExp.allMatches(expression);
    for (Match m in matches) {
      matchedUids.add(m[0]!);
    }
    return matchedUids;
  }

  static String getExpressionWithValues(
    String expression,
    List<String> uids,
    Map dataObject,
  ) {
    for (String uid in uids) {
      String value = getValueFromDataObject(uid, dataObject);
      expression = expression.replaceAll(uid, value);
    }
    return expression;
  }

  static String getValueFromDataObject(String uid, Map dataObject) {
    var value = '0';
    dataObject.forEach((dataObjectKey, dataObjectValue) {
      if (uid.contains(dataObjectKey)) {
        value = '$dataObjectValue';
        return;
      }
    });
    return value;
  }

  static bool isEmailValid(String email) {
    return email.isEmpty
        ? true
        : RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
          ).hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.isEmpty
        ? true
        : RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(phoneNumber);
  }
}
