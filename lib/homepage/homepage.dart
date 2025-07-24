import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neh/homepage/about_us_page.dart';
import 'package:neh/homepage/churchcalander.dart';
import 'package:neh/homepage/contact_us_page.dart';
import 'package:neh/homepage/devotions/devotions.dart';
import 'package:neh/homepage/devotions/sermon/sermon.dart';
import 'package:neh/homepage/prayer%20request/prayer%20request.dart';
import 'package:neh/homepage/share_feedback_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'searchvoice.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'custom_drawer.dart';
import 'account_page.dart';
import 'bible_gpt_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const BibleQAApp());
}

class BibleQAApp extends StatelessWidget {
  const BibleQAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isDarkMode = true;
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _heroController;
  late AnimationController _cardController;
  late AnimationController _floatingController;
  late AnimationController _searchAnimController;
  late AnimationController _themeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _heroAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _searchAnimation;
  late Animation<double> _themeAnimation;
  List<CrazyParticle> particles = [];
  List<FloatingIcon> floatingIcons = [];
  Timer? _heroTextTimer;
  int _currentHeroIndex = 0;

  final List<String> _heroTexts = [
    "🌟 Welcome to Your Divine Journey",
    "✨ Discover Faith Through Innovation",
    "🙏 Connect with Sacred Purpose",
    "💫 Grow in Spiritual Wisdom",
    "🚀 Elevate Your Soul's Journey",
  ];

  List<HoverWidgetData> allItems = [
    HoverWidgetData(
      title: 'Bible Verses',
      image: 'assets/download.jpg',
      description: 'Read Bible verses daily and stay spiritually uplifted.',
      icon: Icons.menu_book,
      color: Colors.deepPurple,
      gradient: [Colors.deepPurple.shade600, Colors.indigo.shade600],
    ),
    HoverWidgetData(
      title: 'Prayer Requests',
      image: 'assets/papic.jpg',
      description: 'Submit prayer requests and pray with the community.',
      icon: Icons.favorite,
      color: Colors.red,
      gradient: [Colors.red.shade600, Colors.pink.shade600],
    ),
    HoverWidgetData(
      title: 'Church Calendar',
      image: 'assets/cal.jpeg',
      description: 'Stay updated with church events and activities.',
      icon: Icons.calendar_month,
      color: Colors.green,
      gradient: [Colors.green.shade600, Colors.teal.shade600],
    ),
    HoverWidgetData(
      title: 'Sermons',
      image: 'assets/pa.jpg',
      description: 'Listen to inspiring sermons from church leaders.',
      icon: Icons.record_voice_over,
      color: Colors.orange,
      gradient: [Colors.orange.shade600, Colors.amber.shade600],
    ),
    HoverWidgetData(
      title: 'Ask Bible Questions',
      image: 'assets/biblical.jpg',
      description: 'Get answers to biblical questions instantly via BibleGPT.',
      icon: Icons.quiz,
      color: Colors.purple,
      gradient: [Colors.purple.shade600, Colors.deepPurple.shade600],
    ),
    HoverWidgetData(
      title: 'Voice Search',
      image: 'assets/voice.jpg',
      description: 'Use voice commands to navigate and search spiritual content.',
      icon: Icons.mic,
      color: Colors.blue,
      gradient: [Colors.blue.shade600, Colors.cyan.shade600],
    ),
  ];

  List<HoverWidgetData> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
    _initializeAnimations();
    _generateParticles();
    _generateFloatingIcons();
    _startHeroTextRotation();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _searchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

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
    _heroAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack),
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    _floatingAnimation = Tween<double>(begin: -25, end: 25).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _searchAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _searchAnimController, curve: Curves.easeInOut),
    );
    _themeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _themeController, curve: Curves.elasticOut),
    );

    _mainController.forward();
    _heroController.forward();
    _cardController.forward();
  }

  void _generateParticles() {
    particles = List.generate(60, (index) => CrazyParticle());
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

  void _startHeroTextRotation() {
    _heroTextTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentHeroIndex = (_currentHeroIndex + 1) % _heroTexts.length;
      });
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _themeController.forward().then((_) {
      _themeController.reverse();
    });
    HapticFeedback.lightImpact();
  }

  void _filterSearchResults(String query) {
    List<HoverWidgetData> dummySearchList = [];
    dummySearchList.addAll(allItems);
    if (query.isNotEmpty) {
      List<HoverWidgetData> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredItems = dummyListData;
      });
    } else {
      setState(() {
        filteredItems = allItems;
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _heroController.dispose();
    _cardController.dispose();
    _floatingController.dispose();
    _searchAnimController.dispose();
    _themeController.dispose();
    _searchController.dispose();
    _heroTextTimer?.cancel();
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
        title: AnimatedBuilder(
          animation: _searchAnimation,
          builder: (context, child) {
            return _isSearching
                ? Container(
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.grey.shade800.withOpacity(0.8)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "🔍 Search spiritual content...",
                        hintStyle: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.grey.shade600,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      autofocus: true,
                      onChanged: _filterSearchResults,
                    ),
                  )
                : Text(
                    'Spiritual Tracker ✨',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  );
          },
        ),
        leading: Builder(
          builder: (context) => IconButton(
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
              child: const Icon(Icons.menu, color: Colors.white, size: 20),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value * 0.2),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isSearching
                            ? [Colors.red.shade400, Colors.orange.shade400]
                            : [Colors.green.shade400, Colors.teal.shade400],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (_isSearching ? Colors.red : Colors.green).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        key: ValueKey(_isSearching),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isSearching) {
                        _searchController.clear();
                        filteredItems = allItems;
                      }
                      _isSearching = !_isSearching;
                    });
                    if (_isSearching) {
                      _searchAnimController.forward();
                    } else {
                      _searchAnimController.reverse();
                    }
                    HapticFeedback.selectionClick();
                  },
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _themeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_themeAnimation.value * 0.2),
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
      drawer: _buildCrazyDrawer(),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: CrazyParticlePainter(particles, _rotationAnimation.value, _isDarkMode),
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
                double offset = _floatingAnimation.value + (index * 50);
                return Positioned(
                  top: 150 + (index * 120) + offset,
                  right: 20 + (index % 2 == 0 ? offset : -offset),
                  child: Opacity(
                    opacity: 0.3,
                    child: Icon(
                      floatingIcon.icon,
                      color: floatingIcon.color,
                      size: 30,
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
                      _buildCrazyHeroSection(),
                      const SizedBox(height: 40),
                      _buildStatsSection(),
                      const SizedBox(height: 40),
                      _buildCrazyContentGrid(),
                      const SizedBox(height: 40),
                      _buildFeaturedSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildCrazyFloatingActions(),
    );
  }

  Widget _buildCrazyHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _heroAnimation.value,
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [
                        Colors.deepPurple.shade900,
                        Colors.indigo.shade900,
                        Colors.blue.shade900,
                        Colors.teal.shade900,
                        Colors.purple.shade900,
                      ]
                    : [
                        Colors.deepPurple.shade400,
                        Colors.indigo.shade400,
                        Colors.blue.shade400,
                        Colors.teal.shade400,
                        Colors.purple.shade400,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: CrazyPatternPainter(_isDarkMode),
                  ),
                ),
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 30 + _floatingAnimation.value,
                      right: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/logo.jpg'),
                        ),
                      ),
                      const SizedBox(height: 25),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          _heroTexts[_currentHeroIndex],
                          key: ValueKey(_currentHeroIndex),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Experience the divine through cutting-edge technology\nand connect with your spiritual community',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    List<StatData> stats = [
      StatData(icon: Icons.people, title: '++', subtitle: 'Believers', color: Colors.blue),
      StatData(icon: Icons.favorite, title: '++', subtitle: 'Prayers', color: Colors.red),
      StatData(icon: Icons.church, title: '++', subtitle: 'Churches', color: Colors.green),
      StatData(icon: Icons.star, title: '++', subtitle: 'Rating', color: Colors.orange),
    ];

    return Row(
      children: stats.asMap().entries.map((entry) {
        int index = entry.key;
        StatData stat = entry.value;
        return Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 800 + (index * 200)),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        stat.color.withOpacity(0.8),
                        stat.color.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: stat.color.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          stat.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        stat.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        stat.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCrazyContentGrid() {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚀 Explore Your Divine Path',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                HoverWidgetData item = filteredItems[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 600 + (index * 150)),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: CrazyHoverWidget(
                        item: item,
                        isDarkMode: _isDarkMode,
                        onTap: () => _navigateToPage(item),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.purple.shade900, Colors.indigo.shade900, Colors.blue.shade900]
              : [Colors.purple.shade400, Colors.indigo.shade400, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '✨ Featured This Week',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Discover revolutionary ways to deepen your faith journey with our latest AI-powered features and divine community connections.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.grey],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BibleQAHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '🚀 Explore Divine AI',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrazyDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkMode
                ? [Colors.grey.shade900, Colors.black, Colors.grey.shade800]
                : [Colors.blue.shade400, Colors.purple.shade400, Colors.indigo.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/spiritual_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '✨ Spiritual Tracker',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    '🚀 Your Divine Journey Companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _crazyDrawerItem(Icons.home, '🏠 Home', () {
                    Navigator.pop(context);
                  }),
                  _crazyDrawerItem(Icons.person, '👤 Account', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage()));
                  }),
                  _crazyDrawerItem(Icons.feedback, '💬 Share Feedback', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ShareFeedbackPage()));
                  }),
                  _crazyDrawerItem(Icons.contact_mail, '📧 Contact Us', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
                  }),
                  _crazyDrawerItem(Icons.info, '📖 About Us', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
                  }),
                  _crazyDrawerItem(Icons.search, '🎤 Voice Search', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchVoice()));
                  }),
                  _crazyDrawerItem(Icons.calendar_today, '📅 Church Calendar', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChurchCalendarPage()));
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© 2025 Spiritual Tracker ✨',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white70 : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crazyDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.purple.shade400],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildCrazyFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "voice",
          mini: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchVoice()));
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
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ),
        const SizedBox(height: 15),
        FloatingActionButton(
          heroTag: "prayer",
          mini: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerRequestPage()));
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.pink.shade400],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.favorite, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _navigateToPage(HoverWidgetData item) {
    HapticFeedback.mediumImpact();
    if (item.title == 'Bible Verses') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BibleVersesPage()),
      );
    } else if (item.title == 'Prayer Requests') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrayerRequestPage()),
      );
    } else if (item.title == 'Church Calendar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChurchCalendarPage()),
      );
    } else if (item.title == 'Ask Bible Questions') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BibleGptPage()),
      );
    } else if (item.title == 'Sermons') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SermonListPage()),
      );
    } else if (item.title == 'Voice Search') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchVoice()),
      );
    }
  }
}

class CrazyHoverWidget extends StatefulWidget {
  final HoverWidgetData item;
  final bool isDarkMode;
  final VoidCallback onTap;

  const CrazyHoverWidget({
    Key? key,
    required this.item,
    required this.isDarkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  _CrazyHoverWidgetState createState() => _CrazyHoverWidgetState();
}

class _CrazyHoverWidgetState extends State<CrazyHoverWidget> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.item.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: widget.item.color.withOpacity(0.4),
                        blurRadius: _isHovered ? 25 : 15,
                        offset: const Offset(0, 10),
                      ),
                      if (_isHovered)
                        BoxShadow(
                          color: widget.item.color.withOpacity(0.2),
                          blurRadius: 35,
                          offset: const Offset(0, 20),
                        ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CardPatternPainter(widget.isDarkMode),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                widget.item.icon,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              widget.item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            AnimatedOpacity(
                              opacity: _isHovered ? 1.0 : 0.7,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                widget.item.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HoverWidgetData {
  final String title;
  final String image;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  HoverWidgetData({
    required this.title,
    required this.image,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class StatData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  StatData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class FloatingIcon {
  final IconData icon;
  final Color color;

  FloatingIcon(this.icon, this.color);
}

class CrazyParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  late double rotation;

  CrazyParticle() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 0.8;
    vy = (math.Random().nextDouble() - 0.5) * 0.8;
    size = math.Random().nextDouble() * 5 + 1;
    opacity = math.Random().nextDouble() * 0.5 + 0.1;
    rotation = math.Random().nextDouble() * 2 * math.pi;
    color = [
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.purple,
      Colors.cyan,
    ][math.Random().nextInt(6)].withOpacity(0.4);
  }

  void update() {
    x += vx;
    y += vy;
    rotation += 0.02;
    if (x < 0) x = 400;
    if (x > 400) x = 0;
    if (y < 0) y = 800;
    if (y > 800) y = 0;
  }
}

class CrazyParticlePainter extends CustomPainter {
  final List<CrazyParticle> particles;
  final double animationValue;
  final bool isDarkMode;

  CrazyParticlePainter(this.particles, this.animationValue, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var particle in particles) {
      particle.update();
      paint.color = particle.color.withOpacity(particle.opacity);
      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);
      if (particle.size > 3) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, particle.size, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CrazyPatternPainter extends CustomPainter {
  final bool isDarkMode;

  CrazyPatternPainter(this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    for (int i = 0; i < size.width; i += 50) {
      for (int j = 0; j < size.height; j += 50) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 4, paint);
        if (i < size.width - 50) {
          canvas.drawLine(
            Offset(i.toDouble(), j.toDouble()),
            Offset(i + 50.0, j.toDouble()),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class BibleQAHomePage extends StatefulWidget {
  const BibleQAHomePage({super.key});

  @override
  State<BibleQAHomePage> createState() => _BibleQAHomePageState();
}

class _BibleQAHomePageState extends State<BibleQAHomePage> with TickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> getAnswer(String verseQuery) async {
    setState(() {
      _isLoading = true;
      _answer = '';
    });

    try {
      final verse = Uri.encodeComponent(verseQuery.trim());
      final url = Uri.parse('https://bible-api.com/$verse');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _answer = data['text'] ?? 'Verse not found.';
        });
      } else {
        setState(() {
          _answer = 'Verse not found.';
        });
      }
    } catch (e) {
      setState(() {
        _answer = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('🤖 Bible AI Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✨ Ask for Bible Verses (e.g. John 3:16)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(duration: 1200.ms).slideY(begin: -0.2, end: 0),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _questionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter a verse (e.g. Matthew 5:9)',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ).animate().fadeIn(duration: 1400.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.teal.shade600],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => getAnswer(_questionController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text(
                      '🔍 Get Divine Verse',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ).animate().fadeIn(duration: 1600.ms).scale(),
                const SizedBox(height: 25),
                if (_isLoading) const CircularProgressIndicator(color: Colors.blue),
                if (_answer.isNotEmpty && !_isLoading)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey.shade800, Colors.grey.shade700],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Text(
                          _answer,
                          style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 1800.ms).scale(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}