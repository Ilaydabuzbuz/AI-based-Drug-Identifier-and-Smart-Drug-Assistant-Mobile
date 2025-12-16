import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double _designWidth = 360;

  static const Color kOrange = Color(0xFFD8874E);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / _designWidth;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // TOP BAR: geri + başlık
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
                          'My Profile',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w800,
                            color: kOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 6 * scale),

                // AVATAR + EDIT BADGE + NAME
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 90 * scale,
                          height: 90 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE6EEF8),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/default_avatar.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4 * scale,
                          bottom: 6 * scale,
                          child: Container(
                            width: 22 * scale,
                            height: 22 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kOrange,
                              border: Border.all(color: Colors.white, width: 2 * scale),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 12 * scale,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10 * scale),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w800,
                        color: kOrange,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18 * scale),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18 * scale),
                    child: Column(
                      children: [
                        _ProfileRow(scale: scale, label: 'Profile', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Health Informations', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Sharing Permissions', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Privacy Policy', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Settings', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Help', onTap: () {}),
                        _ProfileRow(scale: scale, label: 'Logout', onTap: () {}),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(18 * scale, 0, 18 * scale, 8 * scale),
                  child: _BottomNav(
                    scale: scale,
                    selectedIndex: 1,
                    onHome: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                            (route) => false,
                      );
                    },
                    onProfile: () {},
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

class _ProfileRow extends StatelessWidget {
  final double scale;
  final String label;
  final VoidCallback onTap;

  const _ProfileRow({
    required this.scale,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leftTextPad = 72 * scale;

    return SizedBox(
      height: 56 * scale,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14 * scale),
        child: Padding(
          padding: EdgeInsets.only(left: leftTextPad, right: 6 * scale, top: 8 * scale),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22 * scale,
                color: const Color(0xFFB7C8FF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────── BOTTOM NAV (3. ss) ───────── */

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
        color: ProfileScreen.kOrange,
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
                  selected: selectedIndex == 0,
                  onTap: onHome,
                ),
                _NavIcon(
                  scale: scale,
                  icon: Icons.person_outline_rounded,
                  selected: selectedIndex == 1,
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
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.scale,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20 * scale),
      child: Container(
        padding: EdgeInsets.all(10 * scale),
        decoration: selected
            ? BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        )
            : null,
        child: Icon(
          icon,
          size: 24 * scale,
          color: Colors.white,
        ),
      ),
    );
  }
}
