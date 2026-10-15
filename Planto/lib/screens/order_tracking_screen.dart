import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Map<String, dynamic>? order;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() => isLoading = true);
    final response = await OrderService.getOrderById(widget.orderId);
    setState(() {
      isLoading = false;
      if (response['success'] == true) {
        order = response['data'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Order Tracking'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : order == null
              ? _buildErrorState()
              : _buildOrderDetails(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 64,
            color: AppTheme.darkTheme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          const Text('Failed to load order details'),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    final status = order?['status'] ?? 'pending';
    final tracking = order?['tracking'] ?? {};
    final trackingHistory = tracking['trackingHistory'] ?? [];
    final paymentInfo = order?['paymentInfo'] ?? {};
    final items = order?['items'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(status),
          const SizedBox(height: 24),
          _buildTrackingInfo(tracking),
          const SizedBox(height: 24),
          _buildTrackingTimeline(trackingHistory),
          const SizedBox(height: 24),
          _buildOrderItems(items),
          const SizedBox(height: 24),
          _buildPaymentInfo(paymentInfo),
          const SizedBox(height: 24),
          _buildShippingAddress(),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    final statusColors = {
      'pending': Colors.orange,
      'processing': Colors.blue,
      'shipped': Colors.purple,
      'delivered': Colors.green,
      'cancelled': Colors.red,
    };

    final statusIcons = {
      'pending': LucideIcons.clock,
      'processing': LucideIcons.package,
      'shipped': LucideIcons.truck,
      'delivered': LucideIcons.checkCircle,
      'cancelled': LucideIcons.xCircle,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColors[status] ?? Colors.grey,
            (statusColors[status] ?? Colors.grey).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                statusIcons[status] ?? LucideIcons.clock,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order #${order?['_id']?.toString().substring(0, 8) ?? 'N/A'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getStatusMessage(status),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'pending':
        return 'Your order is waiting to be processed';
      case 'processing':
        return 'Your order is being prepared for shipment';
      case 'shipped':
        return 'Your order is on the way';
      case 'delivered':
        return 'Your order has been delivered';
      case 'cancelled':
        return 'Your order has been cancelled';
      default:
        return 'Order status unknown';
    }
  }

  Widget _buildTrackingInfo(Map<String, dynamic> tracking) {
    final trackingNumber = tracking['trackingNumber'] ?? 'N/A';
    final carrier = tracking['carrier'] ?? 'N/A';
    final estimatedDelivery = tracking['estimatedDelivery'];
    final currentLocation = tracking['currentLocation'] ?? 'Unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.scan,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tracking Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTrackingRow('Tracking Number', trackingNumber),
            _buildTrackingRow('Carrier', carrier),
            _buildTrackingRow('Current Location', currentLocation),
            if (estimatedDelivery != null)
              _buildTrackingRow(
                'Estimated Delivery',
                DateFormat('MMM dd, yyyy').format(DateTime.parse(estimatedDelivery)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(List<dynamic> history) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.history,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tracking History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              const Text('No tracking history available')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final event = history[index];
                  return _buildTimelineItem(event, index == history.length - 1);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> event, bool isLast) {
    final timestamp = event['timestamp'];
    final status = event['status'] ?? 'Unknown';
    final location = event['location'] ?? 'Unknown';
    final description = event['description'] ?? '';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppTheme.darkTheme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (timestamp != null)
                    Text(
                      DateFormat('MMM dd, yyyy - HH:mm').format(DateTime.parse(timestamp)),
                      style: TextStyle(
                        color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(List<dynamic> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.shoppingBag,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildOrderItem(item);
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${order?['totalAmount']?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final name = item['plantName'] ?? 'Unknown';
    final price = item['price'] ?? 0;
    final quantity = item['quantity'] ?? 1;
    final imageUrl = item['imageUrl'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${(price * quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(Map<String, dynamic> paymentInfo) {
    final status = paymentInfo['status'] ?? 'pending';
    final paidAt = paymentInfo['paidAt'];
    final amount = paymentInfo['amount'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.creditCard,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPaymentRow('Status', status.toUpperCase()),
            _buildPaymentRow('Amount', '₹${amount.toStringAsFixed(2)}'),
            if (paidAt != null)
              _buildPaymentRow(
                'Paid At',
                DateFormat('MMM dd, yyyy - HH:mm').format(DateTime.parse(paidAt)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    final shippingAddress = order?['shippingAddress'] ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  color: AppTheme.darkTheme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(shippingAddress['street'] ?? ''),
            Text(shippingAddress['city'] ?? ''),
            Text(shippingAddress['state'] ?? ''),
            Text(shippingAddress['zipCode'] ?? ''),
            Text(shippingAddress['country'] ?? ''),
            if (shippingAddress['phone'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Phone: ${shippingAddress['phone']}',
                style: TextStyle(
                  color: AppTheme.darkTheme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
