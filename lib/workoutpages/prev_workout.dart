// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gymbro/workoutpages/start_workout.dart';

// class PrevWorkout extends StatelessWidget {
//   final List<ChartData> data = [
//     ChartData(DateTime(2023, 5, 1), 2000),
//     ChartData(DateTime(2023, 5, 7), 2200),
//     ChartData(DateTime(2023, 5, 14), 2400),
//     ChartData(DateTime(2023, 5, 21), 2800),
//     ChartData(DateTime(2023, 5, 28), 2550),
//     ChartData(DateTime(2023, 6, 5), 2700),
//     ChartData(DateTime(2023, 6, 12), 2750),
//   ];
//   final List<dynamic> routine;
//   PrevWorkout({required this.routine});
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My WorkOut'),
//         // subtitle: Text('Total Volume'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 300,
//               child: charts.TimeSeriesChart(
//                 _createSeriesData(),
//                 animate: true,
//                 dateTimeFactory: const charts.LocalDateTimeFactory(),
//               ),
//             ),
//             Divider(),
//             Row(
//               children: [
//                 Container(
//                   child: Text("Exercises"),
//                   alignment: Alignment.topLeft,
//                 ),
//                 VerticalDivider(
//                   width: ScreenUtil.defaultSize.width - 106,
//                 ),
//                 Container(
//                   alignment: Alignment.topRight,
//                   child: TextButton(
//                     child: Text(
//                       'Edit',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//             Card(
//               elevation: 10,
//               child: ListTile(
//                 title: Text(
//                   routine[0],
//                   style: TextStyle(fontSize: 20),
//                 ), // Routine name
//                 subtitle: Text('${routine.sublist(1).join(', ')}'),
//                 onTap: () {
//                 },
//                 leading: TextButton(
//                   child: Text(
//                     "Start",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => StartWorkoutPage(
//                           routineItems: routine[1],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<charts.Series<ChartData, DateTime>> _createSeriesData() {
//     return [
//       charts.Series<ChartData, DateTime>(
//         id: 'Volume',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (ChartData data, _) => data.date,
//         measureFn: (ChartData data, _) => data.volume,
//         data: data,
//       ),
//     ];
//   }
// }

// class ChartData {
//   final DateTime date;
//   final int volume;

//   ChartData(this.date, this.volume);
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'package:intl/intl.dart';

class PrevWorkout extends StatelessWidget {
  final List<ChartData> data = [
    ChartData(DateTime(2023, 5, 1), 2000),
    ChartData(DateTime(2023, 5, 7), 2200),
    ChartData(DateTime(2023, 5, 14), 2400),
    ChartData(DateTime(2023, 5, 21), 2800),
    ChartData(DateTime(2023, 5, 28), 2550),
    // ChartData(DateTime(2023, 6, 5), 2700),
    // ChartData(DateTime(2023, 6, 12), 3000),
    // ChartData(DateTime(2023, 6, 28), 3425),
    // ChartData(DateTime(2023, 7, 5), 3700),
    // ChartData(DateTime(2023, 7, 12), 4000),
  ];

  String formatWeek(DateTime date) {
    return 'Week ${DateFormat('w').format(date)}';
  }

  final List<dynamic> routine;
  final List<dynamic> glifsList;
  PrevWorkout({required this.routine, required this.glifsList});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('My Workout',
                      style:
                          TextStyle(fontFamily: GoogleFonts.asap().fontFamily)),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Divider(),
              Row(
                children: [
                  Container(
                    child: Text(
                      "Exercises",
                      style:
                          TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  VerticalDivider(
                    width: ScreenUtil.defaultSize.width - 106,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.asap().fontFamily),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 10,
                child: ListTile(
                  title: Text(
                    routine[0],
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ), // Routine name
                  subtitle: Text(
                    '${routine[1].join(',')}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: GoogleFonts.asap().fontFamily,
                        fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartWorkoutPage(
                          routineItems: routine[1],
                          rotName: routine[0],
                          gifsList: glifsList,
                          isEmptyWorkout: false,
                        ),
                      ),
                    );
                  },
                  leading: TextButton(
                    child: Text(
                      "Start",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.asap().fontFamily),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartWorkoutPage(
                            routineItems: routine[1],
                            rotName: routine[0],
                            gifsList: glifsList,
                            isEmptyWorkout: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // chartWidget(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox chartWidget() {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          minX: data.first.date.millisecondsSinceEpoch.toDouble(),
          maxX: data.last.date.millisecondsSinceEpoch.toDouble(),
          minY: 0,
          maxY: _getMaxVolume(),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              // interval: 1,

              // showTitles: true,
              reservedSize: 22,
              getTextStyles: (context, value) => TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: GoogleFonts.asap().fontFamily),
              margin: 8,
              getTitles: (value) {
                DateTime dateTime =
                    DateTime.fromMicrosecondsSinceEpoch(value.toInt());
                return '${dateTime.month}';
              },
            ),
            leftTitles: SideTitles(
              interval: 1000,
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: GoogleFonts.asap().fontFamily),
              getTitles: (value) {
                return value.toInt().toString();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartDataSpots(),
              isCurved: true,
              colors: [Colors.blue, Colors.green],
              barWidth: 3,
              dotData: FlDotData(
                // show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: Colors.blue,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.green.withOpacity(0.6)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getChartDataSpots() {
    return data.map((chartData) {
      return FlSpot(
        chartData.date.millisecondsSinceEpoch.toDouble(),
        chartData.volume.toDouble(),
      );
    }).toList();
  }

  double _getMaxVolume() {
    return data
        .map((chartData) => chartData.volume)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
  }
}

class ChartData {
  final DateTime date;
  final int volume;

  ChartData(this.date, this.volume);
}
