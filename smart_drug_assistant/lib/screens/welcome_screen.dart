import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const double _designWidth = 360;
  static const double _buttonDesignWidth = 207;
  static const double _buttonHeight = 45;

  static const double _loginAlignY = 0.70;
  static const double _signupAlignY = 0.83;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double buttonWidth =
        size.width * (_buttonDesignWidth / _designWidth);

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome.png',
              fit: BoxFit.cover,
            ),
          ),

          // LOG IN LoginScreen
          Align(
            alignment: const Alignment(0, _loginAlignY),
            child: _HitAreaButton(
              width: buttonWidth,
              height: _buttonHeight,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),
          ),

          // SIGN UP SignUpScreen
          Align(
            alignment: const Alignment(0, _signupAlignY),
            child: _HitAreaButton(
              width: buttonWidth,
              height: _buttonHeight,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SignUpScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HitAreaButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const _HitAreaButton({
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: onTap,
        ),
      ),
    );
  }
}
