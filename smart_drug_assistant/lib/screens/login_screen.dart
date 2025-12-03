import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const double _designWidth = 360;
  static const double _fieldDesignWidth = 299;
  static const double _buttonDesignWidth = 207;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double fieldWidth =
        size.width * (_fieldDesignWidth / _designWidth);
    final double buttonWidth =
        size.width * (_buttonDesignWidth / _designWidth);

    return Scaffold(
      body: Stack(
        children: [
          // ARKA PLAN
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // GERİ BUTONU
          Align(
            alignment: const Alignment(-0.88, -0.87),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),

          // ÜSTTEKİ INPUTLAR VE LOG IN BUTONU
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 190),

                  // EMAIL FIELD
                  SizedBox(
                    width: fieldWidth,
                    child: const PeachField(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(height: 54),

                  // PASSWORD FIELD
                  SizedBox(
                    width: fieldWidth,
                    child: const PeachField(
                      hintText: 'Password',
                      obscureText: true,
                      showEye: true,
                    ),
                  ),

                  const SizedBox(height: 80),

                  // LOG IN BUTTON
                  SizedBox(
                    width: buttonWidth,
                    child: PeachButton(
                      label: 'Log In',
                      onTap: () {
                        debugPrint('Log In tapped');
                      },
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // "Sign Up" YAZISININ ÜZERİNE ŞEFFAF BUTON
          Align(
            alignment: const Alignment(0.39, 0.50),
            child: SizedBox(
              width: 50,
              height: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///  INPUT WIDGET
class PeachField extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showEye;

  const PeachField({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.showEye = false,
  });

  @override
  State<PeachField> createState() => _PeachFieldState();
}

class _PeachFieldState extends State<PeachField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/field_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          TextField(
            keyboardType: widget.keyboardType,
            obscureText: _obscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: widget.showEye
                  ? IconButton(
                splashRadius: 18,
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 18,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

///  BUTON WIDGET
class PeachButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PeachButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_btn_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(45 / 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(45 / 2),
              onTap: onTap,
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
