# flutter_timer

A flutter timer that shows time duration from initial time.

# Screenshot

  ![Alt text](screenshots/timer.gif?raw=true "")

# Example
```dart
        import 'package:flutter/material.dart';
        import 'package:flutter_timer/flutter_timer.dart';
        class TimerPage extends StatefulWidget {
          @override
          _TimerPageState createState() => _TimerPageState();
        }

        class _TimerPageState extends State<TimerPage> {
          bool running = false;
          @override
          Widget build(BuildContext context) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TikTikTimer(
                      initialDate: DateTime.now(),
                      running: running,
                      height: 150,
                      width: 150,
                      backgroundColor: Colors.indigo,
                      timerTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                      borderRadius: 100,
                      isRaised: true,
                      tracetime: (time) {
                        // print(time.getCurrentSecond);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            try {
                              if (running == false)
                                setState(() {
                                  running = true;
                                });
                            } on Exception {}
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            'Stop',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          onPressed: () {
                            if (running == true)
                              setState(() {
                                running = false;
                              });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
