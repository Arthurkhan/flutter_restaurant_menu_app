import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'blocs/theme/theme_bloc.dart';
import 'blocs/menu/menu_bloc.dart';
import 'config/routes.dart';
import 'config/constants.dart';
import 'data/datasources/local_menu_data_source.dart';
import 'data/datasources/remote_menu_data_source.dart';
import 'data/repositories/menu_repository.dart';
import 'presentation/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() async {

   if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }

  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize database
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'restaurant_menu.db');
  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE menus ('
        'id TEXT PRIMARY KEY, '
        'data TEXT, '
        'timestamp INTEGER'
        ')',
      );
    },
  );
  
  // Initialize data sources
  final remoteDataSource = RemoteMenuDataSource(
    client: http.Client(),
    baseUrl: AppConstants.apiBaseUrl,
  );
  
  final localDataSource = LocalMenuDataSource(
    database: database,
    preferences: sharedPreferences,
  );
  
  // Initialize repositories
  final menuRepository = MenuRepository(remoteDataSource, localDataSource);
  
  // Run the app
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MenuRepository>(
          create: (context) => menuRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(sharedPreferences)..add(ThemeLoaded()),
          ),
          BlocProvider<MenuBloc>(
            create: (context) => MenuBloc(menuRepository),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
    WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Restaurant Menu App',
          theme: themeState.appTheme.theme,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          
          // Add support for multiple languages
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            for (final locale in AppConstants.supportedLocales)
              Locale(locale),
          ],
        );
      },
    );
  }
}
