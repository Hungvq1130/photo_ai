import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_ai/route_observer.dart';
import 'package:photo_ai/splashScreen.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker_android/image_picker_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        Locale('fr'),
        Locale('es'),
        Locale('de'),
        Locale('ja'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const SplashScreen(),
    );
  }
}
