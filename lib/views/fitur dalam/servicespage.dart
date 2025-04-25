import 'package:flutter/material.dart';
// Import your custom button
import '../../widgets/primary_button.dart'; // Update this path
// Import the service order summary page
import '../fitur dalam/pesanlayanan.dart'; // Update this path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AC Service App',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: const ServicePage(),
    );
  }
}

class ServicePage extends StatelessWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Pesan Layanan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // AC Service Icon
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.air, size: 60, color: Colors.green[800]),
                ),
              ),
              const SizedBox(height: 20),
              // Service Title
              const Text(
                'AC Service',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Price
              const Text(
                'Rp. 150.000',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              // Description Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Order Button - replaced with PrimaryButton
              PrimaryButton(
                label: 'Pesan Sekarang',
                onPressed: () {
                  // Navigate to ServiceOrderSummary
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceOrderSummary(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
