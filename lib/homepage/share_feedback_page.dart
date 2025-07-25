import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ShareFeedbackPage extends StatefulWidget {
  const ShareFeedbackPage({super.key});

  @override
  State<ShareFeedbackPage> createState() => _ShareFeedbackPageState();
}

class _ShareFeedbackPageState extends State<ShareFeedbackPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedFeedbackType = 'General';
  int _rating = 0;
  bool _isSubmitting = false;
  bool _showThankYou = false;
  bool _isDarkMode = true;
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _ratingController;
  late AnimationController _submitController;
  late AnimationController _thankYouController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _ratingAnimation;
  late Animation<double> _submitAnimation;
  late Animation<double> _thankYouAnimation;
  late Animation<double> _floatingAnimation;
  
  List<FeedbackParticle> particles = [];
  List<String> feedbackTypes = ['General', 'Suggestion', 'Issue', 'Praise', 'Feature Request', 'Bug Report'];
  List<IconData> feedbackIcons = [
    Icons.chat_bubble_outline,
    Icons.lightbulb_outline,
    Icons.error_outline,
    Icons.favorite_outline,
    Icons.add_circle_outline,
    Icons.bug_report_outlined,
  ];

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
      duration: const Duration(seconds: 8),
    )..repeat();
    
    _ratingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _thankYouController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
    
    _ratingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ratingController, curve: Curves.elasticOut),
    );
    
    _submitAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _submitController, curve: Curves.easeInOut),
    );
    
    _thankYouAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _thankYouController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _mainController.forward();
  }

  void _generateParticles() {
    particles = List.generate(30, (index) => FeedbackParticle());
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mainController.dispose();
    _particleController.dispose();
    _ratingController.dispose();
    _submitController.dispose();
    _thankYouController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
    _ratingController.forward().then((_) {
      _ratingController.reverse();
    });
    HapticFeedback.selectionClick();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      _submitController.forward();
      HapticFeedback.mediumImpact();
      
      // Simulate submission
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isSubmitting = false;
        _showThankYou = true;
      });
      
      _thankYouController.forward();
      _generateConfetti();
      
      // Clear form
      _feedbackController.clear();
      _nameController.clear();
      _emailController.clear();
      setState(() {
        _selectedFeedbackType = 'General';
        _rating = 0;
      });
      
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        setState(() {
          _showThankYou = false;
        });
        _thankYouController.reset();
      }
    }
  }

  void _generateConfetti() {
    for (int i = 0; i < 50; i++) {
      particles.add(FeedbackParticle(isConfetti: true));
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
          'Share Feedback',
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
                painter: FeedbackParticlePainter(particles, _rotationAnimation.value, _isDarkMode),
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
                      // Header Section
                      AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value * 0.5),
                            child: _buildHeader(),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Feedback Type Selection
                      _buildFeedbackTypeSelector(),
                      
                      const SizedBox(height: 30),
                      
                      // Rating Section
                      _buildRatingSection(),
                      
                      const SizedBox(height: 30),
                      
                      // Form Section
                      _buildFormSection(),
                      
                      const SizedBox(height: 30),
                      
                      // Submit Button
                      _buildSubmitButton(),
                      
                      const SizedBox(height: 30),
                      
                      // Contact Section
                      _buildContactSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Thank You Overlay
          if (_showThankYou)
            AnimatedBuilder(
              animation: _thankYouAnimation,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(0.8 * _thankYouAnimation.value),
                  child: Center(
                    child: Transform.scale(
                      scale: _thankYouAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(40),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade400, Colors.blue.shade400],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 80,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Thank You!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Your feedback means the world to us! 🌟',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'We\'ll use it to make our app even better!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
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
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.purple.shade800, Colors.blue.shade800]
              : [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.purple : Colors.blue).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.feedback,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'We Value Your Feedback',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Help us improve by sharing your thoughts!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of feedback do you have?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: feedbackTypes.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              bool isSelected = _selectedFeedbackType == type;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFeedbackType = type;
                  });
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Colors.blue.shade400, Colors.purple.shade400],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        feedbackIcons[index],
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How would you rate your experience?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _ratingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_ratingAnimation.value * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => _setRating(index + 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: index < _rating ? Colors.amber : Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          if (_rating > 0) ...[
            const SizedBox(height: 15),
            Text(
              _getRatingText(_rating),
              style: TextStyle(
                fontSize: 16,
                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'We\'re sorry to hear that. We\'ll do better!';
      case 2:
        return 'Thanks for the feedback. We\'ll improve!';
      case 3:
        return 'Good to know. We appreciate your input!';
      case 4:
        return 'Great! We\'re glad you had a good experience!';
      case 5:
        return 'Awesome! Thank you for the amazing feedback!';
      default:
        return '';
    }
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us more',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildAnimatedTextField(
              controller: _nameController,
              label: 'Your Name (Optional)',
              icon: Icons.person_outline,
              validator: null,
            ),
            const SizedBox(height: 20),
            _buildAnimatedTextField(
              controller: _emailController,
              label: 'Your Email (Optional)',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildAnimatedTextField(
              controller: _feedbackController,
              label: 'Your Feedback',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please share your feedback';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: validator,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  icon,
                  color: _isDarkMode ? Colors.purple.shade300 : Colors.blue.shade400,
                ),
                filled: true,
                fillColor: _isDarkMode
                    ? Colors.grey.shade800.withOpacity(0.5)
                    : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: _isDarkMode ? Colors.purple : Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _submitAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: _isSubmitting ? null : _submitFeedback,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [Colors.purple.shade600, Colors.blue.shade600]
                    : [Colors.blue.shade400, Colors.purple.shade400],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: (_isDarkMode ? Colors.purple : Colors.blue).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _isSubmitting
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Sending Feedback...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [Colors.grey.shade100, Colors.grey.shade200],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 50,
            color: _isDarkMode ? Colors.white : Colors.grey.shade700,
          ),
          const SizedBox(height: 15),
          Text(
            'Need Direct Assistance?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Reach us at ',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                TextSpan(
                  text: 'mimneh@gmail.com',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('mailto:mimneh@gmail.com'));
                    },
                ),
                TextSpan(
                  text: ' or call ',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                TextSpan(
                  text: '+251 901723123',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('tel:+251901723123'));
                    },
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "quick_feedback",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Quick feedback functionality
          },
          child: const Icon(Icons.flash_on, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "voice_feedback",
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Voice feedback functionality
          },
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      ],
    );
  }
}

class FeedbackParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  late bool isConfetti;
  
  FeedbackParticle({this.isConfetti = false}) {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 2;
    vy = (math.Random().nextDouble() - 0.5) * 2;
    size = math.Random().nextDouble() * 3 + 1;
    opacity = math.Random().nextDouble() * 0.4 + 0.1;
    
    if (isConfetti) {
      color = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
      ][math.Random().nextInt(7)];
      vy = math.Random().nextDouble() * 5 + 2;
      size = math.Random().nextDouble() * 6 + 2;
    } else {
      color = Colors.blue.withOpacity(0.3);
    }
  }
  
  void update() {
    x += vx;
    y += vy;
    
    if (isConfetti) {
      vy += 0.1; // Gravity
    }
    
    // Wrap around screen
    if (x < 0) x = 400;
    if (x > 400) x = 0;
    if (y < 0) y = 800;
    if (y > 800) y = 0;
  }
}

class FeedbackParticlePainter extends CustomPainter {
  final List<FeedbackParticle> particles;
  final double animationValue;
  final bool isDarkMode;
  
  FeedbackParticlePainter(this.particles, this.animationValue, this.isDarkMode);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (var particle in particles) {
      particle.update();
      
      paint.color = particle.color.withOpacity(particle.opacity);
      
      if (particle.isConfetti) {
        // Draw confetti as rectangles
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(particle.x, particle.y),
            width: particle.size * 2,
            height: particle.size,
          ),
          paint,
        );
      } else {
        // Draw regular particles as circles
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
