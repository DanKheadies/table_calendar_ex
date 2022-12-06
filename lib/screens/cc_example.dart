// import 'dart:collection';
// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/date_symbol_data_local.dart';

// class Event {
//   final String title;
//   final int id;
//   final String berth;
//   final String arrival;
//   final String imageUrl;

//   const Event({
//     required this.title,
//     required this.id,
//     required this.berth,
//     required this.arrival,
//     required this.imageUrl,
//   });

//   @override
//   String toString() => title;
// }

// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

// /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount,
//     (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }

// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

// class TableMultiExample extends StatefulWidget {
//   const TableMultiExample({
//     Key? key,
//     this.width,
//     this.height,
//     this.events,
//   }) : super(key: key);

//   final double? width;
//   final double? height;
//   final List<dynamic>? events;

//   @override
//   State<TableMultiExample> createState() => _TableMultiExampleState();
// }

// class _TableMultiExampleState extends State<TableMultiExample> {
//   late final ValueNotifier<List<Event>> _selectedEvents;

//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;

//   final kEvents = LinkedHashMap<DateTime, List<Event>>(
//     equals: isSameDay,
//     hashCode: getHashCode,
//   );

//   @override
//   initState() {
//     super.initState();

//     kEvents.addAll(getAllEvents());

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   Map<DateTime, List<Event>> getAllEvents() {
//     var results = widget.events as List;
//     var eventDate = '';

//     for (var pc in results) {
//       pc
//         // ..remove('portCallId')
//         ..remove('portCallLink')
//         ..remove('vesselId')
//         ..remove('operator')
//         ..remove('agency')
//         ..remove('port')
//         ..remove('berthDateTimeEst')
//         ..remove('departureDateTimeEst')
//         ..remove('hasArrived')
//         ..remove('hasDeparted')
//         ..remove('imo')
//         // ..remove('photoUrl')
//         ..remove('shipLengthM')
//         ..remove('shipLengthFT')
//         ..remove('shipType')
//         ..remove('isCruise')
//         ..remove('flag')
//         ..remove('status')
//         ..remove('berthDateTimeAct')
//         ..remove('departureDateTimeAct')
//         ..remove('guests')
//         ..remove('fleetMonVesselId');

//       eventDate = pc['arrivalDateTime'];
//       pc['eventDate'] =
//           DateTime.parse('${eventDate.substring(0, 10)} 00:00:00.000Z');
//     }

//     var resultsMap = groupBy(results, (dynamic pc) {
//       if (pc != null) {
//         return pc['eventDate'];
//       } else {
//         return {};
//       }
//     });

//     Map<DateTime, List<Event>> convertedResults = {};
//     for (var events in resultsMap.keys) {
//       if (resultsMap[events] != null) {
//         List<Event> vessels = [];
//         for (var pc in resultsMap[events]!) {
//           pc
//             .remove('eventDate');
//             // ..remove('arrivalDateTime')
//             // ..remove('berth');

//           vessels.add(
//             Event(
//               title: pc['vessel'],
//               id: pc['portCallId'],
//               berth: pc['berth'],
//               arrival: pc['arrivalDateTime'],
//               imageUrl: pc['photoUrl'],
//             ),
//           );
//         }
//         convertedResults[events] = vessels;
//       }
//     }

//     return convertedResults;
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     // Implementation example
//     return kEvents[day] ?? [];
//   }

//   List<Event> _getEventsForRange(DateTime start, DateTime end) {
//     // Implementation example
//     final days = daysInRange(start, end);

//     return [
//       for (final d in days) ..._getEventsForDay(d),
//     ];
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });

//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });

//     // `start` or `end` could be null
//     if (start != null && end != null) {
//       _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _getEventsForDay(end);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('60 Day of Cruises'),
//       ),
//       body: Column(
//         children: [
//           TableCalendar<Event>(
//             firstDay: kFirstDay,
//             lastDay: kLastDay,
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             rangeStartDay: _rangeStart,
//             rangeEndDay: _rangeEnd,
//             calendarFormat: _calendarFormat,
//             rangeSelectionMode: _rangeSelectionMode,
//             eventLoader: _getEventsForDay,
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             calendarStyle: CalendarStyle(
//               // Use `CalendarStyle` to customize the UI
//               outsideDaysVisible: false,
//             ),
//             onDaySelected: _onDaySelected,
//             onRangeSelected: _onRangeSelected,
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//           ),
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: ValueListenableBuilder<List<Event>>(
//               valueListenable: _selectedEvents,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: ListTile(
//                         onTap: () {
//                           // print(value[index].id);
//                           ScaffoldMessenger.of(context)
//                             ..removeCurrentSnackBar()
//                             ..showSnackBar(
//                               SnackBar(
//                                 content: Text('portCallId: ${value[index].id}'),
//                               ),
//                             );
//                         },
//                         title: Text(value[index].title),
//                         subtitle: Text('${value[index].berth} @ ${value[index].arrival.substring(10)}'),
//                         leading: Image(
//                           image: NetworkImage(value[index].imageUrl),
                          
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }