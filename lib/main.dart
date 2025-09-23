import 'package:ambrosia_ayurved/ambrosia/common/contact_info.dart';
import 'package:ambrosia_ayurved/ambrosia/common/firebase_notification/notification_service.dart';
import 'package:ambrosia_ayurved/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/item_calculations/order_grandtotal_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/item_calculations/order_item_total_price_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/splash_screen/splash_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/product_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();
  final userProvider = UserProvider();
  await userProvider.loadUserFromPrefs();

  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        //   ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider.value(value: languageProvider),
        // ChangeNotifierProvider(create: (context) => TranslationProvider()),
        //  ChangeNotifierProvider(create: (context) => Address()),
        // ChangeNotifierProvider(create: (context) => AwbData()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        //  ChangeNotifierProvider(create: (context) => PaymentProvider()),
        //  ChangeNotifierProvider(create: (context) => PaymentDetailsProvider()),
        // ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => GrandTotalProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => PlaceOrderProvider()),
        ChangeNotifierProvider(create: (context) => ItemTotalPriceProvider()),
        // ChangeNotifierProvider(create: (context) => ReviewProvider()),
        // Add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final currentLocale = languageProvider.selectedLocale;
        if (Get.locale?.languageCode != currentLocale.languageCode) {
          Future.microtask(() => Get.updateLocale(currentLocale));
        }

        return GetMaterialApp(
          supportedLocales: const [
            Locale('en'),
            Locale('ms'),
            Locale('ar'),
            Locale('hi'),
          ],
          locale: currentLocale, // Set from provider
          fallbackLocale:
              const Locale('en'), // Default to English if something goes wrong
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          //
          //
          title: ContactInfo.appName,

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Acolors.primary),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
