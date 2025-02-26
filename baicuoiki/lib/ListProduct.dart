import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:baicuoiki/product/Product.dart';
import 'package:baicuoiki/ProductDetails.dart';
import 'package:baicuoiki/login/Cart.dart';
import 'package:baicuoiki/providers/cart_provider.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<StatefulWidget> createState() {
    return TrangthaiListProducts();
  }
}

class TrangthaiListProducts extends State<ListProducts> {
  late Future<List<Product>> lstproducts;
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    lstproducts = LayDssanphamtuBackend();
    lstproducts.then((products) {
      setState(() {
        filteredProducts = products;
        isLoading = false;
      });
    });
  }

  Future<List<Product>> LayDssanphamtuBackend() async {
    try {
      final response = await http
          .get(Uri.parse('https://6731c05f7aaf2a9aff11dd05.mockapi.io/products'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Không đọc được sản phẩm từ backend');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return []; // Return empty list on error
    }
  }

  // Update filter method to work with Future
  void filterProducts(String query) {
    lstproducts.then((products) {
      setState(() {
        filteredProducts = products.where((product) {
          return product.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
        }).toList();
      });
    });
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    try {
      cart.addItem(product);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} đã được thêm vào giỏ hàng!'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'XEM GIỎ HÀNG',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
              );
            },
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E4E4),
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.format_list_bulleted_sharp, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Center(
          child: Text(
            "CỬA HÀNG GIA DỤNG",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF2D3243),
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.black),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: -3,
                      top: -3,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterProducts(value); // Gọi hàm lọc
                },
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow.shade700),
              accountName: const Text("James Martin", style: TextStyle(fontSize: 18)),
              accountEmail: const Text("Senior Graphic Designer"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage("https://via.placeholder.com/150"), // Replace with actual image URL
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('All inboxes'),
              trailing: const Text('15'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Primary'),
              trailing: const Text('15'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.social_distance),
              title: const Text('Social'),
              trailing: const Text('14 new'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text('Promotions'),
              trailing: const Text('99+ new', style: TextStyle(color: Colors.green)),
              onTap: () {
                // Handle tap
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Starred'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_important),
              title: const Text('Important'),
              trailing: const Text('1'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Sent'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.outbox),
              title: const Text('Outbox'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.drafts),
              title: const Text('Drafts'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.all_inbox),
              title: const Text('All emails'),
              trailing: const Text('99+'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Spam'),
              trailing: const Text('99+'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                product.image.toString(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Text(
                                product.title?.isNotEmpty == true
                                    ? product.title!
                                    : "No Title",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Color(0xFF2D3243),
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.price != null
                                    ? "\$${product.price!.toStringAsFixed(2)}"
                                    : "\$0.00",
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                            label: const Text('Thêm vào giỏ'),
                            onPressed: () => addToCart(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3D5AFE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}
  