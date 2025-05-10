import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MrVapeApp());
}

class MrVapeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr.Vape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.amber,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smoking_rooms, size: 100, color: Colors.amber),
            SizedBox(height: 30),
            Text(
              'جار التحميل... انتظر عزيزي الفيبر',
              style: TextStyle(color: Colors.amber, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _webViewController;
  int _selectedIndex = 2;

  final List<String> _urls = [
    'https://zeusye.com/pos',
    'https://zeusye.com/language_switch/ar',
    'https://zeusye.com/dashboard',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _webViewController.loadRequest(Uri.parse(_urls[index]));
  }

  Future<bool> _onWillPop() async {
    bool exit = false;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('خروج من التطبيق؟', style: TextStyle(color: Colors.white)),
        content: Text('هل تريد الخروج من التطبيق؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              exit = false;
              Navigator.of(context).pop();
            },
            child: Text('لا'),
          ),
          TextButton(
            onPressed: () {
              exit = true;
              Navigator.of(context).pop();
            },
            child: Text('نعم'),
          ),
        ],
      ),
    );
    if (exit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('شكراً لاستخدام تطبيق Mr.Vape – برمجة K4D'),
      ));
      await Future.delayed(Duration(seconds: 2));
      exitApp();
    }
    return false;
  }

  void exitApp() {
    if (Platform.isAndroid) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: WebView(
            initialUrl: _urls[_selectedIndex],
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.setUserAgent(
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white70,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'POS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: 'AR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
          ],
        ),
      ),
    );
  }
}
