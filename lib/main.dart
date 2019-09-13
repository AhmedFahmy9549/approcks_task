import 'package:approcks_task/screens/home.dart';
import 'package:approcks_task/services/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => ConnectivityChecker()),
      ],
      child: Consumer<ConnectivityChecker>(
        builder: (context, connectivityState, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.brown,

            ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
