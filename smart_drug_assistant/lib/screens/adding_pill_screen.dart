import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class AddingPillScreen extends StatefulWidget {
  const AddingPillScreen({super.key});

  @override
  State<AddingPillScreen> createState() => _AddingPillScreenState();
}

class _AddingPillScreenState extends State<AddingPillScreen> {
  static const Color _peach = Color(0xFFE9B79C);
  static const Color _peachSoft = Color(0xFFF3E2D8);
  static const Color _orange = Color(0xFFD98A54);
  static const Color _textDark = Color(0xFF2C2C2C);

  int _timesPerDay = 1; // 1..10

  final List<TimeOfDay> _selectedTimes = [];

  DateTime _startDate = DateTime(2025, 1, 1);
  DateTime _finishDate = DateTime(2025, 2, 1);

  bool _reminder = true;
  final TextEditingController _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  String get _frequencyLabel {
    const labels = [
      "Once A Day",
      "Twice A Day",
      "Three Times A Day",
      "Four Times A Day",
      "Five Times A Day",
      "Six Times A Day",
      "Seven Times A Day",
      "Eight Times A Day",
      "Nine Times A Day",
      "Ten Times A Day",
    ];
    return labels[_timesPerDay - 1];
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hour;
    final minute = t.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;
    return "${hour12.toString().padLeft(2, '0')}:$minute ${isAm ? "AM" : "PM"}";
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return "[$dd.$mm.$yyyy]";
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _finishDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _orange,
              onPrimary: Colors.white,
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_finishDate.isBefore(_startDate)) _finishDate = _startDate;
      } else {
        _finishDate = picked;
        if (_finishDate.isBefore(_startDate)) _startDate = _finishDate;
      }
    });
  }

  void _openFrequencySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _BottomSheetCard(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: 10,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final n = i + 1;
              final label = [
                "Once A Day",
                "Twice A Day",
                "Three Times A Day",
                "Four Times A Day",
                "Five Times A Day",
                "Six Times A Day",
                "Seven Times A Day",
                "Eight Times A Day",
                "Nine Times A Day",
                "Ten Times A Day",
              ][i];

              final selected = (n == _timesPerDay);

              return ListTile(
                title: Text(label, style: const TextStyle(color: _textDark)),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: _orange)
                    : const Icon(Icons.circle_outlined, color: Colors.black26),
                onTap: () {
                  setState(() {
                    _timesPerDay = n;
                    if (_selectedTimes.length > _timesPerDay) {
                      _selectedTimes.removeRange(_timesPerDay, _selectedTimes.length);
                    }
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  List<TimeOfDay> _build24Times() {
    final List<TimeOfDay> list = [];
    for (int h = 1; h <= 23; h++) {
      list.add(TimeOfDay(hour: h, minute: 0));
    }
    list.add(const TimeOfDay(hour: 0, minute: 0));
    return list;
  }

  void _openTimeSheet() {
    final times = _build24Times();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return _BottomSheetCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(_timesPerDay, (index) {
                          final hasValue = index < _selectedTimes.length;
                          final label = hasValue ? _formatTime(_selectedTimes[index]) : "— — : — —";

                          return Container(
                            width: 160,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: _textDark),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: times.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final t = times[i];
                        final isSelected = _selectedTimes.any((x) => x.hour == t.hour && x.minute == t.minute);
                        final limitReached = _selectedTimes.length >= _timesPerDay;
                        final canTap = !(limitReached && !isSelected);

                        return ListTile(
                          title: Text(_formatTime(t), style: const TextStyle(color: _textDark)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: _orange)
                              : const Icon(Icons.circle_outlined, color: Colors.black26),
                          enabled: canTap,
                          onTap: () {
                            modalSetState(() {
                              if (isSelected) {
                                _selectedTimes.removeWhere((x) => x.hour == t.hour && x.minute == t.minute);
                              } else {
                                if (_selectedTimes.length >= _timesPerDay) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('You can select only $_timesPerDay time(s) for "$_frequencyLabel".'),
                                    ),
                                  );
                                  return;
                                }
                                _selectedTimes.add(t);
                              }
                              _selectedTimes.sort(
                                    (a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute),
                              );
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(color: _orange, fontWeight: FontWeight.w800, letterSpacing: 1.1),
      ),
    );
  }

  Widget _dropdownCard({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _peachSoft,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: _orange, size: 26),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({required String title, required String value, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _peachSoft,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _textDark)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: _textDark)),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: _orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillNameChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _peachSoft,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: const Text(
        '"identified Pill Name"',
        style: TextStyle(color: _textDark, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _primaryButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      height: 44,
      width: 140,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _orange,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timesText = _selectedTimes.isEmpty ? "Select time" : _selectedTimes.map(_formatTime).join("  •  ");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Column(
                    children: [
                Row(
                children: [
                IconButton(
                onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          ),
          const Expanded(
            child: Text(
              "Adding Pill",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textDark),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),

      const SizedBox(height: 12),
      _pillNameChip(),
      const SizedBox(height: 18),

      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
              children: [
              _label("Frequency"),
          _dropdownCard(text: _frequencyLabel, onTap: _openFrequencySheet),
          const SizedBox(height: 16),
          _label("Time"),
          _dropdownCard(text: timesText, onTap: _openTimeSheet),
          const SizedBox(height: 16),
          _label("Date"),
          Row(
            children: [
              _dateCard(title: "Start Date", value: _formatDate(_startDate), onTap: () => _pickDate(isStart: true)),
              const SizedBox(width: 12),
              _dateCard(title: "Finish Date", value: _formatDate(_finishDate), onTap: () => _pickDate(isStart: false)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _peachSoft,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Reminder",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textDark),
                  ),
                ),
                Switch(
                  value: _reminder,
                  activeColor: _orange,
                  onChanged: (v) => setState(() => _reminder = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _peachSoft,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 8)),
              ],
            ),
            child: TextField(
              controller: _detailsCtrl,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "General Details about the pill",hintStyle: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF3A2F2A)),
            ),
            style: const TextStyle(color: _textDark),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _primaryButton(text: "Reject", onTap: () => Navigator.of(context).pop()),
            _primaryButton(
              text: "Save",
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved (dummy)")),
              ),
            ),
          ],
        ),
        ],
      ),
    ),
    ),

    _BottomNav(
    selectedIndex: 0,
    onHome: () {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const HomeScreen()),
    (route) => false,
    );
    },
    onProfile: () {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const ProfileScreen()),
    (route) => false,
    );
    },
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onProfile;
  final int selectedIndex;

  const _BottomNav({
    required this.onHome,
    required this.onProfile,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: _AddingPillScreenState._orange,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 86,
              height: 6,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavIcon(
                  icon: selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  selected: selectedIndex == 0,
                  onTap: onHome,
                ),
                _NavIcon(
                  icon: selectedIndex == 1 ? Icons.person : Icons.person_outline_rounded,
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
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSheetCard extends StatelessWidget {
  const _BottomSheetCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x24000000), blurRadius: 18, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
