import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _cardController;
  late AnimationController _successController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _successAnimation;
  late Animation<double> _floatingAnimation;
  
  bool _isPasswordVisible = false;
  bool _isRegistering = false;
  bool _showSuccess = false;
  bool _isDarkMode = false;
  int _currentStep = 0;
  List<Particle> particles = [];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
  }
  
  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _particleController,
    );
    
    _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
      _particleController,
    );
    
    _cardFlipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
    
    _successAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _mainController.forward();
  }
  
  void _generateParticles() {
    particles = List.generate(50, (index) => Particle());
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _mainController.dispose();
    _particleController.dispose();
    _cardController.dispose();
    _successController.dispose();
    _floatingController.dispose();
    super.dispose();
  }
  
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    HapticFeedback.lightImpact();
  }
  
  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _cardController.forward().then((_) {
        _cardController.reverse();
      });
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _cardController.forward().then((_) {
        _cardController.reverse();
      });
    }
  }
  
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = true;
      });
      
      HapticFeedback.mediumImpact();
      
      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isRegistering = false;
        _showSuccess = true;
      });
      
      _successController.forward();
      
      // Show confetti effect
      _showConfetti();
      
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
  
  void _showConfetti() {
    // Add confetti particles
    for (int i = 0; i < 30; i++) {
      particles.add(Particle(isConfetti: true));
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
            animation: _particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particles, _particleAnimation.value, _isDarkMode),
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
                      // Floating Profile Section
                      AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: _buildProfileHeader(),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Progress Indicator
                      _buildProgressIndicator(),
                      
                      const SizedBox(height: 30),
                      
                      // Form Card with 3D Effect
                      AnimatedBuilder(
                        animation: _cardFlipAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_cardFlipAnimation.value * 0.1),
                            child: _buildFormCard(),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Navigation Buttons
                      _buildNavigationButtons(),
                      
                      const SizedBox(height: 20),
                      
                      // Social Login Options
                      _buildSocialLogin(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Success Overlay
          if (_showSuccess)
            AnimatedBuilder(
              animation: _successAnimation,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(0.8 * _successAnimation.value),
                  child: Center(
                    child: Transform.scale(
                      scale: _successAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                              Icons.check_circle,
                              color: Colors.green,
                              size: 80,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Account Created!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Welcome to our amazing community! 🎉',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
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
  
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.purple.shade800, Colors.blue.shade800]
              : [Colors.purple.shade400, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
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
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Camera functionality would go here
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Create Your Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join our amazing community today!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = index <= _currentStep;
        bool isCompleted = index < _currentStep;
        
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (_isDarkMode ? Colors.purple : Colors.blue)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green
                          : (isActive
                              ? (_isDarkMode ? Colors.purple : Colors.blue)
                              : Colors.grey.shade300),
                      shape: BoxShape.circle,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey.shade900.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              _getStepTitle(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            ..._buildStepContent(),
          ],
        ),
      ),
    );
  }
  
  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Personal Info';
      case 1:
        return 'Account Details';
      case 2:
        return 'Verification';
      default:
        return 'Create Account';
    }
  }
  
  List<Widget> _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return [
          _buildAnimatedTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildAnimatedTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
        ];
      case 1:
        return [
          _buildAnimatedTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildAnimatedTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: _isDarkMode ? Colors.white70 : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
                HapticFeedback.lightImpact();
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ];
      case 2:
        return [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (_isDarkMode ? Colors.green.shade800 : Colors.green.shade50),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified_user,
                  size: 60,
                  color: Colors.green,
                ),
                const SizedBox(height: 15),
                Text(
                  'Ready to Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'All information has been verified. Click the button below to complete your registration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ];
      default:
        return [];
    }
  }
  
  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
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
                  suffixIcon: suffixIcon,
                  filled: true,
                  fillColor: _isDarkMode
                      ? Colors.grey.shade800.withOpacity(0.5)
                      : Colors.white,
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
                      color: Colors.grey.withOpacity(0.2),
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
          ),
        );
      },
    );
  }
  
  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: _buildAnimatedButton(
              onPressed: _previousStep,
              text: 'Previous',
              isPrimary: false,
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 15),
        Expanded(
          child: _buildAnimatedButton(
            onPressed: _currentStep == 2 ? _register : _nextStep,
            text: _currentStep == 2 ? 'Create Account' : 'Next',
            isPrimary: true,
            isLoading: _isRegistering,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required String text,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: GestureDetector(
            onTap: isLoading ? null : onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: isPrimary
                    ? LinearGradient(
                        colors: _isDarkMode
                            ? [Colors.purple.shade600, Colors.blue.shade600]
                            : [Colors.blue.shade400, Colors.purple.shade400],
                      )
                    : null,
                color: isPrimary ? null : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isPrimary
                    ? [
                        BoxShadow(
                          color: (_isDarkMode ? Colors.purple : Colors.blue)
                              .withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isPrimary
                              ? Colors.white
                              : (_isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade400)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade400)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSocialButton(Icons.g_mobiledata, 'Google', Colors.red)),
            const SizedBox(width: 15),
            Expanded(child: _buildSocialButton(Icons.facebook, 'Facebook', Colors.blue)),
            const SizedBox(width: 15),
            Expanded(child: _buildSocialButton(Icons.apple, 'Apple', Colors.black)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Social login functionality would go here
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "voice",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // Voice input functionality would go here
          },
          child: const Icon(Icons.mic, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "scan",
          mini: true,
          backgroundColor: Colors.green,
          onPressed: () {
            HapticFeedback.mediumImpact();
            // QR code scan functionality would go here
          },
          child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
      ],
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  late bool isConfetti;
  
  Particle({this.isConfetti = false}) {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 2;
    vy = (math.Random().nextDouble() - 0.5) * 2;
    size = math.Random().nextDouble() * 4 + 1;
    opacity = math.Random().nextDouble() * 0.5 + 0.1;
    
    if (isConfetti) {
      color = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
      ][math.Random().nextInt(6)];
      vy = math.Random().nextDouble() * 5 + 2;
    } else {
      color = Colors.white;
    }
  }
  
  void update() {
    x += vx;
    y += vy;
    
    if (isConfetti) {
      vy += 0.1; // Gravity for confetti
    }
    
    // Wrap around screen
    if (x < 0) x = 400;
    if (x > 400) x = 0;
    if (y < 0) y = 800;
    if (y > 800) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final bool isDarkMode;
  
  ParticlePainter(this.particles, this.animationValue, this.isDarkMode);
  
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
