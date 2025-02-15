import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'landing_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LandingPage())
      );
    });
  }
//-----------------------------------------------------------------------------
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange,Colors.deepOrange],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/splashNoBG.png"),
            SizedBox(height: MediaQuery.of(context).size.width*0.05),
          ],
        ),
      ),
    );
  }
}