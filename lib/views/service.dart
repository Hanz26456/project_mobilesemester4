import 'package:flutter/material.dart';

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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Housekeeping", 
                  "Rp 200.000", 
                  "assets/icons/housekeeping_icon.png", // Placeholder for icon
                  Icons.cleaning_services,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Electrical", 
                  "Rp 200.000", 
                  "assets/icons/electrical_icon.png", // Placeholder for icon
                  Icons.electrical_services,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Plumbing", 
                  "Rp 180.000", 
                  "assets/icons/plumbing_icon.png", // Placeholder for icon
                  Icons.plumbing,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Painting", 
                  "Rp 250.000", 
                  "assets/icons/painting_icon.png", // Placeholder for icon
                  Icons.format_paint,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Furniture Repair", 
                  "Rp 220.000", 
                  "assets/icons/furniture_icon.png", // Placeholder for icon
                  Icons.chair,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Computer Repair", 
                  "Rp 230.000", 
                  "assets/icons/computer_icon.png", // Placeholder for icon
                  Icons.computer,
                  context
                ),
                const SizedBox(height: 16),
                
                _buildServiceItem(
                  "Car Service", 
                  "Rp 300.000", 
                  "assets/icons/car_icon.png", // Placeholder for icon
                  Icons.directions_car,
                  context
                ),
                
                // Dummy space at bottom for better scrolling experience
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Set to 1 to highlight the Services tab
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: 'Layanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String price, String iconPath, IconData fallbackIcon, BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title dipilih'),
            duration: const Duration(seconds: 1),
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
                child: title == "AC Service" 
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
                  : Icon(
                      fallbackIcon,
                      size: 35,
                      color: Colors.teal,
                    ),
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
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Main App with Navigation between screens
class ServiceApp extends StatefulWidget {
  const ServiceApp({Key? key}) : super(key: key);

  @override
  _ServiceAppState createState() => _ServiceAppState();
}

class _ServiceAppState extends State<ServiceApp> {
  int _currentIndex = 0;
  
  // Pages to be shown
  final List<Widget> _pages = [
    const HomeScreen(),
    const ServicesScreen(),
    const Center(child: Text('Profil Page')),
    const Center(child: Text('Riwayat Page')),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: 'Layanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}

// HomeScreen class from your previous code
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Notification Icon
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Halo, Jamal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, size: 28),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifikasi diklik'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Promo Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Digital Season diskon 26%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Khusus bulan ini',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Rest of your home screen...
              const SizedBox(height: 200),
              const Center(child: Text("Beranda Content")),
            ],
          ),
        ),
      ),
    );
  }
}

// Main entry point for the app
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ServiceApp(),
    ),
  );
}