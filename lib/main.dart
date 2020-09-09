import 'package:flutter/material.dart';
import 'package:flutter_splash/flutter_splash.dart';
import 'package:provider/provider.dart';
import 'package:waytech/providers/PathProvider.dart';
import 'package:waytech/providers/StationProvider.dart';
import 'package:waytech/screens/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StationProvider>.value(value: StationProvider()),
        ChangeNotifierProvider<PathProvider>.value(value: PathProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ))),
        home: Splash(
          navigateAfterFuture: loadInitialPage,
          loadingText: Text("Powered by  WayTech"),
          image: new Image.asset('lib/assets/splash_icon.png'),
          backgroundColor: Colors.white,
          photoSize: 120.0,
          loaderColor: Colors.blue,
        ),
      ),
    );
  }

  Future<dynamic> loadInitialPage() {
    return Future.delayed(
      Duration(seconds: 2),
      () => TabScreen()
    );
  }
}