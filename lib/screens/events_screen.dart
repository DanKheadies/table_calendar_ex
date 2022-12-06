// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:table_calendar_ex/config/config.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // late final ValueNotifier<List<Event>> _selectedEvents;
  late final ValueNotifier<List<Event2>> _selectedEvents2;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    getCruiseCallAPI();
    // kEvents.addAll(kEventSource);
    // kEvents.addAll(derp);
    kEvents2.addAll(derp2);
    print('daco');
    print(derp2);
    // print(kEventSource);

    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _selectedEvents2 = ValueNotifier(_getEvents2ForDay(_selectedDay!));
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();
    _selectedEvents2.dispose();
    super.dispose();
  }

  // var kEvents = LinkedHashMap<DateTime, List<Event>>(
  //   equals: isSameDay,
  //   hashCode: getHashCode,
  // );
  // )..addAll(
  //     Map.fromIterable(
  //       List.generate(50, (index) => index),
  //       key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
  //       value: (item) => List.generate(
  //         item % 4 + 1,
  //         (index) => Event('Event $item | ${index + 1}'),
  //       ),
  //     )..addAll(
  //         {
  //           kToday: [
  //             const Event('Today\'s Event 1'),
  //             const Event('Today\'s Event 2'),
  //           ],
  //         },
  //       ),
  //   );

  // List<Event> _getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return kEvents[day] ?? [];
  // }

  List<Event2> _getEvents2ForDay(DateTime day) {
    // Implementation example
    return kEvents2[day] ?? [];
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  List<Event2> _getEvents2ForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEvents2ForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
      _selectedEvents2.value = _getEvents2ForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      // _selectedEvents.value = _getEventsForRange(start, end);
      _selectedEvents2.value = _getEvents2ForRange(start, end);
    } else if (start != null) {
      // _selectedEvents.value = _getEventsForDay(start);
      _selectedEvents2.value = _getEvents2ForDay(start);
    } else if (end != null) {
      // _selectedEvents.value = _getEventsForDay(end);
      _selectedEvents2.value = _getEvents2ForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          // TableCalendar<Event>(
          //   firstDay: kFirstDay,
          //   lastDay: kLastDay,
          //   focusedDay: _focusedDay,
          //   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          //   rangeStartDay: _rangeStart,
          //   rangeEndDay: _rangeEnd,
          //   calendarFormat: _calendarFormat,
          //   rangeSelectionMode: _rangeSelectionMode,
          //   eventLoader: _getEventsForDay,
          //   startingDayOfWeek: StartingDayOfWeek.monday,
          //   calendarStyle: CalendarStyle(
          //     // Use `CalendarStyle` to customize the UI
          //     outsideDaysVisible: false,
          //   ),
          //   onDaySelected: _onDaySelected,
          //   onRangeSelected: _onRangeSelected,
          //   onFormatChanged: (format) {
          //     if (_calendarFormat != format) {
          //       setState(() {
          //         _calendarFormat = format;
          //       });
          //     }
          //   },
          //   onPageChanged: (focusedDay) {
          //     _focusedDay = focusedDay;
          //   },
          // ),
          TableCalendar<Event2>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEvents2ForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //     valueListenable: _selectedEvents,
          //     builder: (context, value, _) {
          //       return ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: const EdgeInsets.symmetric(
          //               horizontal: 12.0,
          //               vertical: 4.0,
          //             ),
          //             decoration: BoxDecoration(
          //               border: Border.all(),
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //             child: ListTile(
          //               onTap: () => print('${value[index]}'),
          //               title: Text('${value[index]}'),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: ValueListenableBuilder<List<Event2>>(
              valueListenable: _selectedEvents2,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index].id}'),
                        title: Text(value[index].title),
                        subtitle: const Text('Berth 1 @ 08:00'),
                        leading: const Image(
                          image: NetworkImage(
                              'https://www.travelandleisure.com/thmb/PIrrNVmeeMvIhVqmFR2EWCrSug4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/rc-wonder-of-the-seas-sunset-aerial-LRGSTSHIP0422-8230b27121c3438b9984b9dc63877937.jpg'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
