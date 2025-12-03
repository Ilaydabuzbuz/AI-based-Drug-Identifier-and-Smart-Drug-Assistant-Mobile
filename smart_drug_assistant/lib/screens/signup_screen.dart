import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                    child: const _SignUpField(
                      hintText: 'Full name',
                    ),
                  ),
                ),

                // PASSWORD kutusu
                Align(
                  alignment: const Alignment(0, -0.50),
                  child: SizedBox(
                    width: fieldWidth,
                    child: const _SignUpField(
                      hintText: 'Password',
                      obscureText: true,
                      showEye: true,
                    ),
                  ),
                ),

                // EMAIL kutusu
                Align(
                  alignment: const Alignment(0, -0.24),
                  child: SizedBox(
                    width: fieldWidth,
                    child: const _SignUpField(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),

                // MOBILE NUMBER kutusu
                Align(
                  alignment: const Alignment(0, 0.03),
                  child: SizedBox(
                    width: fieldWidth,
                    child: const _SignUpField(
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),

                // DATE OF BIRTH kutusu DATE PICKER
                Align(
                  alignment: const Alignment(0, 0.30),
                  child: SizedBox(
                    width: fieldWidth,
                    child: const _SignUpField(
                      hintText: 'Date Of Birth',
                      isDateField: true,
                    ),
                  ),
                ),

                // SIGN UP butonu
                Align(
                  alignment: const Alignment(0, 0.60),
                  child: SizedBox(
                    width: buttonWidth,
                    child: _SignUpButton(
                      label: 'Sign Up',
                      onTap: () {
                        debugPrint('Sign Up tapped');
                      },
                    ),
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

  const _SignUpField({
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.showEye = false,
    this.isDateField = false,
  });

  @override
  State<_SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends State<_SignUpField> {
  late bool _obscure;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              primary: Color(0xFFE29A66),      // seçili tarih, OK butonu
              onPrimary: Colors.white,         // seçili tarih yazısı
              onSurface: Colors.black87,       // takvim yazıları
            ),
            dialogBackgroundColor: Color(0xFFFFF4EC),
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
        _controller.text = '$day/$month/$year';
      });
    }
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
            controller: _controller,
            keyboardType: widget.isDateField ? TextInputType.none : widget.keyboardType,
            readOnly: widget.isDateField,
            onTap: widget.isDateField
                ? () => _pickDate(context)
                : null,
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

/// login_btn_bg.png + "Sign Up"  buton
class _SignUpButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SignUpButton({
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
