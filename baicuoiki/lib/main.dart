import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baicuoiki/layout.dart';
import 'package:baicuoiki/providers/cart_provider.dart';
import 'package:baicuoiki/login/Cart.dart';
import 'package:baicuoiki/login/fontlogin.dart';
import 'login/PageRegister.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Starting app...');
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Error during startup: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return SignInPage();
          }
        ),
        routes: {
          '/cart': (context) => const ShoppingCartPage(),
          '/login': (context) => SignInPage(),
          '/register': (context) => const PageRegister(),
          '/Layout': (context) => const Layout(),
        },
      ),
    );
  }
}
