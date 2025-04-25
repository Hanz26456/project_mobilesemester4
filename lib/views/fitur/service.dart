import 'package:flutter/material.dart';
// Import the service order summary screen
import '../fitur dalam/servicespage.dart'; // Adjust this path as needed

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header title
                const Center(
                  child: Text(
                    'Layanan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Layanan',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.filter_list),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Service List Items
                _buildServiceItem(
                  "AC Service",
                  "Rp 200.000",
                  "assets/icons/ac_icon.png", // Placeholder for icon
                  Icons.ac_unit,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Housekeeping",
                  "Rp 200.000",
                  "assets/icons/housekeeping_icon.png", // Placeholder for icon
                  Icons.cleaning_services,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Electrical",
                  "Rp 200.000",
                  "assets/icons/electrical_icon.png", // Placeholder for icon
                  Icons.electrical_services,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Plumbing",
                  "Rp 180.000",
                  "assets/icons/plumbing_icon.png", // Placeholder for icon
                  Icons.plumbing,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Painting",
                  "Rp 250.000",
                  "assets/icons/painting_icon.png", // Placeholder for icon
                  Icons.format_paint,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Furniture Repair",
                  "Rp 220.000",
                  "assets/icons/furniture_icon.png", // Placeholder for icon
                  Icons.chair,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Computer Repair",
                  "Rp 230.000",
                  "assets/icons/computer_icon.png", // Placeholder for icon
                  Icons.computer,
                  context,
                ),
                const SizedBox(height: 16),

                _buildServiceItem(
                  "Car Service",
                  "Rp 300.000",
                  "assets/icons/car_icon.png", // Placeholder for icon
                  Icons.directions_car,
                  context,
                ),

                // Dummy space at bottom for better scrolling experience
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(
    String title,
    String price,
    String iconPath,
    IconData fallbackIcon,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to Service Order Summary page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ServicePage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon or Image circle
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    title == "AC Service"
                        ? Image.asset(
                          'assets/icons/ac_fan.png', // You'll need to add this asset
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              fallbackIcon,
                              size: 35,
                              color: Colors.teal,
                            );
                          },
                        )
                        : Icon(fallbackIcon, size: 35, color: Colors.teal),
              ),
            ),
            const SizedBox(width: 16),
            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}