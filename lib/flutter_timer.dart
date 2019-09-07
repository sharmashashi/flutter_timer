library flutter_timer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

typedef TimeCallback = Function(TimerProvider object);

///provider class to manage state
class TimerProvider with ChangeNotifier {
  //attributes
  int currentSeconds = 0, currentMinutes = 0, currentHour = 0;
  DateTime initialDate = DateTime.now();

  ///getters
  get getCurrentSecond => currentSeconds;
  get getCurrentMinute => currentMinutes;
  get getCurrentHour => currentHour;
  get getInitialDate => initialDate;

  ///setters
  set setInitialDate(DateTime date) {
    this.initialDate = date;
    try {
      notifyListeners();
    } on PlatformException {}
  }

  set setCurrentSecond(int second) {
    this.currentSeconds = second;
    notifyListeners();
  }

  set setCurrentMinute(int minute) {
    this.currentMinutes = minute;
    notifyListeners();
  }

  set setCurrentHour(int hour) {
    this.currentHour = hour;
    notifyListeners();
  }

  ///takes duration in second and calculates hour minute second
  Map<String, int> findHMS(int totalSecond) {
    int hour = (totalSecond / 3600).floor();
    int minute = (totalSecond / 60).floor();
    int second = totalSecond - (hour * 3600) - (minute * 60);
    return {'hour': hour, 'minute': minute, 'second': second};
  }
}

//////////////////
///timer widget///
//////////////////

class TikTikTimer extends StatelessWidget {
  ///- callback function that returns TimerObject containing
  ///  getCurrentSecond(), getCurrentMinute() and getCurrentHour()
  ///  methods.
  TimeCallback tracetime;

  ///- background color of timer widget
  final Color backgroundColor;

  ///- height of timer widget
  final double height;

  ///- width of timer widget
  final double width;

  ///- if running is true timer starts with base
  ///  time to initial time. If false timer stops
  final bool running;
  bool isStarted = false;

  ///timer text style
  final TextStyle timerTextStyle;

  ///initial date:
  /// - initial date is base date. When timer starts, it calculates the difference
  ///   between base date and date of running attribute made to true
  final initialDate;

  ///- if set true then shows little shadow
  ///  below the timer widget
  final bool isRaised ;

  ///border radius of widget:
  /// -applies to all four corner border radius
  final double borderRadius;
  TikTikTimer(
      {this.backgroundColor,
        @required this.height,
        @required this.width,
        this.running,
        this.timerTextStyle,
        this.borderRadius,
        @required this.initialDate,
        this.tracetime,this.isRaised=false});

  ///for hour mminute second
  String hour = '00', minute = '00', second = '00';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerProvider>(
      builder: (context) => TimerProvider(),
      child: Builder(builder: (BuildContext context) {
        ///instatiate provider
        var _timerProvider = Provider.of<TimerProvider>(context);
        Future.delayed(Duration(seconds: 0)).then((_) {
          tracetime(_timerProvider);
        });

        ///set initial date at once
        if (isStarted == false && running == true) {
          try {
            _timerProvider.setInitialDate = initialDate;
          } on Exception {}

          isStarted = true;
        }
        if (running == true)
          Future.delayed(Duration(seconds: 0)).then((_) {
            ///to convert the total seconds into hour, minute and second
            ///60 => 1 minute 0 second
            ///3601 => 1 hour 0 minute 1 second
            Map<String, int> time = new Map();
            time = _timerProvider.findHMS(DateTime.now()
                .difference(_timerProvider.getInitialDate)
                .inSeconds);
            try {
              ///update provider with hour, minute and second
              _timerProvider.setCurrentHour = time['hour'];
              _timerProvider.setCurrentMinute = time['minute'];
              _timerProvider.setCurrentSecond = time['second'];
            } on Exception {}
          });
        int tempHour = _timerProvider.getCurrentHour,
            tempMinute = _timerProvider.getCurrentMinute,
            tempSecond = _timerProvider.getCurrentSecond;

        ///adds '0' in front if hour,minute and second are 0,1,2,3,4,5,
        ///6,7,8,9 => 00,01,02,03,.....,09
        tempHour < 10 ? hour = '0$tempHour' : hour = tempHour.toString();
        tempMinute < 10
            ? minute = '0$tempMinute'
            : minute = tempMinute.toString();
        tempSecond < 10
            ? second = '0$tempSecond'
            : second = tempSecond.toString();

        return Container(
          decoration: BoxDecoration(
              boxShadow: isRaised
                  ? [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.5,
                    spreadRadius: 0.3,
                    offset: Offset(1, 1)),

              ]
                  : [],
              color: backgroundColor != null ? backgroundColor : Colors.black,
              borderRadius: BorderRadius.circular(
                  borderRadius != null ? borderRadius : 8)),
          child: Center(
              child: Text('$hour:$minute:$second',
                  style: timerTextStyle != null
                      ? timerTextStyle
                      : new TextStyle(
                      color: Colors.grey[200],
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
          height: height,
          width: width,
        );
      }),
    );
  }
}
