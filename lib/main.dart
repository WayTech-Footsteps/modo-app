import 'package:flutter/material.dart';
import 'package:flutter_splash/flutter_splash.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/JourneyInfoProvider.dart';
import 'package:waytech/providers/LocationProvider.dart';
import 'package:waytech/providers/POIProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/providers/TimeEntryProvider.dart';
import 'package:waytech/screens/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Color _color = const Color(0xFFffb400);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StationProvider>.value(value: StationProvider()),
        ChangeNotifierProvider<TimeEntryProvider>.value(
            value: TimeEntryProvider()),
        ChangeNotifierProvider<LocationProvider>.value(
            value: LocationProvider()),
        ChangeNotifierProvider<POIProvider>.value(value: POIProvider()),
        ChangeNotifierProvider<JourneyInfoProvider>.value(value: JourneyInfoProvider()),
      ],
      child: MaterialApp(
        title: 'Modo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: _color,
            accentColor: _color,
            scaffoldBackgroundColor: Colors.black45,
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              dayPeriodColor: _color,
              dialHandColor: _color,
              hourMinuteTextColor: const Color(0xFFffb400),
              hourMinuteColor: const Color(0xFFffb400).withAlpha(30),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ))),
        home: Splash(
          navigateAfterFuture: loadInitialPage,
          loadingText: Text(
            "Powered by WayTech",
            style: TextStyle(color: _color),
          ),
          image: new Image.asset('lib/assets/LogoMakr_5kyBYK.png'),
          backgroundColor: Colors.white10,
          photoSize: 120.0,
          loaderColor: _color,
        ),
      ),
    );
  }

  Future<dynamic> loadInitialPage() {
    return Future.delayed(Duration(seconds: 2), () => TabScreen());
  }
}
