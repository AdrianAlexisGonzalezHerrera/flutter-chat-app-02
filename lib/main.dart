import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cchat_app/routes/routes.dart';
import 'package:cchat_app/services/custom_services.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => AuthService() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        // initialRoute: 'login',
        // initialRoute: 'usuarios',
        // initialRoute: 'chat',
        routes: appRoutes,
      ),
    );
  }
}