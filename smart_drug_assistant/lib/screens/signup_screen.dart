import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const double _designWidth = 360;
  static const double _fieldDesignWidth = 299;
  static const double _buttonDesignWidth = 207;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    if (fullName.isEmpty || password.isEmpty || email.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage = 'Please enter a valid email';
      });
      return;
    }

    // Password length check
    if (password.length < 4) {
      setState(() {
        _errorMessage = 'Password must be at least 4 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.signup(
      email: email,
      password: password,
      fullName: fullName,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      // Show success message and navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please login.'),
          backgroundColor: Color(0xFFE29A66),
        ),
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE29A66),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: const Color(0xFFFFF4EC),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _dobController.text = '$day/$month/$year';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double fieldWidth = size.width * (_fieldDesignWidth / _designWidth);
    final double buttonWidth = size.width * (_buttonDesignWidth / _designWidth);

    return Scaffold(
      body: Stack(
        children: [
          // ARKA PLAN
          Positioned.fill(
            child: Image.asset(
              'assets/images/signup_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.88, -0.99),
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

                // FULL NAME kutusu
                Align(
                  alignment: const Alignment(0, -0.77),
                  child: SizedBox(
                    width: fieldWidth,
                    child: _SignUpField(
                      hintText: 'Full name',
                      controller: _fullNameController,
                    ),
                  ),
                ),

                // PASSWORD kutusu
                Align(
                  alignment: const Alignment(0, -0.50),
                  child: SizedBox(
                    width: fieldWidth,
                    child: _SignUpField(
                      hintText: 'Password',
                      obscureText: true,
                      showEye: true,
                      controller: _passwordController,
                    ),
                  ),
                ),

                // EMAIL kutusu
                Align(
                  alignment: const Alignment(0, -0.24),
                  child: SizedBox(
                    width: fieldWidth,
                    child: _SignUpField(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                  ),
                ),

                // MOBILE NUMBER kutusu
                Align(
                  alignment: const Alignment(0, 0.03),
                  child: SizedBox(
                    width: fieldWidth,
                    child: _SignUpField(
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                    ),
                  ),
                ),

                // DATE OF BIRTH kutusu DATE PICKER
                Align(
                  alignment: const Alignment(0, 0.30),
                  child: SizedBox(
                    width: fieldWidth,
                    child: _SignUpField(
                      hintText: 'Date Of Birth',
                      isDateField: true,
                      controller: _dobController,
                      onDateTap: () => _pickDate(context),
                    ),
                  ),
                ),

                // Error message
                if (_errorMessage != null)
                  Align(
                    alignment: const Alignment(0, 0.45),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // SIGN UP butonu
                Align(
                  alignment: const Alignment(0, 0.60),
                  child: SizedBox(
                    width: buttonWidth,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFE29A66),
                            ),
                          )
                        : _SignUpButton(label: 'Sign Up', onTap: _handleSignup),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// field_bg.png + TextField
class _SignUpField extends StatefulWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showEye;
  final bool isDateField;
  final TextEditingController? controller;
  final VoidCallback? onDateTap;

  const _SignUpField({
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.showEye = false,
    this.isDateField = false,
    this.controller,
    this.onDateTap,
  });

  @override
  State<_SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends State<_SignUpField> {
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
            child: Image.asset('assets/images/field_bg.png', fit: BoxFit.fill),
          ),
          TextField(
            controller: widget.controller,
            keyboardType: widget.isDateField
                ? TextInputType.none
                : widget.keyboardType,
            readOnly: widget.isDateField,
            onTap: widget.isDateField ? widget.onDateTap : null,
            obscureText: _obscure && !widget.isDateField,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: widget.showEye && !widget.isDateField
                  ? IconButton(
                      splashRadius: 18,
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
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
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

/// login_btn_bg.png + "Sign Up"  buton
class _SignUpButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SignUpButton({required this.label, required this.onTap});

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
            borderRadius: BorderRadius.circular(22.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(22.5),
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
