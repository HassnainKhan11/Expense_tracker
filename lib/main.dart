import 'package:flutter/material.dart';
import 'package:flutter_hive_app/provider/theme_provider.dart';
import 'package:flutter_hive_app/provider/transaction_provider.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:flutter_hive_app/home_page.dart';
import 'package:flutter_hive_app/model/transaction_model.dart';
import 'package:provider/provider.dart';

void main() async {
  //necessay steps to initiliazed hive in your app
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //initialaizing generated adapter class in your app
  Hive.registerAdapter(TransactionAdapter());

  //creating and naming your hive box
  await Hive.openBox<Transaction>('transactions');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'Hive Expense Tracker';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => TransactionProvider())),
          ChangeNotifierProvider(create: ((context) => ThemeProvider())),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            title: title,
            home: const HomePage(),
          );
        });
  }
}
