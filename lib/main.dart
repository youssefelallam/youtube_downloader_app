import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_download/controller/data_provider.dart';
import 'package:youtube_download/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        home: const Home(),
      ),
    );
  }
}
