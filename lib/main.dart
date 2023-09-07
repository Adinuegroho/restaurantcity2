import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity2/data/api/api_service.dart';
import 'package:restaurantcity2/provider/detail_provider.dart';
import 'package:restaurantcity2/provider/home_provider.dart';
import 'package:restaurantcity2/provider/search_provider.dart';
import 'package:restaurantcity2/ui/detail_screen.dart';
import 'package:restaurantcity2/ui/home_screen.dart';
import 'package:restaurantcity2/ui/search_screen.dart';
import 'package:restaurantcity2/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    return MultiProvider(providers: [
      ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(apiService: apiService),
      ),
      ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(apiService: apiService),
      ),
      ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(apiService: apiService),
      ),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          DetailScreen.routeName: (context) => DetailScreen(restoId: ModalRoute.of(context)?.settings.arguments as String),
          SearchScreen.routeName: (context) => const SearchScreen(),
        },
      ),
    );
  }
}