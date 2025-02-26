import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/cart_provider.dart';

class CustomInvoicePage extends StatelessWidget {
  final CartProvider cart;
  final String username;
  final String email;
  final String phone;

  const CustomInvoicePage({super.key, 
    required this.cart,
    required this.username,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn của bạn'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Logo and Store Info
                Center(
                  child: Column(
                    children: [

                      const SizedBox(height: 8),
                      const Text(
                        'CỬA HÀNG GIA DỤNG',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        'Địa chỉ: TX25 Đường Q12, TP.HCM',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Text(
                        'Hotline: 0987 654 321',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // User Information
                const Text(
                  'Thông tin khách hàng:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Tên đăng nhập: $username', style: const TextStyle(fontSize: 16)),
                Text('Email: $email', style: const TextStyle(fontSize: 16)),
                Text('Số điện thoại: $phone', style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 20),

                // Invoice Details
                const Text(
                  'Chi tiết hóa đơn:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cart.selectedItemsTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Footer with Seal and Signature
                Center(
                  child: Column(
                    children: [
               
                      const SizedBox(height: 8),
                      Text(
                        'Cảm ơn quý khách đã mua hàng!',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Hẹn gặp lại!',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic to continue shopping
                        cart.clearPurchasedItems(); // Clear only the purchased items
                        Navigator.pushNamed(context, '/Layout'); // Navigate to the Layout page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red color
                      ),
                      child: const Text('Tiếp tục mua'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Logic to exit the app
                        SystemNavigator.pop(); // Uncomment this line to exit the app
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Green color
                      ),
                      child: const Text('Thoát'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
