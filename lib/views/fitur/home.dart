import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../fitur/service.dart';
import '../fitur/profil.dart';
import '../fitur/history.dart';
import '../fitur dalam/notifikasi.dart';
import '../../data/services/service_service.dart';
import '../../data/models/service_model.dart';
import '../../data/services/auth_service.dart'; // Import AuthService
import '../../data/models/user_models.dart'; // Import UserModel sesuai dengan struktur Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const ServicesScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
      const Center(child: Text('Halaman Riwayat')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Layanan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Halaman beranda dengan data dari API
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ServiceModel> popularServices = [];
  bool isLoadingPopular = false;

  // Tambahkan untuk user
  UserModel? currentUser;
  bool isLoadingUser = false;
  final AuthService _authService = AuthService(); // Instansiasi AuthService

  @override
  void initState() {
    super.initState();
    fetchPopularServices();
    fetchCurrentUser(); // Panggil fungsi untuk fetch data user
  }

  // Fungsi untuk mengambil data user yang login
  Future<void> fetchCurrentUser() async {
    setState(() => isLoadingUser = true);
    try {
      // Ambil data user dari SharedPreferences yang disimpan saat login
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user_data');

      if (userJson != null) {
        Map<String, dynamic> userData = json.decode(userJson);
        setState(() {
          currentUser = UserModel.fromJson(userData);
        });
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
    setState(() => isLoadingUser = false);
  }

  Future<void> fetchPopularServices() async {
    setState(() => isLoadingPopular = true);
    try {
      List<ServiceModel> allServices = await ServiceService.getAllServices();
      setState(() {
        popularServices = allServices.take(5).toList();
      });
    } catch (e) {
      print('Error fetching popular services: $e');
    }
    setState(() => isLoadingPopular = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchPopularServices();
            await fetchCurrentUser(); // Refresh juga data user
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Notification Icon - Diganti dengan nama user yang login
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isLoadingUser
                          ? const SizedBox(
                            width: 150,
                            child: Text(
                              'Memuat...',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : Text(
                            currentUser != null
                                ? 'Halo, ${currentUser!.username}'
                                : 'Memuat data pengguna...',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotifikasiPage(),
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Enhanced Promo Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.teal.shade700,
                              Colors.teal.shade500,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'PROMO SPESIAL',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Digital Season diskon 26%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Khusus bulan ini',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_offer,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Promo diklik'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Layanan Populer Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Layanan Populer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServicesScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Layanan Populer Cards - Horizontal Scrollable dari API
                SizedBox(
                  height: 160,
                  child:
                      isLoadingPopular
                          ? const Center(child: CircularProgressIndicator())
                          : popularServices.isEmpty
                          ? const Center(
                            child: Text('Tidak ada layanan populer'),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: popularServices.length,
                            itemBuilder: (context, index) {
                              final service = popularServices[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index != popularServices.length - 1
                                          ? 12
                                          : 0,
                                ),
                                child: _buildServiceCardFromAPI(service),
                              );
                            },
                          ),
                ),

                const SizedBox(height: 24),

                // Kategori Layanan Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Kategori Layanan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Kategori Icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildCategoryIconsGrid(),
                ),

                const SizedBox(height: 24),
                // Testimonial Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Testimonial Pelanggan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua Testimonial diklik'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text('Semua'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTestimonialItem(
                          'Ahmad Fauzi',
                          'Layanan cepat dan teknisi sangat ramah!',
                          4.5,
                        ),
                        const Divider(),
                        _buildTestimonialItem(
                          'Siti Mariam',
                          'AC saya jadi dingin kembali, terima kasih!',
                          5.0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan kartu layanan dari API
  Widget _buildServiceCardFromAPI(ServiceModel service) {
    // Tentukan icon berdasarkan nama layanan atau gunakan icon default
    IconData serviceIcon = Icons.build;

    // Cek nama layanan dan tentukan icon yang sesuai
    if (service.name.toLowerCase().contains('ac')) {
      serviceIcon = Icons.ac_unit;
    } else if (service.name.toLowerCase().contains('clean')) {
      serviceIcon = Icons.cleaning_services;
    } else if (service.name.toLowerCase().contains('tv')) {
      serviceIcon = Icons.tv;
    } else if (service.name.toLowerCase().contains('ledeng') ||
        service.name.toLowerCase().contains('air')) {
      serviceIcon = Icons.plumbing;
    } else if (service.name.toLowerCase().contains('listrik')) {
      serviceIcon = Icons.electrical_services;
    }

    return Container(
      width: 140,
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child:
                  service.imageAsset.isNotEmpty
                      ? ClipOval(
                        child: Image.network(
                          service.imageAsset,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              serviceIcon,
                              size: 30,
                              color: Colors.teal,
                            );
                          },
                        ),
                      )
                      : Icon(serviceIcon, size: 30, color: Colors.teal),
            ),
            const SizedBox(height: 12),
            Text(
              service.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${service.price}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.teal[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIconsGrid() {
    List<Map<String, dynamic>> categories = [
      {'title': 'Elektronik', 'icon': Icons.devices},
      {'title': 'Rumah', 'icon': Icons.yard},
      {'title': 'Mobil', 'icon': Icons.directions_car},
      {'title': 'Perabot', 'icon': Icons.chair},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.teal.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(categories[index]['icon'], color: Colors.teal),
                onPressed: () {
                  // Handle category tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kategori ${categories[index]['title']} dipilih',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              categories[index]['title'],
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTestimonialItem(String name, String comment, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal.shade200,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  Text(
                    ' $rating',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
        ],
      ),
    );
  }
}
