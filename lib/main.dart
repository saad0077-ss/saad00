import 'package:flutter/material.dart';
import 'package:my_portfolio/providers/theme_provider.dart';
import 'package:my_portfolio/screen/home_screen.dart';


void main() {
  runApp(const PortfolioApp());
}

/// Root app widget — owns ThemeProvider and passes it down.
class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();    
}

class _PortfolioAppState extends State<PortfolioApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    // Rebuild the whole app when the theme changes                           
    _themeProvider.addListener(() => setState(() {}));   
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saad — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: _themeProvider.themeData, 
      home: HomeScreen(themeProvider: _themeProvider),
    );
  }
}
