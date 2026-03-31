import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/controller/home_controller.dart';
import 'package:submission/provider/food_classification_provider.dart';
import 'package:submission/service/food_classification_service.dart';
import 'package:submission/style/main_theme.dart';
import 'package:submission/ui/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => FoodClassificationService()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(
          create:
              (context) => FoodClassificationProvider(
                context.read<FoodClassificationService>(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MainTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
