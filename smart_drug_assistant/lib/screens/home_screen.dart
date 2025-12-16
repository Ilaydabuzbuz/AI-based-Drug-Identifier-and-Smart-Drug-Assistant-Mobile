import 'package:flutter/material.dart';
import 'chat.dart';
import 'welcome_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _designWidth = 360;

  /// TEST: günlük ekranda örnek pill event göster/gizle
  static const bool kShowTestPills = true;

  static const Color kAccentText = Color(0xFFE4A79D);

  static const Color kOrange = Color(0xFFD8874E);
  static const Color kPeach = Color(0xFFF4DED2);
  static const Color kDailyBg = Color(0xFFF7E9E0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / _designWidth;
    final now = DateTime.now();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 18 * scale),
                    child: Column(
                      children: [
                        _TopHeader(scale: scale, userName: 'Admin'),
                        SizedBox(height: 14 * scale),
                        _SearchBar(scale: scale),
                        SizedBox(height: 14 * scale),
                        _DateStrip(scale: scale, today: now),
                        SizedBox(height: 14 * scale),

                        // DAILY: event’ler saat satırına göre yerleşiyor
                        _DailyCard(scale: scale, today: now),

                        SizedBox(height: 18 * scale),

                        // Quick action butonları
                        _QuickActions(
                          scale: scale,
                          onPillId: () => debugPrint('Pill identification tapped'),
                          onMyMedicine: () => debugPrint('My Medicine tapped'),
                          onChatbot: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ChatScreen()),
                            );
                          },
                          onSchedule: () => debugPrint('Medicine Schedule tapped'),
                        ),

                        SizedBox(height: 18 * scale),
                      ],
                    ),
                  ),
                ),                Padding(
                  padding: EdgeInsets.fromLTRB(18 * scale, 0, 18 * scale, 8 * scale),
                  child: _BottomNav(
                    scale: scale,
                    selectedIndex: 0,
                    onHome: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                            (route) => false,
                      );
                    },
                    onProfile: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
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

/* ───────── TOP HEADER ───────── */

class _TopHeader extends StatelessWidget {
  final double scale;
  final String userName;

  const _TopHeader({required this.scale, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18 * scale),
          child: Image.asset(
            'assets/images/default_avatar.png',
            width: 40 * scale,
            height: 40 * scale,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10 * scale),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, WelcomeBack',
              style: TextStyle(
                fontSize: 11 * scale,
                color: HomeScreen.kAccentText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2 * scale),
            Text(
              userName,
              style: TextStyle(
                fontSize: 16 * scale,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        _CircleIconButton(scale: scale, icon: Icons.notifications_none_rounded, onTap: () {}),
        SizedBox(width: 10 * scale),
        _CircleIconButton(scale: scale, icon: Icons.settings_outlined, onTap: () {}),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final double scale;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.scale, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeScreen.kPeach,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8 * scale),
          child: Icon(icon, size: 16 * scale, color: Colors.black87),
        ),
      ),
    );
  }
}

/* ───────── SEARCH ───────── */

class _SearchBar extends StatelessWidget {
  final double scale;
  const _SearchBar({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36 * scale,
      decoration: BoxDecoration(
        color: HomeScreen.kPeach,
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14 * scale),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, size: 18 * scale),
          const Spacer(),
          Icon(Icons.search_rounded, size: 18 * scale),
        ],
      ),
    );
  }
}

/* ───────── DATE STRIP ───────── */

class _DateStrip extends StatelessWidget {
  final double scale;
  final DateTime today;

  const _DateStrip({required this.scale, required this.today});

  @override
  Widget build(BuildContext context) {
    // 2 gün önce + bugün + 3 gün sonra = 6 kutu
    final days = List<DateTime>.generate(6, (i) => today.add(Duration(days: i - 2)));

    return SizedBox(
      height: 56 * scale,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((d) {
          final isToday = d.year == today.year && d.month == today.month && d.day == today.day;
          final dow = const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][d.weekday - 1];

          return Container(
            width: 46 * scale,
            height: 56 * scale,
            decoration: BoxDecoration(
              color: isToday ? HomeScreen.kOrange : HomeScreen.kPeach,
              borderRadius: BorderRadius.circular(18 * scale),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${d.day}',
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w800,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  dow,
                  style: TextStyle(
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/* ───────── DAILY CARD ───────── */

class _DailyCard extends StatelessWidget {
  final double scale;
  final DateTime today;

  const _DailyCard({required this.scale, required this.today});

  @override
  Widget build(BuildContext context) {
    // Satır yüksekliği
    final double rowH = 26 * scale;

    // 9 AM – 5 PM (9 satır)
    final times = const ['9 AM', '10 AM', '11 AM', '12 AM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM'];

    // Test event’ler (2 tane)
    final events = HomeScreen.kShowTestPills
        ? <PillEventData>[
      PillEventData(hourIndex: 1, pillName: 'Pill Name', took: true), // 10 AM
      PillEventData(hourIndex: 6, pillName: 'Pill Name', took: true), // 3 PM
    ]
        : <PillEventData>[];

    final title = '${today.day} ${_weekdayLong(today)} - Today (Daily)';

    final double cardH = 310 * scale;

    return Container(
      width: double.infinity,
      height: cardH,
      decoration: BoxDecoration(
        color: HomeScreen.kDailyBg,
        borderRadius: BorderRadius.circular(18 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: EdgeInsets.all(14 * scale),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w700,
                        color: HomeScreen.kAccentText,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 22 * scale, color: HomeScreen.kOrange),
                ],
              ),
              SizedBox(height: 10 * scale),

              // Timeline area
              Expanded(
                child: Builder(
                  builder: (context) {
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final lineH = 1 / dpr;

                    return Stack(
                      children: [
                        // saat satırları + her saatin yanında çizgi
                        Positioned.fill(
                          child: Column(
                            children: List.generate(times.length, (i) {
                              return SizedBox(
                                height: rowH,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 44 * scale,
                                      child: Text(
                                        times[i],
                                        style: TextStyle(
                                          fontSize: 10.5 * scale,
                                          color: HomeScreen.kAccentText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: lineH,
                                          color: HomeScreen.kAccentText.withOpacity(0.65),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),

                        // event’ler: çizginin ÜSTÜNE biner
                        ...events.map((e) {
                          return Positioned(
                            left: 52 * scale,
                            top: (e.hourIndex * rowH) + (rowH / 2) - ((26 * scale) / 2),
                            right: 0,
                            child: PillEventWidget(scale: scale, data: e),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 10 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(scale: scale, active: false),
                  _Dot(scale: scale, active: true),
                  _Dot(scale: scale, active: false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _weekdayLong(DateTime d) {
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[d.weekday - 1];
  }
}

class _HairlineCenterPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _HairlineCenterPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false;

    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant _HairlineCenterPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _Dot extends StatelessWidget {
  final double scale;
  final bool active;
  const _Dot({required this.scale, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 10 * scale : 6 * scale,
      height: 6 * scale,
      margin: EdgeInsets.symmetric(horizontal: 4 * scale),
      decoration: BoxDecoration(
        color: active ? HomeScreen.kOrange : HomeScreen.kAccentText.withOpacity(0.55),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

/* ───────── PILL EVENT ───────── */

class PillEventData {
  final int hourIndex; // 9AM=0, 10AM=1, ...
  final String pillName;
  final bool took;

  const PillEventData({
    required this.hourIndex,
    required this.pillName,
    required this.took,
  });
}

class PillEventWidget extends StatelessWidget {
  final double scale;
  final PillEventData data;

  const PillEventWidget({
    super.key,
    required this.scale,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    final double h = 26 * scale;

    return SizedBox(
      height: h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: HomeScreen.kDailyBg),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/rect145.png',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data.pillName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5 * scale,
                      fontWeight: FontWeight.w800,
                      color: HomeScreen.kOrange,
                    ),
                  ),
                ),
                Container(
                  width: 46 * scale,
                  height: 18 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Took',
                    style: TextStyle(
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 7 * scale),
                Container(
                  width: 18 * scale,
                  height: 18 * scale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 13 * scale,
                    color: data.took ? Colors.green : Colors.black26,
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

/* ───────── QUICK ACTIONS ───────── */

class _QuickActions extends StatelessWidget {
  final double scale;
  final VoidCallback onPillId;
  final VoidCallback onMyMedicine;
  final VoidCallback onChatbot;
  final VoidCallback onSchedule;

  const _QuickActions({
    required this.scale,
    required this.onPillId,
    required this.onMyMedicine,
    required this.onChatbot,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionBtn(
                scale: scale,
                title: 'Pill\nidentification',
                icon: Icons.qr_code_scanner_rounded,
                onTap: onPillId,
              ),
            ),
            SizedBox(width: 12 * scale),
            Expanded(
              child: _ActionBtn(
                scale: scale,
                title: 'My Medicine',
                icon: Icons.medication_outlined,
                onTap: onMyMedicine,
              ),
            ),
          ],
        ),
        SizedBox(height: 12 * scale),
        Row(
          children: [
            Expanded(
              child: _ActionBtn(
                scale: scale,
                title: 'Chatbot\n(Ask Question)',
                icon: Icons.smart_toy_outlined,
                onTap: onChatbot,
              ),
            ),
            SizedBox(width: 12 * scale),
            Expanded(
              child: _ActionBtn(
                scale: scale,
                title: 'Medicine\nSchedule',
                icon: Icons.calendar_month_outlined,
                onTap: onSchedule,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final double scale;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.scale,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56 * scale,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16 * scale),
          child: Container(
            decoration: BoxDecoration(
              color: HomeScreen.kPeach,
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 12 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 20 * scale, color: Colors.black87),
                SizedBox(width: 10 * scale),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5 * scale,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────── BOTTOM NAV ───────── */

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
        color: HomeScreen.kOrange,
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
