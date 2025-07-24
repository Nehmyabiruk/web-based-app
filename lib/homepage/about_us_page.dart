import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'dart:async';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  bool _isDarkMode = true; // Default to dark mode
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _heroController;
  late AnimationController _teamController;
  late AnimationController _statsController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _heroAnimation;
  late Animation<double> _teamAnimation;
  late Animation<double> _statsAnimation;
  late Animation<double> _floatingAnimation;
  
  List<AboutParticle> particles = [];
  List<TeamMember> teamMembers = [];
  List<CompanyStats> stats = [];
  List<CoreValue> coreValues = [];
  
  int _currentStoryIndex = 0;
  Timer? _storyTimer;
  
  final List<String> _ourStory = [
    "🌟 Founded with a vision to transform spiritual journeys",
    "🙏 Connecting hearts through faith and technology",
    "💫 Building a community of believers worldwide",
    "🚀 Empowering spiritual growth through innovation",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _initializeTeamMembers();
    _initializeStats();
    _initializeCoreValues();
    _startStoryRotation();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _teamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
    
    _heroAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack),
    );
    
    _teamAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _teamController, curve: Curves.elasticOut),
    );
    
    _statsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeOutCubic),
    );
    
    _floatingAnimation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _mainController.forward();
    _heroController.forward();
    _teamController.forward();
    _statsController.forward();
  }

  void _generateParticles() {
    particles = List.generate(40, (index) => AboutParticle());
  }

  void _initializeTeamMembers() {
    teamMembers = [
      TeamMember(
        name: 'Nehmya Biruk',
        role: 'Founder & CEO',
        image: 'assets/nehm.jpg',
        description: 'Visionary leader passionate about spiritual technology',
        skills: ['Leadership', 'Vision', 'Innovation', 'Faith'],
        socialLinks: {
          'facebook': 'https://www.facebook.com/Nehmya-Biruk',
          'instagram': 'https://www.instagram.com/nehmya_biruk/',
          'linkedin': 'https://linkedin.com/in/nehmya-biruk',
        },
      ),
    ];
  }

  void _initializeStats() {
    stats = [
      CompanyStats(
        icon: Icons.people,
        title: 'Active Users',
        value: '50K+',
        color: Colors.blue,
        description: 'Growing community',
      ),
      CompanyStats(
        icon: Icons.favorite,
        title: 'Prayers Shared',
        value: '100K+',
        color: Colors.red,
        description: 'Hearts connected',
      ),
      CompanyStats(
        icon: Icons.church,
        title: 'Churches',
        value: '500+',
        color: Colors.purple,
        description: 'Partner churches',
      ),
      CompanyStats(
        icon: Icons.star,
        title: 'App Rating',
        value: '4.9',
        color: Colors.orange,
        description: 'User satisfaction',
      ),
    ];
  }

  void _initializeCoreValues() {
    coreValues = [
      CoreValue(
        icon: Icons.favorite,
        title: 'Love',
        description: 'We lead with love in everything we do',
        color: Colors.red,
      ),
      CoreValue(
        icon: Icons.lightbulb,
        title: 'Innovation',
        description: 'Constantly improving spiritual experiences',
        color: Colors.yellow,
      ),
      CoreValue(
        icon: Icons.people,
        title: 'Community',
        description: 'Building connections that matter',
        color: Colors.green,
      ),
      CoreValue(
        icon: Icons.security,
        title: 'Integrity',
        description: 'Honest and transparent in all we do',
        color: Colors.blue,
      ),
    ];
  }

  void _startStoryRotation() {
    _storyTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentStoryIndex = (_currentStoryIndex + 1) % _ourStory.length;
      });
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _heroController.dispose();
    _teamController.dispose();
    _statsController.dispose();
    _floatingController.dispose();
    _storyTimer?.cancel();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
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
          'About Us',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: _isDarkMode ? Colors.white : Colors.black,
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
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      key: ValueKey(_isDarkMode),
                      color: _isDarkMode ? Colors.yellow : Colors.orange,
                      size: 28,
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
          // Animated Background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: AboutParticlePainter(
                  particles,
                  _rotationAnimation.value,
                  _isDarkMode,
                ),
                size: Size.infinite,
              );
            },
          ),
          
          // Main Content
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
                      // Hero Section
                      _buildHeroSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Mission Section
                      _buildMissionSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Stats Section
                      _buildStatsSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Team Section
                      _buildTeamSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Core Values
                      _buildCoreValuesSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Vision Section
                      _buildVisionSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Social Media
                      _buildSocialSection(),
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

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _heroAnimation.value,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [
                        Colors.purple.shade900,
                        Colors.blue.shade900,
                        Colors.teal.shade900,
                      ]
                    : [
                        Colors.purple.shade400,
                        Colors.blue.shade400,
                        Colors.teal.shade400,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: PatternPainter(_isDarkMode),
                  ),
                ),
                
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
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
                        'Welcome to Spiritual Tracker!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          _ourStory[_currentStoryIndex],
                          key: ValueKey(_currentStoryIndex),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
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

  Widget _buildMissionSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.rocket_launch,
            size: 60,
            color: _isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
          ),
          const SizedBox(height: 20),
          Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'At Spiritual Tracker, we aim to help individuals grow in their faith journey. Through our platform, we provide tools, resources, and content to help nurture spiritual growth and connect with others in the community. Whether you\'re looking for daily devotionals, prayer requests, or inspiration, we are here to support you on your spiritual path.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Text(
              'Our Impact',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                CompanyStats stat = stats[index];
                
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 800 + (index * 200)),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              stat.color.withOpacity(0.8),
                              stat.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: stat.color.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              stat.icon,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              stat.value,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              stat.title,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              stat.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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

  Widget _buildTeamSection() {
    return AnimatedBuilder(
      animation: _teamAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Text(
              'Meet Our Team',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            ...teamMembers.asMap().entries.map((entry) {
              int index = entry.key;
              TeamMember member = entry.value;
              
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 1000 + (index * 300)),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(100 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? Colors.grey.shade900.withOpacity(0.8)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade400,
                                        Colors.purple.shade400,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundImage: AssetImage(member.image),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              member.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              member.role,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              member.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: member.skills.map((skill) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: TextStyle(
                                      color: Colors.blue.shade400,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: member.socialLinks.entries.map((entry) {
                                IconData icon;
                                Color color;
                                
                                switch (entry.key) {
                                  case 'facebook':
                                    icon = FontAwesomeIcons.facebook;
                                    color = const Color(0xFF1877F2);
                                    break;
                                  case 'instagram':
                                    icon = FontAwesomeIcons.instagram;
                                    color = const Color(0xFFE4405F);
                                    break;
                                  case 'twitter':
                                    icon = FontAwesomeIcons.twitter;
                                    color = const Color(0xFF1DA1F2);
                                    break;
                                  case 'linkedin':
                                    icon = FontAwesomeIcons.linkedin;
                                    color = const Color(0xFF0A66C2);
                                    break;
                                  case 'github':
                                    icon = FontAwesomeIcons.github;
                                    color = Colors.black;
                                    break;
                                  default:
                                    icon = Icons.link;
                                    color = Colors.grey;
                                }
                                
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () => _launchURL(entry.value),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: color.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Icon(
                                        icon,
                                        color: color,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildCoreValuesSection() {
    return Column(
      children: [
        Text(
          'Our Core Values',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 25),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.9,
          ),
          itemCount: coreValues.length,
          itemBuilder: (context, index) {
            CoreValue value = coreValues[index];
            
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 600 + (index * 150)),
              builder: (context, animValue, child) {
                return Transform.scale(
                  scale: animValue,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.grey.shade900.withOpacity(0.8)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: value.color.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: value.color.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: value.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            value.icon,
                            color: value.color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          value.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          value.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildVisionSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.indigo.shade900, Colors.purple.shade900]
              : [Colors.indigo.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
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
          const Icon(
            Icons.visibility,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          const Text(
            'Our Vision',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'We envision a world where individuals are equipped and empowered to grow spiritually in all aspects of their lives. Our vision is to build a community that is committed to prayer, devotion, and helping each other navigate their faith journey with technology as our guide.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Text(
          'Connect With Us',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              FontAwesomeIcons.facebook,
              const Color(0xFF1877F2),
              'https://www.facebook.com/Nehmya-Biruk',
            ),
            _buildSocialButton(
              FontAwesomeIcons.instagram,
              const Color(0xFFE4405F),
              'https://www.instagram.com/nehmya_biruk/',
            ),
            _buildSocialButton(
              FontAwesomeIcons.twitter,
              const Color(0xFF1DA1F2),
              'https://www.twitter.com',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String url) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "share",
          mini: true,
          backgroundColor: Colors.blue,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Share functionality
          },
          child: const Icon(Icons.share, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "contact",
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            HapticFeedback.mediumImpact();
            _launchURL('mailto:mimneh@gmail.com');
          },
          child: const Icon(Icons.email, color: Colors.white),
        ),
      ],
    );
  }
}

// Data Classes
class TeamMember {
  final String name;
  final String role;
  final String image;
  final String description;
  final List<String> skills;
  final Map<String, String> socialLinks;

  TeamMember({
    required this.name,
    required this.role,
    required this.image,
    required this.description,
    required this.skills,
    required this.socialLinks,
  });
}

class CompanyStats {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String description;

  CompanyStats({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.description,
  });
}

class CoreValue {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  CoreValue({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class AboutParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  
  AboutParticle() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 0.8;
    vy = (math.Random().nextDouble() - 0.5) * 0.8;
    size = math.Random().nextDouble() * 4 + 1;
    opacity = math.Random().nextDouble() * 0.4 + 0.1;
    color = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
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

class AboutParticlePainter extends CustomPainter {
  final List<AboutParticle> particles;
  final double animationValue;
  final bool isDarkMode;
  
  AboutParticlePainter(this.particles, this.animationValue, this.isDarkMode);
  
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

class PatternPainter extends CustomPainter {
  final bool isDarkMode;
  
  PatternPainter(this.isDarkMode);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    
    for (int i = 0; i < size.width; i += 30) {
      for (int j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 2, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
