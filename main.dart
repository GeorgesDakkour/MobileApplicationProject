import 'package:flutter/material.dart';

void main() {
  runApp(GroceryApp());
}

class GroceryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ListProduct> groceryItems = [
    ListProduct(name: 'Apples', price: 2.5, quantity: 100),
    ListProduct(name: 'Bread', price: 1.2, quantity: 50),
    ListProduct(name: 'Milk', price: 1.5, quantity: 30),
    ListProduct(name: 'Cheese', price: 3.8, quantity: 20),
    ListProduct(name: 'Eggs', price: 2.0, quantity: 80),
    ListProduct(name: 'Orange Juice', price: 4.5, quantity: 40),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Items'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(selectedProduct: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ListProduct {
  final String name;
  final double price;
  final int quantity;

  ListProduct({required this.name, required this.price, required this.quantity});
}

class DetailsPage extends StatefulWidget {
  final ListProduct selectedProduct;

  DetailsPage({required this.selectedProduct});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedProduct.name),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.selectedProduct.name} - \$${widget.selectedProduct.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Available: ${widget.selectedProduct.quantity} pieces",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Select Quantity: ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<int>(
                  value: selectedQuantity,
                  items: List.generate(
                    widget.selectedProduct.quantity,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text("${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value!;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final totalCost = widget.selectedProduct.price * selectedQuantity;

                // Navigate to the Bank Card Payment Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BankCardPage(
                      totalCost: totalCost,
                      itemName: widget.selectedProduct.name,
                      quantity: selectedQuantity,
                    ),
                  ),
                );
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BankCardPage extends StatelessWidget {
  final double totalCost;
  final String itemName;
  final int quantity;

  BankCardPage({
    required this.totalCost,
    required this.itemName,
    required this.quantity,
  });

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Payment Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item: $itemName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Quantity: $quantity",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Total: \$${totalCost.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 20),
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: expiryController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simulate successful payment
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment successful!')),
                  );
                },
                child: Text('Pay \$${totalCost.toStringAsFixed(2)}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
