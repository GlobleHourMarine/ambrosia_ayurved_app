import 'package:ambrosia_ayurved/cosmetics/common/contact_info.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_now_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/new_order_history_ge.dart';
import 'package:ambrosia_ayurved/firebase_options.dart';
import 'package:ambrosia_ayurved/widgets/address/address_model.dart';
import 'package:ambrosia_ayurved/widgets/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/address_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_grandtotal_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_item_total_price_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/ratting_summary.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/payment_details_view/payment_details_provider.dart';
import 'package:ambrosia_ayurved/home/Sign_up.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/common/splash_screen/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
import 'package:ambrosia_ayurved/cosmetics/common/splash_screen/splash_screen.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => PaymentDetailsProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
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

