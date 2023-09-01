import 'package:flutter/material.dart';
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './services/navigation_services.dart';
import 'package:provider/provider.dart';
import './providers/authentication_provider.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';
void main() {
  runApp(
    SplashPage(key: UniqueKey(), onInitializationComplete: (){
      runApp(MainApp(),);
    }
    ),
  );
}
class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<AuthenticationProvider> (create:(BuildContext _context){
        return AuthenticationProvider();
      },)
    ],
    child: MaterialApp(
      title: 'Chatify',
      theme: ThemeData( colorScheme: const ColorScheme.dark(
          background: Color.fromRGBO(36, 35, 49, 1.0)
      ),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color.fromRGBO(30, 29, 27, 1.0),
        ),
      ),
      navigatorKey:NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext _context) => LoginPage(),
        '/register': (BuildContext _register)=>RegisterPage(),
        '/home' : (BuildContext _context)=>HomePage(),

      },
    ),);
  }
}

