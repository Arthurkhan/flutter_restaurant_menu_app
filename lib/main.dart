import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

import 'blocs/theme/theme_bloc.dart';
import 'blocs/menu/menu_bloc.dart';
import 'config/routes.dart';
import 'config/constants.dart';
import 'data/datasources/local_menu_data_source.dart';
import 'data/repositories/menu_repository.dart';

import 'dart:io';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  
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
  
  // Initialize local data source
  final localDataSource = LocalMenuDataSource(
    database: database,
    preferences: sharedPreferences,
  );
  
  // Initialize repository with local data source
  final menuRepository = MenuRepository(localDataSource);
  
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
        child: const MyApp(),
      ),
    ),
  );
}

/// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Restaurant Menu App',
          theme: themeState.appTheme.theme,
          darkTheme: themeState.appTheme.isDark 
              ? themeState.appTheme.theme
              : null,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          
          // Add support for multiple languages
          localizationsDelegates: const [
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

/// BLoC observer for logging events, transitions, and errors
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}