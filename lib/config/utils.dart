// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);
// final kEvents2 = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// );

final _kEventSource = Map.fromIterable(
  List.generate(50, (index) => index),
  key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
  value: (item) => List.generate(
    item % 4 + 1,
    (index) => Event('Event $item | ${index + 1}'),
  ),
)..addAll(
    {
      kToday: [
        const Event('Today\'s Event 1'),
        const Event('Today\'s Event 2'),
      ],
    },
  );

// final _kEventSource2 = getCruiseCallAPI();

// Future<List> getCruiseCallAPI() async {
Future<Map<DateTime, List<Event>>> getCruiseCallAPI() async {
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String end = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 10)));

  String key = '';

  // String url =
  //     'https://api.portcall.info/Traffic?date=$date&portRegion=Honolulu - Oahu';
  String url =
      'https://api.portcall.info/CruiseCalls?startDate=$date&endDate=$end';

  var response = await http.get(
    Uri.parse(url),
    headers: {
      'ApiKey': key,
    },
  );
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    // print(json);
    var results = json['data'] as List;
    print(_kEventSource);
    var eventDate = '';

    for (var pc in results) {
      pc
        ..remove('portCallId')
        ..remove('portCallLink')
        ..remove('vesselId')
        ..remove('operator')
        ..remove('agency')
        ..remove('port')
        ..remove('berthDateTimeEst')
        ..remove('departureDateTimeEst')
        ..remove('hasArrived')
        ..remove('hasDeparted')
        ..remove('imo')
        ..remove('photoUrl')
        ..remove('shipLengthM')
        ..remove('shipLengthFT')
        ..remove('shipType')
        ..remove('isCruise')
        ..remove('flag')
        ..remove('status')
        ..remove('berthDateTimeAct')
        ..remove('departureDateTimeAct')
        ..remove('guests')
        ..remove('fleetMonVesselId');

      eventDate = pc['arrivalDateTime'];
      pc['eventDate'] =
          DateTime.parse('${eventDate.substring(0, 10)} 00:00:00.000Z');
    }

    var resultsMap = groupBy(results, (pc) => pc['eventDate']);

    Map<DateTime, List<Event>> convertedResults = {};
    for (var events in resultsMap.keys) {
      // print(resultsMap.keys); // list of datetimes
      // print(resultsMap[events]); // content in array, i.e. key & value
      if (resultsMap[events] != null) {
        List<Event> vessels = [];
        for (var pc in resultsMap[events]!) {
          // print(pc['vessel']);
          pc
            ..remove('eventDate')
            ..remove('arrivalDateTime')
            ..remove('berth');

          vessels.add(Event(pc['vessel']));
        }
        convertedResults[events] = vessels;
      }
    }

    print(convertedResults);
    // return results;
    return convertedResults;
  } else {
    print('error');
    throw Exception();
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
