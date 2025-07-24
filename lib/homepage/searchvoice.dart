import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

class SearchVoice extends StatefulWidget {
  @override
  _SearchVoiceState createState() => _SearchVoiceState();
}

class _SearchVoiceState extends State<SearchVoice>
    with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isResponding = false;
  bool _isDarkMode = false;
  String _text = "Press the button and start speaking";
  String _response = "";
  String _currentMode = "General";
  
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _particleController;
  late AnimationController _responseController;
  late AnimationController _modeController;
  late AnimationController _floatingController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _responseAnimation;
  late Animation<double> _modeAnimation;
  late Animation<double> _floatingAnimation;
  
  List<VoiceParticle> particles = [];
  List<WavePoint> wavePoints = [];
  List<String> modes = ["General", "Bible", "Advice", "Music", "Preachers"];
  List<IconData> modeIcons = [
    Icons.chat_bubble_outline,
    Icons.menu_book,
    Icons.lightbulb_outline,
    Icons.music_note,
    Icons.record_voice_over,
  ];
  
  Timer? _listeningTimer;
  int _listeningDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _generateWavePoints();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _responseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _modeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _waveController,
    );
    
    _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
      _particleController,
    );
    
    _responseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _responseController, curve: Curves.elasticOut),
    );
    
    _modeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _modeController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  void _generateParticles() {
    particles = List.generate(40, (index) => VoiceParticle());
  }

  void _generateWavePoints() {
    wavePoints = List.generate(50, (index) => WavePoint(index.toDouble()));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    _responseController.dispose();
    _modeController.dispose();
    _floatingController.dispose();
    _listeningTimer?.cancel();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  void _changeMode(String mode) {
    setState(() {
      _currentMode = mode;
    });
    _modeController.forward().then((_) {
      _modeController.reverse();
    });
    HapticFeedback.selectionClick();
  }

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _listeningDuration = 0;
        _text = "Listening... Speak now!";
      });
      
      _pulseController.repeat(reverse: true);
      HapticFeedback.mediumImpact();
      
      // Start listening timer
      _listeningTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _listeningDuration++;
        });
      });
      
      // Simulate speech recognition
      await Future.delayed(const Duration(seconds: 3));
      
      if (_isListening) {
        setState(() {
          _isListening = false;
          _isProcessing = true;
          _text = "Processing your request...";
        });
        
        _pulseController.stop();
        _listeningTimer?.cancel();
        
        // Simulate processing
        await Future.delayed(const Duration(seconds: 2));
        
        String recognizedText = _getSimulatedInput();
        setState(() {
          _text = recognizedText;
          _isProcessing = false;
        });
        
        _respondToInput(recognizedText);
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _isProcessing = false;
      _text = "Tap to speak again";
    });
    _pulseController.stop();
    _pulseController.reset();
    _listeningTimer?.cancel();
    HapticFeedback.lightImpact();
  }

  String _getSimulatedInput() {
    List<String> sampleInputs = [
      "Hello, how are you?",
      "Can you give me some advice?",
      "Tell me a Bible verse",
      "Who are some gospel singers?",
      "I need spiritual guidance",
    ];
    return sampleInputs[math.Random().nextInt(sampleInputs.length)];
  }

  Future<void> _respondToInput(String input) async {
    setState(() {
      _isResponding = true;
    });
    
    String response = _generateResponse(input.toLowerCase());
    
    setState(() {
      _response = response;
      _isResponding = false;
    });
    
    _responseController.forward();
    
    // Simulate text-to-speech
    await _speak(response);
  }

  String _generateResponse(String input) {
    if (input.contains("hello")) {
      return "Hello! I'm Nehmya, your spiritual assistant. How can I help you today? 🙏";
    } else if (input.contains("how are you")) {
      return "I'm blessed and ready to serve! I'm here to provide spiritual guidance, Bible verses, and Christian wisdom. What would you like to explore?";
    } else if (input.contains("advice")) {
      return "Here's some spiritual wisdom: Minister from your prayer life and personal walk with God. Personal holiness, private devotion, and closet prayer are key for effective ministry. Remember, God is looking for faithful servants, not perfect people. Stay close to Him! 🌟";
    } else if (input.contains("verse") || input.contains("bible")) {
      List<String> verses = [
        "1 Peter 5:7 - 'Cast all your anxiety on Him because He cares for you.' 💙",
        "2 Timothy 1:7 - 'For God has not given us a spirit of fear, but of power, love, and sound mind.' 💪",
        "Philippians 4:13 - 'I can do all things through Christ who strengthens me.' ⭐",
        "John 3:16 - 'For God so loved the world that He gave His one and only Son.' ❤️",
        "Romans 8:28 - 'All things work together for good to those who love God.' 🙌",
      ];
      return "Here's a verse for you: ${verses[math.Random().nextInt(verses.length)]}";
    } else if (input.contains("singers") || input.contains("music")) {
      return "Some amazing gospel singers include: Lealem Tilahun, Ephrem Alemu, Tesfaye Chala, Bereket Tesfaye, and Kalkidan Tilahun. You can find their beautiful worship songs on YouTube! 🎵";
    } else if (input.contains("preachers")) {
      return "Powerful gospel preachers include: Apostle Zelalem Getachew, Pastor Yared Tilahun, Pastor Abraham Teklemariam, Pastor Dawit Molalign, and Pastor Yonas Tsegaye. Their teachings are available on YouTube! 📖";
    } else if (input.contains("books")) {
      return "Great spiritual books: 'The Practice of the Presence of God' by Brother Lawrence, 'Falling Upward' by Richard Rohr, and 'The Life You've Always Wanted' by John Ortberg. These will deepen your faith journey! 📚";
    } else {
      return "I'm here to help with spiritual guidance, Bible verses, Christian music, and faith-based advice. What specific area would you like to explore? 🤔";
    }
  }

  Future<void> _speak(String text) async {
    // Simulate text-to-speech with visual feedback
    for (int i = 0; i < text.length; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      // Visual speaking indicator would go here
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
          'Nehmya Voice Assistant',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
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
                offset: Offset(0, _floatingAnimation.value),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      key: ValueKey(_isDarkMode),
                      color: _isDarkMode ? Colors.yellow : Colors.orange,
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
                painter: VoiceParticlePainter(
                  particles,
                  _particleAnimation.value,
                  _isDarkMode,
                  _isListening,
                ),
                size: Size.infinite,
              );
            },
          ),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Mode Selector
                  _buildModeSelector(),
                  
                  const SizedBox(height: 40),
                  
                  // Voice Visualizer
                  _buildVoiceVisualizer(),
                  
                  const SizedBox(height: 40),
                  
                  // Status Display
                  _buildStatusDisplay(),
                  
                  const SizedBox(height: 30),
                  
                  // Main Voice Button
                  _buildVoiceButton(),
                  
                  const SizedBox(height: 30),
                  
                  // Control Buttons
                  _buildControlButtons(),
                  
                  const SizedBox(height: 30),
                  
                  // Response Display
                  if (_response.isNotEmpty) _buildResponseDisplay(),
                  
                  const SizedBox(height: 30),
                  
                  // Quick Actions
                  _buildQuickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: modes.length,
        itemBuilder: (context, index) {
          String mode = modes[index];
          IconData icon = modeIcons[index];
          bool isSelected = _currentMode == mode;
          
          return AnimatedBuilder(
            animation: _modeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? 1.0 + (_modeAnimation.value * 0.1) : 1.0,
                child: GestureDetector(
                  onTap: () => _changeMode(mode),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [Colors.purple.shade400, Colors.blue.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : (_isDarkMode ? Colors.grey.shade800 : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Colors.purple.withOpacity(0.3)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: isSelected ? 15 : 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: isSelected ? Colors.white : (_isDarkMode ? Colors.white70 : Colors.grey.shade600),
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mode,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (_isDarkMode ? Colors.white70 : Colors.grey.shade700),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }

  Widget _buildVoiceVisualizer() {
    return Container(
      height: 200,
      width: double.infinity,
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
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              wavePoints,
              _waveAnimation.value,
              _isDarkMode,
              _isListening,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Widget _buildStatusDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          if (_isListening) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mic,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Listening... ${_listeningDuration}s',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          if (_isProcessing) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Processing...',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Text(
            _text,
            style: TextStyle(
              fontSize: 18,
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isListening ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _listen,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isListening
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : [Colors.blue.shade400, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.blue).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: _isListening ? 10 : 5,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.refresh,
          label: 'Reset',
          color: Colors.orange,
          onTap: () {
            setState(() {
              _text = "Press the button and start speaking";
              _response = "";
            });
            _responseController.reset();
            HapticFeedback.lightImpact();
          },
        ),
        _buildControlButton(
          icon: Icons.volume_off,
          label: 'Stop',
          color: Colors.red,
          onTap: () {
            _stopListening();
            // Stop TTS
          },
        ),
        _buildControlButton(
          icon: Icons.help_outline,
          label: 'Help',
          color: Colors.green,
          onTap: () {
            setState(() {
              _response = "I can help with Bible verses, spiritual advice, gospel music, preachers, and Christian books. Just ask me anything! 😊";
            });
            _responseController.forward();
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseDisplay() {
    return AnimatedBuilder(
      animation: _responseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _responseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
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
                    const Icon(
                      Icons.smart_toy,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Nehmya says:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  _response,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.menu_book, 'label': 'Bible Verse', 'action': 'verse'},
      {'icon': Icons.lightbulb, 'label': 'Advice', 'action': 'advice'},
      {'icon': Icons.music_note, 'label': 'Gospel Music', 'action': 'singers'},
      {'icon': Icons.record_voice_over, 'label': 'Preachers', 'action': 'preachers'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: quickActions.map((action) {
            return GestureDetector(
              onTap: () {
                _respondToInput(action['action']);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      action['icon'],
                      color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      action['label'],
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white70 : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "settings",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Voice settings
          },
          child: const Icon(Icons.settings_voice, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "history",
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Voice history
          },
          child: const Icon(Icons.history, color: Colors.white),
        ),
      ],
    );
  }
}

class VoiceParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  
  VoiceParticle() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 1;
    vy = (math.Random().nextDouble() - 0.5) * 1;
    size = math.Random().nextDouble() * 3 + 1;
    opacity = math.Random().nextDouble() * 0.3 + 0.1;
    color = Colors.blue.withOpacity(0.3);
  }
  
  void update(bool isListening) {
    x += vx * (isListening ? 2 : 1);
    y += vy * (isListening ? 2 : 1);
    
    if (x < 0) x = 400;
    if (x > 400) x = 0;
    if (y < 0) y = 800;
    if (y > 800) y = 0;
  }
}

class WavePoint {
  late double x;
  late double baseY;
  late double currentY;
  
  WavePoint(this.x) {
    baseY = 100;
    currentY = baseY;
  }
  
  void update(double time, bool isListening) {
    if (isListening) {
      currentY = baseY + math.sin(time + x * 0.1) * 30 * math.Random().nextDouble();
    } else {
      currentY = baseY + math.sin(time + x * 0.05) * 5;
    }
  }
}

class VoiceParticlePainter extends CustomPainter {
  final List<VoiceParticle> particles;
  final double animationValue;
  final bool isDarkMode;
  final bool isListening;
  
  VoiceParticlePainter(this.particles, this.animationValue, this.isDarkMode, this.isListening);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (var particle in particles) {
      particle.update(isListening);
      
      paint.color = particle.color.withOpacity(
        particle.opacity * (isListening ? 2 : 1),
      );
      
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * (isListening ? 1.5 : 1),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaveformPainter extends CustomPainter {
  final List<WavePoint> wavePoints;
  final double animationValue;
  final bool isDarkMode;
  final bool isListening;
  
  WaveformPainter(this.wavePoints, this.animationValue, this.isDarkMode, this.isListening);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isListening ? Colors.red.withOpacity(0.6) : Colors.blue.withOpacity(0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    for (int i = 0; i < wavePoints.length; i++) {
      wavePoints[i].update(animationValue, isListening);
      
      double x = (i / wavePoints.length) * size.width;
      double y = wavePoints[i].currentY;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw additional wave layers
    for (int layer = 1; layer <= 3; layer++) {
      paint.color = (isListening ? Colors.red : Colors.blue)
          .withOpacity(0.2 / layer);
      
      final layerPath = Path();
      for (int i = 0; i < wavePoints.length; i++) {
        double x = (i / wavePoints.length) * size.width;
        double y = wavePoints[i].currentY + (layer * 10);
        
        if (i == 0) {
          layerPath.moveTo(x, y);
        } else {
          layerPath.lineTo(x, y);
        }
      }
      canvas.drawPath(layerPath, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
