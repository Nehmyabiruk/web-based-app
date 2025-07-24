import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

class ChurchCalendarPage extends StatefulWidget {
  const ChurchCalendarPage({super.key});

  @override
  State<ChurchCalendarPage> createState() => _ChurchCalendarPageState();
}

class _ChurchCalendarPageState extends State<ChurchCalendarPage> with TickerProviderStateMixin {
  bool _isDarkMode = true;
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _calendarController;
  late AnimationController _eventController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _calendarAnimation;
  late Animation<double> _eventAnimation;
  late Animation<double> _floatingAnimation;
  List<CalendarParticle> particles = [];
  List<FloatingIcon> floatingIcons = [];
  PageController _monthController = PageController(initialPage: DateTime.now().month - 1);
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  int selectedEventIndex = -1;

  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _generateFloatingIcons();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _calendarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _eventController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _particleController,
    );
    _calendarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _calendarController, curve: Curves.elasticOut),
    );
    _eventAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _eventController, curve: Curves.easeOutBack),
    );
    _floatingAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _mainController.forward();
    _calendarController.forward();
  }

  void _generateParticles() {
    particles = List.generate(30, (index) => CalendarParticle());
  }

  void _generateFloatingIcons() {
    floatingIcons = [
      FloatingIcon(Icons.auto_awesome, Colors.yellow),
      FloatingIcon(Icons.favorite, Colors.red),
      FloatingIcon(Icons.star, Colors.orange),
      FloatingIcon(Icons.lightbulb, Colors.blue),
      FloatingIcon(Icons.celebration, Colors.purple),
    ];
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedEventIndex = -1;
    });
    _eventController.forward().then((_) => _eventController.reverse());
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _calendarController.dispose();
    _eventController.dispose();
    _floatingController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Church Calendar',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value * 0.3),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isDarkMode
                            ? [Colors.yellow.shade400, Colors.orange.shade400]
                            : [Colors.indigo.shade400, Colors.purple.shade400],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (_isDarkMode ? Colors.yellow : Colors.indigo).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        key: ValueKey(_isDarkMode),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  onPressed: _toggleTheme,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: CalendarParticlePainter(particles, _rotationAnimation.value, _isDarkMode),
                size: Size.infinite,
              );
            },
          ),
          ...floatingIcons.asMap().entries.map((entry) {
            int index = entry.key;
            FloatingIcon floatingIcon = entry.value;
            return AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                double offset = _floatingAnimation.value + (index * 30);
                return Positioned(
                  top: 150 + (index * 100) + offset,
                  right: 20 + (index % 2 == 0 ? offset : -offset),
                  child: Opacity(
                    opacity: 0.3,
                    child: Icon(
                      floatingIcon.icon,
                      color: floatingIcon.color,
                      size: 25,
                    ),
                  ),
                );
              },
            );
          }).toList(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildCalendar(),
                      const SizedBox(height: 30),
                      _buildEventsSection(),
                      const SizedBox(height: 30),
                      _buildQuickActions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [Colors.indigo.shade900, Colors.purple.shade900, Colors.blue.shade900]
                    : [Colors.indigo.shade400, Colors.purple.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: (_isDarkMode ? Colors.indigo : Colors.blue).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: CardPatternPainter(_isDarkMode),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                        ),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.calendar_month, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Church Events Calendar',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Stay connected with our community events',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 1200.ms).slideY(begin: -0.2, end: 0),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return AnimatedBuilder(
      animation: _calendarAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _calendarAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [Colors.grey.shade900.withOpacity(0.8), Colors.black.withOpacity(0.8)]
                    : [Colors.white.withOpacity(0.9), Colors.grey.shade100.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                        });
                        _monthController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        HapticFeedback.selectionClick();
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.purple.shade400],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.chevron_left, color: Colors.white, size: 20),
                      ),
                    ),
                    Text(
                      '${months[currentMonth.month - 1]} ${currentMonth.year}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                        });
                        _monthController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        HapticFeedback.selectionClick();
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.purple.shade400],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.chevron_right, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                _buildCalendarGrid(),
              ],
            ),
          ).animate().fadeIn(duration: 1400.ms).scale(),
        );
      },
    );
  }

  Widget _buildCalendarGrid() {
    DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;
    int firstWeekday = firstDayOfMonth.weekday % 7;
    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      bool isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      bool isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => _selectDate(date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                    )
                  : (isToday
                      ? LinearGradient(
                          colors: [Colors.orange.shade400, Colors.amber.shade400],
                        )
                      : null),
              color: isSelected || isToday ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (_isDarkMode ? Colors.white : Colors.black),
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: dayWidgets,
    );
  }

  Widget _buildEventsSection() {
    return AnimatedBuilder(
      animation: _eventAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.event_available,
                    title: 'Request Events',
                    color: Colors.green,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RequestChurchEventsPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildQuickAction(
                    icon: Icons.search,
                    title: 'Search Events',
                    color: Colors.blue,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchChurchEventsPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 1600.ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                icon: Icons.add_circle,
                title: 'Add Event',
                color: Colors.purple,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showAddEventDialog();
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildQuickAction(
                icon: Icons.notifications,
                title: 'Reminders',
                color: Colors.orange,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showRemindersDialog();
                },
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 1800.ms).scale();
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 1000.ms).scale(),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "today",
          mini: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            HapticFeedback.mediumImpact();
            setState(() {
              selectedDate = DateTime.now();
              currentMonth = DateTime.now();
            });
            _monthController.jumpToPage(DateTime.now().month - 1);
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.today, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "add_event",
          mini: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showAddEventDialog();
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.teal.shade400],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Add New Event',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Event creation feature coming soon! 🎉',
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: _isDarkMode ? Colors.blue : Colors.blue.shade700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRemindersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Event Reminders',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Reminder settings will be available soon! 🔔',
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: _isDarkMode ? Colors.blue : Colors.blue.shade700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RequestChurchEventsPage extends StatefulWidget {
  const RequestChurchEventsPage({super.key});

  @override
  _RequestChurchEventsPageState createState() => _RequestChurchEventsPageState();
}

class _RequestChurchEventsPageState extends State<RequestChurchEventsPage> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDarkMode = true;
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  List<CalendarParticle> particles = [];

  Future<void> _submitEvent() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost/church_api/save_event.php'),
        body: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final snackBarMessage = responseBody['success']
            ? 'Event submitted successfully!'
            : 'Failed to submit event!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackBarMessage)),
        );

        if (responseBody['success']) {
          _nameController.clear();
          _descriptionController.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to connect to the server.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    _mainController.forward();
  }

  void _generateParticles() {
    particles = List.generate(30, (index) => CalendarParticle());
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Request Church Events',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isDarkMode
                      ? [Colors.yellow.shade400, Colors.orange.shade400]
                      : [Colors.indigo.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (_isDarkMode ? Colors.yellow : Colors.indigo).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(_isDarkMode),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: CalendarParticlePainter(particles, _particleController.value * 2 * math.pi, _isDarkMode),
                size: Size.infinite,
              );
            },
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isDarkMode
                                ? [Colors.indigo.shade900, Colors.purple.shade900]
                                : [Colors.indigo.shade400, Colors.purple.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                                ),
                                border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                              ),
                              child: Icon(Icons.event, color: Colors.white, size: 30),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Request a Church Event',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Submit your event ideas to our community',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 1200.ms).slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Event Name',
                          labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.grey.shade600),
                          filled: true,
                          fillColor: _isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.event, color: Colors.deepPurpleAccent),
                        ),
                      ).animate().fadeIn(duration: 1400.ms).slideX(begin: -0.2, end: 0),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Event Description',
                          labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.grey.shade600),
                          filled: true,
                          fillColor: _isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.description, color: Colors.deepPurpleAccent),
                        ),
                      ).animate().fadeIn(duration: 1600.ms).slideX(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade600, Colors.teal.shade600],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submitEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Submit Request',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 1800.ms).scale(),
                    ],
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

class SearchChurchEventsPage extends StatefulWidget {
  const SearchChurchEventsPage({super.key});

  @override
  _SearchChurchEventsPageState createState() => _SearchChurchEventsPageState();
}

class _SearchChurchEventsPageState extends State<SearchChurchEventsPage> with TickerProviderStateMixin {
  List<dynamic> events = [];
  bool isLoading = true;
  bool _isDarkMode = true;
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  List<CalendarParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    fetchEvents();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    _mainController.forward();
  }

  void _generateParticles() {
    particles = List.generate(30, (index) => CalendarParticle());
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.13/church_api/get_events.php'));
      if (response.statusCode == 200) {
        setState(() {
          events = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search Church Events',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isDarkMode
                      ? [Colors.yellow.shade400, Colors.orange.shade400]
                      : [Colors.indigo.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (_isDarkMode ? Colors.yellow : Colors.indigo).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(_isDarkMode),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: CalendarParticlePainter(particles, _particleController.value * 2 * math.pi, _isDarkMode),
                size: Size.infinite,
              );
            },
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isDarkMode
                                ? [Colors.indigo.shade900, Colors.purple.shade900]
                                : [Colors.indigo.shade400, Colors.purple.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                                ),
                                border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                              ),
                              child: Icon(Icons.search, color: Colors.white, size: 30),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Search Church Events',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Browse upcoming and past community events',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 1200.ms).slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 20),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(color: Colors.blue),
                            ).animate().fadeIn(duration: 1400.ms)
                          : events.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isDarkMode
                                          ? [Colors.grey.shade900, Colors.grey.shade800]
                                          : [Colors.grey.shade200, Colors.grey.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        size: 60,
                                        color: _isDarkMode ? Colors.white54 : Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'No events found.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _isDarkMode ? Colors.white54 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 1600.ms).scale()
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: events.length,
                                    itemBuilder: (context, index) {
                                      final event = events[index];
                                      return TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: Duration(milliseconds: 400 + (index * 100)),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(50 * (1 - value), 0),
                                            child: Opacity(
                                              opacity: value,
                                              child: Container(
                                                margin: const EdgeInsets.only(bottom: 15),
                                                padding: const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue.shade600.withOpacity(0.8),
                                                      Colors.purple.shade600.withOpacity(0.6),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.blue.withOpacity(0.3),
                                                      blurRadius: 15,
                                                      offset: const Offset(0, 5),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white.withOpacity(0.2),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: Icon(
                                                            Icons.event,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 15),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                event['name'] ?? 'Unnamed Event',
                                                                style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5),
                                                              Text(
                                                                event['created_at'] ?? 'Unknown Date',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.white.withOpacity(0.8),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      event['description'] ?? 'No description available.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white.withOpacity(0.9),
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                    ],
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

class CalendarParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;

  CalendarParticle() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 0.5;
    vy = (math.Random().nextDouble() - 0.5) * 0.5;
    size = math.Random().nextDouble() * 3 + 1;
    opacity = math.Random().nextDouble() * 0.3 + 0.1;
    color = [
      Colors.blue,
      Colors.purple,
      Colors.indigo,
      Colors.teal,
    ][math.Random().nextInt(4)].withOpacity(0.3);
  }

  void update() {
    x += vx;
    y += vy;
    if (x < 0) x = 400;
    if (x > 400) x = 0;
    if (y < 0) y = 800;
    if (y > 800) y = 0;
  }
}

class CalendarParticlePainter extends CustomPainter {
  final List<CalendarParticle> particles;
  final double animationValue;
  final bool isDarkMode;

  CalendarParticlePainter(this.particles, this.animationValue, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var particle in particles) {
      particle.update();
      paint.color = particle.color.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FloatingIcon {
  final IconData icon;
  final Color color;

  FloatingIcon(this.icon, this.color);
}

class CardPatternPainter extends CustomPainter {
  final bool isDarkMode;

  CardPatternPainter(this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    for (int i = 0; i < size.width; i += 25) {
      for (int j = 0; j < size.height; j += 25) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}