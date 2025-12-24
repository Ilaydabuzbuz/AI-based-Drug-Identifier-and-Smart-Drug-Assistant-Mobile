import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smart_drug_assistant/screens/pill_identification_results_screen.dart';

import 'home_screen.dart';
import 'adding_pill_screen.dart';

class PillIdentificationScreen extends StatefulWidget {
  const PillIdentificationScreen({super.key});

  @override
  State<PillIdentificationScreen> createState() => _PillIdentificationScreenState();
}

class _PillIdentificationScreenState extends State<PillIdentificationScreen> {
  static const double _designWidth = 360;

  // same palette
  static const Color kOrange = Color(0xFFD8874E);
  static const Color kPeach = Color(0xFFF4DED2);

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    final uri = Uri.parse('http://127.0.0.1:8000/pill_identify/');
    final request = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath(
      'file',
      _selectedImage!.path,
    );
    request.files.add(file);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final results = jsonDecode(responseBody);
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PillIdentificationResultsScreen(results: results),
          ),
        );
      } else {
        if (!mounted) return;
        _showError('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to upload image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final img = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (!mounted) return;
      if (img == null) return;

      setState(() => _selectedImage = img);
      _showPickedPreview();
    } catch (e) {
      if (!mounted) return;
      _showError('Camera açılamadı: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (!mounted) return;
      if (img == null) return;

      setState(() => _selectedImage = img);
      _showPickedPreview();
    } catch (e) {
      if (!mounted) return;
      _showError('Galeri açılamadı: $e');
    }
  }

  void _showPickedPreview() {
    final file = _selectedImage == null ? null : File(_selectedImage!.path);
    if (file == null) return;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(file, fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _uploadImage();
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hata'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / _designWidth;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/identification_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // TOP BAR: back + title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18 * scale),
                  child: SizedBox(
                    height: 52 * scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(14 * scale),
                            child: Padding(
                              padding: EdgeInsets.all(8 * scale),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18 * scale,
                                color: kOrange,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Pill Identification',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      const Spacer(flex: 16),
                      _PeachButton(
                        scale: scale,
                        label: 'Identify With Camera',
                        onTap: _pickFromCamera,
                      ),
                      SizedBox(height: 16 * scale),
                      _PeachButton(
                        scale: scale,
                        label: 'Upload Image',
                        onTap: _pickFromGallery,
                      ),
                      SizedBox(height: 16 * scale),
                      _PeachButton(
                        scale: scale,
                        label: 'Add Manually',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddingPillScreen(),
                            ),
                          );
                        },
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(18 * scale, 0, 18 * scale, 8 * scale),
                  child: _BottomNav(
                    scale: scale,
                    selectedIndex: 0,
                    onHome: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    onProfile: () => debugPrint('Profile tapped'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class _PeachButton extends StatelessWidget {
  final double scale;
  final String label;
  final VoidCallback onTap;

  const _PeachButton({
    required this.scale,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = 230 * scale;
    final h = 44 * scale;

    return SizedBox(
      width: w,
      height: h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22 * scale),
          child: Container(
            decoration: BoxDecoration(
              color: _PillIdentificationScreenState.kPeach,
              borderRadius: BorderRadius.circular(22 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.5 * scale,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────── BOTTOM NAV (no highlight) ───────── */

class _BottomNav extends StatelessWidget {
  final double scale;
  final VoidCallback onHome;
  final VoidCallback onProfile;
  final int selectedIndex;

  const _BottomNav({
    required this.scale,
    required this.onHome,
    required this.onProfile,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52 * scale,
      decoration: BoxDecoration(
        color: _PillIdentificationScreenState.kOrange,
        borderRadius: BorderRadius.circular(28 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 64 * scale,
              height: 6 * scale,
              margin: EdgeInsets.only(top: 6 * scale),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavIcon(
                  scale: scale,
                  icon: Icons.home_rounded,
                  onTap: onHome,
                ),
                _NavIcon(
                  scale: scale,
                  icon: Icons.person_outline_rounded,
                  onTap: onProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final double scale;
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon({
    required this.scale,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20 * scale),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(10 * scale),
        child: Icon(
          icon,
          size: 24 * scale,
          color: Colors.white,
        ),
      ),
    );
  }
}
