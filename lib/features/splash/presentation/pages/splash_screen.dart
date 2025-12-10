import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../home/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutCubic,
      ),
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOutBack,
      ),
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleController.forward();
    _rotationController.forward();

    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E3C72),
              Theme.of(context).primaryColor,
              const Color(0xFF2A5298),
            ],
          ),
        ),
        child: Stack(
          children: [
            ...List.generate(15, (index) {
              return AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final angle = (index * 2 * math.pi / 15) +
                      (_particleController.value * 2 * math.pi);
                  final radius = 100.0 + (index * 15.0);
                  final left =
                      (screenWidth / 2) + (math.cos(angle) * radius) - 15;
                  final top =
                      (screenHeight / 2) + (math.sin(angle) * radius) - 15;

                  return Positioned(
                    left: left,
                    top: top,
                    child: Opacity(
                      opacity: (0.2 +
                              (math.sin(
                                      _particleController.value * 2 * math.pi +
                                          index) *
                                  0.15))
                          .clamp(0.0, 1.0),
                      child: Icon(
                        [
                          Icons.wb_sunny_outlined,
                          Icons.cloud_outlined,
                          Icons.water_drop_outlined
                        ][index % 3],
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            }),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.wb_sunny,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _scaleAnimation.value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - _scaleAnimation.value)),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [Colors.white, Colors.white70],
                                ).createShader(bounds),
                                child: const Text(
                                  'Weather',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const Text(
                                'F O R E C A S T',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                  letterSpacing: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: (_scaleAnimation.value * 0.8).clamp(0.0, 1.0),
                        child: const Text(
                          'Real-time weather insights',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 +
                            (math.sin(_particleController.value * 2 * math.pi) *
                                0.1),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
