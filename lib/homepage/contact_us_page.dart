import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'dart:async';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with TickerProviderStateMixin {
  bool _isDarkMode = true; // Default to dark mode
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _socialController;
  late AnimationController _formController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _socialAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  
  List<ContactParticle> particles = [];
  List<SocialPlatform> socialPlatforms = [];
  Timer? _typingTimer;
  String _typingText = "";
  int _typingIndex = 0;
  
  final List<String> _typingMessages = [
    "We'd love to hear from you! 💬",
    "Connect with us today! 🌟",
    "Your message matters to us! ❤️",
    "Let's start a conversation! 🚀",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _initializeSocialPlatforms();
    _startTypingAnimation();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    
    _socialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    
    _socialAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _socialController, curve: Curves.elasticOut),
    );
    
    _formAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _mainController.forward();
    _socialController.forward();
    _formController.forward();
  }

  void _generateParticles() {
    particles = List.generate(35, (index) => ContactParticle());
  }

  void _initializeSocialPlatforms() {
    socialPlatforms = [
      SocialPlatform(
        icon: FontAwesomeIcons.facebook,
        name: 'Facebook',
        color: const Color(0xFF1877F2),
        url: 'https://www.facebook.com/Nehmya-Biruk',
        description: 'Follow our daily updates',
      ),
      SocialPlatform(
        icon: FontAwesomeIcons.instagram,
        name: 'Instagram',
        color: const Color(0xFFE4405F),
        url: 'https://www.instagram.com/nehmya_biruk/',
        description: 'See our visual journey',
      ),
      SocialPlatform(
        icon: FontAwesomeIcons.twitter,
        name: 'Twitter',
        color: const Color(0xFF1DA1F2),
        url: 'https://www.twitter.com',
        description: 'Join the conversation',
      ),
      SocialPlatform(
        icon: FontAwesomeIcons.youtube,
        name: 'YouTube',
        color: const Color(0xFFFF0000),
        url: 'https://www.youtube.com',
        description: 'Watch our content',
      ),
      SocialPlatform(
        icon: FontAwesomeIcons.telegram,
        name: 'Telegram',
        color: const Color(0xFF0088CC),
        url: 'https://t.me/nehmy_biruk',
        description: 'Get instant updates',
      ),
      SocialPlatform(
        icon: FontAwesomeIcons.whatsapp,
        name: 'WhatsApp',
        color: const Color(0xFF25D366),
        url: 'https://wa.me/251901723123',
        description: 'Direct messaging',
      ),
    ];
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_typingIndex < _typingMessages.length) {
        String currentMessage = _typingMessages[_typingIndex];
        if (_typingText.length < currentMessage.length) {
          setState(() {
            _typingText = currentMessage.substring(0, _typingText.length + 1);
          });
        } else {
          Timer(const Duration(seconds: 2), () {
            setState(() {
              _typingText = "";
              _typingIndex = (_typingIndex + 1) % _typingMessages.length;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _socialController.dispose();
    _formController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _typingTimer?.cancel();
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
          'Contact Us',
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
                offset: Offset(0, _floatingAnimation.value * 0.5),
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
                painter: ContactParticlePainter(
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
                      // Header Section
                      AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value * 0.3),
                            child: _buildHeader(),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Contact Methods
                      _buildContactMethods(),
                      
                      const SizedBox(height: 40),
                      
                      // Social Media Section
                      _buildSocialMediaSection(),
                      
                      const SizedBox(height: 40),
                      
                      // Contact Form
                      _buildContactForm(),
                      
                      const SizedBox(height: 40),
                      
                      // Quick Contact Options
                      _buildQuickContactOptions(),
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
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.purple.shade800, Colors.blue.shade800, Colors.teal.shade800]
              : [Colors.purple.shade400, Colors.blue.shade400, Colors.teal.shade400],
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
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(
                    Icons.contact_support,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            _typingText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Ready to connect? We\'re here 24/7!',
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

  Widget _buildContactMethods() {
    List<ContactMethod> methods = [
      ContactMethod(
        icon: Icons.email,
        title: 'Email Us',
        subtitle: 'mimneh@gmail.com',
        color: Colors.red,
        action: () => _launchURL('mailto:mimneh@gmail.com'),
      ),
      ContactMethod(
        icon: Icons.phone,
        title: 'Call Us',
        subtitle: '+251 901723123',
        color: Colors.green,
        action: () => _launchURL('tel:+251901723123'),
      ),
      ContactMethod(
        icon: Icons.location_on,
        title: 'Visit Us',
        subtitle: 'Addis Ababa, Ethiopia',
        color: Colors.orange,
        action: () => _launchURL('https://maps.google.com/?q=Addis+Ababa,Ethiopia'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get In Touch',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        ...methods.asMap().entries.map((entry) {
          int index = entry.key;
          ContactMethod method = entry.value;
          
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 800 + (index * 200)),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: method.action,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? Colors.grey.shade900.withOpacity(0.8)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: method.color.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: method.color.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: method.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: method.color.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                method.icon,
                                color: method.color,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    method.subtitle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: method.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: method.color,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return AnimatedBuilder(
      animation: _socialAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _socialAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow Us On Social Media',
                style: TextStyle(
                  fontSize: 24,
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
                  childAspectRatio: 1.2,
                ),
                itemCount: socialPlatforms.length,
                itemBuilder: (context, index) {
                  SocialPlatform platform = socialPlatforms[index];
                  
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: GestureDetector(
                          onTap: () => _launchURL(platform.url),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  platform.color.withOpacity(0.8),
                                  platform.color.withOpacity(0.6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: platform.color.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  platform.icon,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  platform.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  platform.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactForm() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Container(
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
              child: const ContactForm(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickContactOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
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
                icon: Icons.schedule,
                title: 'Schedule Call',
                color: Colors.blue,
                onTap: () => _launchURL('tel:+251901723123'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildQuickAction(
                icon: Icons.chat,
                title: 'Live Chat',
                color: Colors.green,
                onTap: () => _launchURL('https://wa.me/251901723123'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          heroTag: "emergency",
          mini: true,
          backgroundColor: Colors.red,
          onPressed: () {
            HapticFeedback.mediumImpact();
            _launchURL('tel:+251901723123');
          },
          child: const Icon(Icons.emergency, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "location",
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {
            HapticFeedback.mediumImpact();
            _launchURL('https://maps.google.com/?q=Addis+Ababa,Ethiopia');
          },
          child: const Icon(Icons.location_on, color: Colors.white),
        ),
      ],
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      HapticFeedback.mediumImpact();
      
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Message sent successfully! 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _nameController,
            label: 'Your Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _emailController,
            label: 'Your Email',
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
          const SizedBox(height: 15),
          _buildTextField(
            controller: _messageController,
            label: 'Your Message',
            icon: Icons.message_outlined,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Message cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: _isSubmitting
                  ? const Row(
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
                        SizedBox(width: 10),
                        Text(
                          'Sending...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Send Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}

// Data Classes
class ContactMethod {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback action;

  ContactMethod({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.action,
  });
}

class SocialPlatform {
  final IconData icon;
  final String name;
  final Color color;
  final String url;
  final String description;

  SocialPlatform({
    required this.icon,
    required this.name,
    required this.color,
    required this.url,
    required this.description,
  });
}

class ContactParticle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late Color color;
  late double opacity;
  
  ContactParticle() {
    x = math.Random().nextDouble() * 400;
    y = math.Random().nextDouble() * 800;
    vx = (math.Random().nextDouble() - 0.5) * 1;
    vy = (math.Random().nextDouble() - 0.5) * 1;
    size = math.Random().nextDouble() * 3 + 1;
    opacity = math.Random().nextDouble() * 0.3 + 0.1;
    color = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.green,
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

class ContactParticlePainter extends CustomPainter {
  final List<ContactParticle> particles;
  final double animationValue;
  final bool isDarkMode;
  
  ContactParticlePainter(this.particles, this.animationValue, this.isDarkMode);
  
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
