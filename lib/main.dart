import 'package:flutter/material.dart';

void main() => runApp(const GroceryOnePageApp());

class GroceryOnePageApp extends StatelessWidget {
  const GroceryOnePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery One-Page Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const GroceryHomePage(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.unit = '1 KG',
  });
}

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
}

class GroceryHomePage extends StatefulWidget {
  const GroceryHomePage({super.key});

  @override
  State<GroceryHomePage> createState() => _GroceryHomePageState();
}

class _GroceryHomePageState extends State<GroceryHomePage> {
  // sample product list (network images so no assets needed)
  final List<Product> products = [
    Product(
      id: 'p1',
      name: 'Orange',
      image: 'https://images.unsplash.com/photo-1574226516831-e1dff420e38e?q=80&w=600&auto=format&fit=crop',
      price: 3.5,
    ),
    Product(
      id: 'p2',
      name: 'Strawberry',
      image: 'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?q=80&w=600&auto=format&fit=crop',
      price: 5.0,
    ),
    Product(
      id: 'p3',
      name: 'Banana',
      image: 'https://images.unsplash.com/photo-1574226516831-e1dff420e38e?q=80&w=600&auto=format&fit=crop&sat=-100',
      price: 2.2,
    ),
    Product(
      id: 'p4',
      name: 'Grapes',
      image: 'https://images.unsplash.com/photo-1571687949924-9c9b6d9a8d6f?q=80&w=600&auto=format&fit=crop',
      price: 4.0,
    ),
  ];

  // cart and currently selected product
  final List<CartItem> cart = [];
  Product? selectedProduct;

  // order form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _first = TextEditingController();
  final TextEditingController _last = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();

  void selectProduct(Product p) {
    setState(() {
      selectedProduct = p;
    });
    // auto-scroll could be added but keeping simple
  }

  void addToCart(Product product) {
    setState(() {
      final found = cart.where((c) => c.product.id == product.id).toList();
      if (found.isEmpty) {
        cart.add(CartItem(product: product, qty: 1));
      } else {
        found.first.qty++;
      }
    });

    // brief feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(milliseconds: 700)),
    );
  }

  void changeQty(CartItem item, int delta) {
    setState(() {
      item.qty += delta;
      if (item.qty <= 0) cart.remove(item);
    });
  }

  double get total {
    return cart.fold(0.0, (sum, it) => sum + it.product.price * it.qty);
  }

  void checkout() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }
    if (_formKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
      return;
    }
    // Fake checkout success
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Placed'),
        content: Text('Thank you ${_first.text}! Your total is \$${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cart.clear();
                _first.clear();
                _last.clear();
                _phone.clear();
                _email.clear();
                _address.clear();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // single scrollable page containing all sections
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Shop'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Banner =====
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF09A88E), Color(0xFF00C8A0)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                        Text('Fruits Summer', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('Find your fresh fruits here', style: TextStyle(color: Colors.white70)),
                      ]),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=400&auto=format&fit=crop',
                        width: 110,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ===== Home / Grid =====
              const Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.80,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: products.map((p) {
                  return GestureDetector(
                    onTap: () => selectProduct(p),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(p.image, fit: BoxFit.cover, width: double.infinity),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('\$${p.price.toStringAsFixed(2)} / ${p.unit}', style: const TextStyle(color: Colors.orange)),
                            const SizedBox(height: 6),
                            ElevatedButton(
                              onPressed: () => addToCart(p),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(36)),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // ===== Selected Product Detail (inline) =====
              if (selectedProduct != null) ...[
                const Text('Product Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(selectedProduct!.image, height: 200, fit: BoxFit.cover, width: double.infinity),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedProduct!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('\$${selectedProduct!.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Product details: fresh and high quality produce. Perfect for daily use and healthy snacking.',
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedProduct = null;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Back'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => addToCart(selectedProduct!),
                                icon: const Icon(Icons.shopping_cart),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                label: const Text('Buy Now'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // ===== Cart Section =====
              const Text('My Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: cart.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('Your cart is empty')),
                        )
                      : Column(
                          children: [
                            Column(
                              children: cart.map((item) {
                                return ListTile(
                                  leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.product.image, width: 50, height: 50, fit: BoxFit.cover)),
                                  title: Text(item.product.name),
                                  subtitle: Text('\$${item.product.price.toStringAsFixed(2)} x ${item.qty}'),
                                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                    IconButton(onPressed: () => changeQty(item, -1), icon: const Icon(Icons.remove_circle_outline)),
                                    Text('${item.qty}'),
                                    IconButton(onPressed: () => changeQty(item, 1), icon: const Icon(Icons.add_circle_outline)),
                                  ]),
                                );
                              }).toList(),
                            ),
                            const Divider(),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // scroll to order form (approximate by focusing)
                                // we can programmatically scroll if needed - keep simple
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceed to Order Form below')));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(42)),
                              child: const Text('Checkout'),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // ===== Order Form =====
              const Text('Fill Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      TextFormField(controller: _first, decoration: const InputDecoration(labelText: 'First Name'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 8),
                      TextFormField(controller: _last, decoration: const InputDecoration(labelText: 'Last Name')),
                      const SizedBox(height: 8),
                      TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Mobile Number'), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 8),
                      TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 8),
                      TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address'), maxLines: 2),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: checkout,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Order Now (\$${total.toStringAsFixed(2)})'),
                      ),
                    ]),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
