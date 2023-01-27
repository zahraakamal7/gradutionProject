import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flight_booking_sys/services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'constants/constantsVariables.dart';
import 'constants/localization.g.dart';
import 'constants/router.dart';
import 'constants/theme.dart';
import 'controller/scaffoldController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GooglePlayServicesAvailability playStoreAvailability;
  await GetStorage.init();
  try {
    if (!Platform.isIOS)
      playStoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability(false);
    else
      playStoreAvailability = GooglePlayServicesAvailability.values[0];
  } on PlatformException {
    playStoreAvailability = GooglePlayServicesAvailability.unknown;
  }
  if (playStoreAvailability == GooglePlayServicesAvailability.success) {
    await Firebase.initializeApp();
    Firebase.app();
    await Get.putAsync<NotificationService>(NotificationService().init,
        permanent: true);
  }

  // GetStorage().erase();
  Intl.defaultLocale = 'ar';
  setLocaleMessages("ar", ArMessages());
  setLocaleMessages("en", EnMessages());
  Get.updateLocale(Locale(GetStorage().read<String>('locale') ?? 'ar'));
  initializeDateFormatting();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final isPlatformDark = storage.read<bool>("dark") ?? false;
    final initTheme = isPlatformDark ? Themes.dark : Themes.light;
    return ThemeProvider(
      initTheme: initTheme,
      builder: (_, theme) => GetMaterialApp(
        locale: Get.locale,
        translations: Localization(),
        routingCallback: (routing) {
          if (routing!.route != null && !routing.isBack!) {
            if (ScaffoldController.controller.firstRoute.value == "")
              ScaffoldController.controller.firstRoute.value = routing.current;
            if (Get.isRegistered<ScaffoldController>())
              ScaffoldController.controller.currentRoute.value =
                  routing.current;
          } else if (routing.route != null) {
            ScaffoldController.controller.currentRoute.value = routing.current;
          }
        },
        title: 'madrsa',
        debugShowCheckedModeBanner: false,
        getPages: Routers.route,
        // themeMode: ThemeService().theme,
        // darkTheme: Themes.dark,
        theme: theme,
        initialRoute: SpalshRoute,
        builder: (context, child) {
          return ThemeSwitchingArea(child: child!);
        },
      ),
    );
  }
}
