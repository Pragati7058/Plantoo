import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../services/cart_service.dart';
import '../services/promo_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _cartItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  double _subtotal = 0;
  double _discount = 0;
  String? _appliedPromoCode;
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await CartService.getCart();

    if (response['success'] == true) {
      setState(() {
        _cartItems = response['items'] ?? [];
        _subtotal = response['total'] ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = response['message'] ?? 'Failed to load cart';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(String itemId, int quantity) async {
    final response = await CartService.updateCartItem(itemId: itemId, quantity: quantity);
    if (response['success'] == true) {
      await _loadCart();
    }
  }

  Future<void> _removeItem(String itemId) async {
    final response = await CartService.removeFromCart(itemId);
    if (response['success'] == true) {
      await _loadCart();
    }
  }

  Future<void> _applyPromoCode() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a promo code')),
      );
      return;
    }

    final response = await PromoService.validatePromoCode(
      code: code,
      orderAmount: _subtotal,
    );

    if (response['success'] == true) {
      setState(() {
        _appliedPromoCode = code;
        _discount = response['data']['discountAmount'] ?? 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied! Saved ₹${_discount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Invalid promo code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: AnimatedBlobBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: AppColors.lightText),
                                ),
                                const SizedBox(height: 16),
                                GlassButton(
                                  text: 'Retry',
                                  onPressed: _loadCart,
                                ),
                              ],
                            ),
                          )
                        : _cartItems.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
          
                
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 64,
                                      color: AppColors.lightText.withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Your cart is empty',
                                      style: TextStyle(
                                        color: AppColors.lightText.withValues(alpha: 0.5),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  ..._cartItems.map((item) => _buildCartItem(item)),
                                  const SizedBox(height: 16),
                                  _buildPromoCode(),
                                  const SizedBox(height: 16),
                                  _buildOrderSummary(),
                                  const SizedBox(height: 100),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomBar(),
          GlassBottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              HapticFeedback.lightImpact();
              _handleNavigation(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
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
                Icons.arrow_back,
                color: AppColors.lightText,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'My Cart',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(item) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item['imageUrl'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: AppColors.secondarySurface,
                  child: const Icon(Icons.eco, color: AppColors.accent),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['plantName'] ?? 'Unknown Plant',
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(item['price'] ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildQuantityStepper(item),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _removeItem(item['_id']);
                },
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.lightText,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(item) {
    final quantity = item['quantity'] ?? 1;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassOverlay(opacity: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.glassBorder(opacity: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (quantity > 1) {
                _updateQuantity(item['_id'], quantity - 1);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.remove,
                color: AppColors.lightText,
                size: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _updateQuantity(item['_id'], quantity + 1);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.add,
                color: AppColors.lightText,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCode() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GlassTextField(
                  hintText: _appliedPromoCode != null ? 'Applied: $_appliedPromoCode' : 'Enter promo code',
                  controller: _promoController,
                  enabled: _appliedPromoCode == null,
                ),
              ),
              const SizedBox(width: 12),
              if (_appliedPromoCode == null)
                GestureDetector(
                  onTap: _applyPromoCode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryButtonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.deepestBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _appliedPromoCode = null;
                      _discount = 0;
                      _promoController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_discount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Discount applied: -₹${_discount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    const shipping = 0;
    final total = _subtotal - _discount + shipping;
    final itemCount = _cartItems.length;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal ($itemCount items)', '₹${_subtotal.toStringAsFixed(2)}'),
          if (_discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow('Discount', '-₹${_discount.toStringAsFixed(2)}', isDiscount: true),
          ],
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', 'FREE'),
          const Divider(height: 24, color: AppColors.elevatedSurface),
          _buildSummaryRow(
            'Total',
            '₹${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDiscount ? Colors.green : AppColors.lightText.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.green : AppColors.lightText,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.deepestBackground.withValues(alpha: 0),
            AppColors.deepestBackground,
          ],
        ),
      ),
      child: GlassButton(
        text: 'Proceed to Checkout',
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/checkout');
        },
        width: double.infinity,
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/plants');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/care');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
