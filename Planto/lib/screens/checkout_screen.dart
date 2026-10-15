import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/animated_blob.dart';
import '../services/cart_service.dart';
import '../services/payment_service.dart';
import '../services/address_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0;
  final Razorpay _razorpay = Razorpay();
  Map<String, dynamic>? _cartData;
  List<dynamic> _addresses = [];
  Map<String, dynamic>? _selectedAddress;
  bool _isLoading = true;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _loadData();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final cartResponse = await CartService.getCart();
    final addressResponse = await AddressService.getAddresses();
    
    setState(() {
      _isLoading = false;
      if (cartResponse['success'] == true) {
        _cartData = cartResponse;
      }
      if (addressResponse['success'] == true) {
        _addresses = addressResponse['data'] ?? [];
        _selectedAddress = _addresses.firstWhere(
          (addr) => addr['isDefault'] == true,
          orElse: () => _addresses.isNotEmpty ? _addresses[0] : null,
        );
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => _isProcessingPayment = false);
    
    if (_selectedAddress != null && response.orderId != null && response.paymentId != null && response.signature != null) {
      _verifyPayment(
        response.orderId!,
        response.paymentId!,
        response.signature!,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );
  }

  Future<void> _verifyPayment(String orderId, String paymentId, String signature) async {
    final shippingAddress = {
      'street': _selectedAddress!['street'],
      'city': _selectedAddress!['city'],
      'state': _selectedAddress!['state'],
      'zipCode': _selectedAddress!['zipCode'],
      'country': _selectedAddress!['country'],
      'phone': _selectedAddress!['phone'],
    };

    final response = await PaymentService.verifyPayment(
      razorpayOrderId: orderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: signature,
      shippingAddress: shippingAddress,
    );

    if (response['success'] == true) {
      final orderData = response['data'];
      Navigator.pushNamed(
        context,
        '/order-tracking',
        arguments: orderData['_id'],
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Payment verification failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _initiatePayment() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a shipping address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_cartData == null || (_cartData!['count'] ?? 0) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    final response = await PaymentService.createRazorpayOrder();
    
    if (response['success'] == true) {
      final orderData = response['data'];
      final options = {
        'key': 'rzp_test_demo_key', // Replace with your Razorpay key
        'amount': orderData['amount'],
        'name': 'Planto',
        'description': 'Plant Purchase',
        'order_id': orderData['id'],
        'prefill': {
          'contact': '',
          'email': '',
        },
        'theme': {
          'color': '#4CAF50',
        },
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        setState(() => _isProcessingPayment = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening payment: $e')),
        );
      }
    } else {
      setState(() => _isProcessingPayment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to create payment order'),
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
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildShippingAddress(),
                    const SizedBox(height: 24),
                    _buildPaymentMethod(),
                    const SizedBox(height: 24),
                    _buildOrderSummary(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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
            'Checkout',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/addresses').then((_) => _loadData());
                },
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedAddress != null) ...[
            Text(
              '${_selectedAddress!['street']}',
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_selectedAddress!['city']}, ${_selectedAddress!['state']} ${_selectedAddress!['zipCode']}\n${_selectedAddress!['country']}',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_selectedAddress!['phone']}',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ] else ...[
            Text(
              'No address selected',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/addresses').then((_) => _loadData());
              },
              child: const Text(
                'Add Address',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    final paymentMethods = [
      {'icon': Icons.payment, 'title': 'Razorpay', 'subtitle': 'UPI, Cards, Wallets'},
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...paymentMethods.asMap().entries.map((entry) {
            final index = entry.key;
            final method = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedPaymentMethod = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedPaymentMethod == index
                        ? AppColors.glassOverlay(opacity: 0.2)
                        : AppColors.glassOverlay(opacity: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedPaymentMethod == index
                          ? AppColors.accent
                          : AppColors.glassBorder(opacity: 0.3),
                      width: _selectedPaymentMethod == index ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.glassOverlay(opacity: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          method['icon'] as IconData,
                          color: AppColors.accent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['title'] as String,
                              style: const TextStyle(
                                color: AppColors.lightText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method['subtitle'] as String,
                              style: TextStyle(
                                color: AppColors.lightText.withValues(alpha: 0.6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedPaymentMethod == index)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.accent,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final total = _cartData?['total'] ?? 0;
    final count = _cartData?['count'] ?? 0;
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal ($count items)', '₹${total.toStringAsFixed(2)}'),
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

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.lightText.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.lightText,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final total = _cartData?['total'] ?? 0;
    
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
        text: _isProcessingPayment 
            ? 'Processing...' 
            : 'Place Order - ₹${total.toStringAsFixed(2)}',
        onPressed: _isProcessingPayment ? () {} : () {
          HapticFeedback.lightImpact();
          _initiatePayment();
        },
        width: double.infinity,
      ),
    );
  }
}
