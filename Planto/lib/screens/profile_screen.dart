import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await AuthService.getCurrentUser();
      print('Profile load result: $result'); // Debug log
      
      if (result['success'] == true && result['user'] != null) {
        setState(() {
          _currentUser = User.fromJson(result['user']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load user data';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Profile load error: $e'); // Debug log
      setState(() {
        _errorMessage = 'Error loading profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: AnimatedBlobBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 24),
                      _buildMenuItems(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          HapticFeedback.lightImpact();
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.glassOverlay(opacity: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.glassBorder(opacity: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppColors.lightText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_isLoading) {
      return const GlassCard(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Error loading profile',
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_currentUser == null) {
      return const GlassCard(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No user data available',
            style: TextStyle(
              color: AppColors.lightText,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _currentUser!.avatarUrl.isNotEmpty
                ? Image.network(
                    _currentUser!.avatarUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser!.name,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentUser!.email,
                  style: TextStyle(
                    color: AppColors.lightText.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Icon(
        Icons.person,
        color: AppColors.deepestBackground,
        size: 40,
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.shopping_bag, 'title': 'My Orders', 'route': '/orders'},
      {'icon': Icons.location_on, 'title': 'Addresses', 'route': '/addresses'},
      {'icon': Icons.payment, 'title': 'Payment Methods', 'route': '/payment'},
      {'icon': Icons.notifications, 'title': 'Notifications', 'route': '/notifications'},
      {'icon': Icons.help, 'title': 'Help & Support', 'route': '/help'},
      {'icon': Icons.info, 'title': 'About', 'route': '/about'},
      {'icon': Icons.logout, 'title': 'Logout', 'action': 'logout'},
    ];

    return Column(
      children: menuItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            onTap: () {
              HapticFeedback.lightImpact();
              if (item['action'] == 'logout') {
                _handleLogout();
              } else if (item['route'] != null) {
                Navigator.pushNamed(context, item['route'] as String);
              }
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.glassOverlay(opacity: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['action'] == 'logout' 
                        ? Colors.red 
                        : AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: item['action'] == 'logout' 
                          ? Colors.red 
                          : AppColors.lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (item['action'] != 'logout')
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.lightText,
                    size: 16,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/plants');
        break;
      case 2:
        Navigator.pushNamed(context, '/care');
        break;
      case 3:
        Navigator.pushNamed(context, '/wishlist');
        break;
    }
  }
}
