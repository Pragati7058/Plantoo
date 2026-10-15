import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _handleAuth() async {
    HapticFeedback.lightImpact();
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (!_isLogin && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting ${_isLogin ? "login" : "register"} request...');
      Map<String, dynamic> result;
      
      if (_isLogin) {
        result = await AuthService.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        result = await AuthService.register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      }

      print('Auth result: $result');

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Authentication failed')),
          );
        }
      }
    } catch (e) {
      print('Auth error: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/leaves.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.deepestBackground.withValues(alpha: 0.7),
                AppColors.deepestBackground.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Plantoo',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin ? 'Welcome back!' : 'Create account',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.lightText.withValues(alpha: 0.7),
                            ),
                      ),
                      const SizedBox(height: 32),
                      if (!_isLogin) ...[
                        GlassTextField(
                          hintText: 'Full Name',
                          controller: _nameController,
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                      ],
                      GlassTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      GlassButton(
                        text: _isLoading ? 'Signing in...' : (_isLogin ? 'Login' : 'Sign Up'),
                        onPressed: _isLoading ? () {} : _handleAuth,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? 'Don\'t have an account? '
                                : 'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.lightText.withValues(alpha: 0.6),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleAuthMode,
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Login',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
