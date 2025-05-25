import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pekerja/jobdetail.dart';
import 'riwayat.dart';
import 'profil.dart';
import '../../data/services/auth_service.dart'; // Import AuthService
import '../../data/models/user_models.dart'; // Import UserModel sesuai dengan struktur Anda
import '../../data/models/order_pekerja_model.dart';
import '../../data/services/order_pekerja_service.dart';
import 'dart:math';
import '../../data/models/job_status.dart';
import '../../data/services/job_status_service.dart';
import '../../data/models/worker_statistik.dart';
import '../../data/services/WorkerStatistikService.dart';
import 'package:gap/gap.dart';

class Dashboardp extends StatefulWidget {
  const Dashboardp({super.key});

  @override
  State<Dashboardp> createState() => _DashboardpState();
  
}

class _DashboardpState extends State<Dashboardp>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // User dan statistik
  String username = 'Pengguna';
  UserModel? currentUser;
  bool isLoadingUser = false;
  final AuthService _authService = AuthService();

  final WorkerStatistikService _statistikService = WorkerStatistikService();
  WorkerStatistik? _statistik;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    _loadCurrentUser();
    _loadStatistik();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index); // Sinkronisasi dengan TabController
    });
  }

  Future<void> _loadStatistik() async {
    try {
      print('=== Mulai load statistik ===');
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('Memanggil API...');
      final statistik = await _statistikService.fetchStatistik();
      print('API response berhasil: $statistik');

      setState(() {
        _statistik = statistik;
        _isLoading = false;
      });
      print('setState berhasil, loading = false');
    } catch (e) {
      print('Error saat load statistik: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Modifikasi untuk langsung menyimpan username
  Future<void> _loadCurrentUser() async {
    print('Memulai loading user data...');
    setState(() {
      isLoadingUser = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Pendekatan 1: Coba ambil langsung username dari SharedPreferences
      if (prefs.containsKey('username')) {
        String savedUsername = prefs.getString('username') ?? 'Pengguna';
        print(
          'Username ditemukan langsung di SharedPreferences: $savedUsername',
        );
        setState(() {
          username = savedUsername; // Set username langsung
        });
      }

      // Pendekatan 2: Ambil dari user_data
      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        final userMap = json.decode(userJson);
        final extractedUsername = userMap['username'];
        print('Username dari user_data: $extractedUsername');

        if (extractedUsername != null &&
            extractedUsername.toString().isNotEmpty) {
          setState(() {
            username = extractedUsername;
            currentUser = UserModel.fromJson(userMap);
          });
          print('Username diset ke: $username');
        }
      }
    } catch (e) {
      print('Error saat memuat user: $e');
    } finally {
      setState(() {
        isLoadingUser = false;
      });

      // Penting: Panggil setState terpisah untuk memastikan UI diperbarui
      setState(() {});
      print('Loading selesai, username: $username');
    }
  }

  // Method untuk mendapatkan token dan memanggil service
  Future<JobStatus> getJobStatus() async {
    try {
      // Dapatkan token dari shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Jika token kosong, kembalikan nilai default
      if (token.isEmpty) {
        print('Token kosong, menggunakan nilai default');
        return JobStatus(proses: 0, selesaiPengerjaan: 0, selesai: 0);
      }

      final jobStatusService = JobStatusService();
      return await jobStatusService.fetchJobStatus(token);
    } catch (e) {
      print('Error dalam getJobStatus: $e');
      // Kembalikan nilai default jika terjadi error
      return JobStatus(proses: 0, selesaiPengerjaan: 0, selesai: 0);
    }
  }
  // Contoh implementasi getToken (sesuaikan dengan implementasi Anda)

  Future<String> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Periksa beberapa kemungkinan key untuk token
      String? token = prefs.getString('auth_token');
      if (token == null || token.isEmpty) {
        token = prefs.getString('token');
      }
      if (token == null || token.isEmpty) {
        token = prefs.getString('access_token');
      }

      print(
        'Retrieved token: ${token != null && token.isNotEmpty ? "${token.substring(0, min(10, token.length))}..." : "EMPTY"}',
      );

      // Check key-key yang ada di SharedPreferences untuk debugging
      print('All SharedPreferences keys:');
      Set<String> keys = prefs.getKeys();
      for (String key in keys) {
        print('- $key');
      }

      return token ?? '';
    } catch (e) {
      print('Error getting token: $e');
      return '';
    }
  }

  // Implementasi _buildTopHeader yang sebelumnya error
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang kembali', // Pindahkan ke atas
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4), // Tambahkan spacing kecil
              Text(
                'Halo, $username!', // Pindahkan ke bawah
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Color(0xFF3D8361),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buatDashboardContent() {
    print('''
Build Dashboard Content:
- isLoadingUser: $isLoadingUser
- _isLoading: $_isLoading
- _error: $_error
- _statistik: ${_statistik?.toString()}
- currentUser: ${currentUser?.toString()}
''');
    // Tampilkan loading indicator secara jelas di tengah layar
    if (isLoadingUser || _isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3D8361),
        ),
      );
    }

    // Tampilkan error message secara jelas
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Error: $_error',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Background gradient - kurangi heightnya
        Container(
          height: MediaQuery.of(context).size.height * 0.25, // Diperkecil
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF3D8361),
                const Color(0xFF3D8361),
                const Color(0xFF3D8361).withOpacity(0.9),
              ],
            ),
          ),
        ),
        
        // Konten utama
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40), // Tambahkan jarak dari atas di sini
              _buildTopHeader(),
              const SizedBox(height: 20),
              _buildPerformanceWidget(),
              _buildStatusSummary(),
              _buildSectionHeader(
                "Pekerjaan Hari Ini",
                "Lihat Semua",
              ),
              _buildJobsList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // Perbaikan untuk widget _buildStatusSummary

  Widget _buildStatusSummary() {
    return FutureBuilder<JobStatus>(
      future: getJobStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          print('Error di FutureBuilder: ${snapshot.error}');
          // Jika error, tampilkan status default
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusCard(
                  "0",
                  "Selesai",
                  Colors.green,
                  Icons.check_circle_outline,
                ),
                _buildStatusCard(
                  "0",
                  "Proses",
                  Colors.blue,
                  Icons.pending_actions,
                ),
                _buildStatusCard(
                  "0",
                  "Selesai Pengerjaan",
                  Colors.orange,
                  Icons.access_time,
                ),
              ],
            ),
          );
        } else {
          // Data berhasil diambil atau nilai default dari error handling
          final jobStatus =
              snapshot.data ??
              JobStatus(proses: 0, selesaiPengerjaan: 0, selesai: 0);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusCard(
                  jobStatus.selesai.toString(),
                  "Selesai",
                  Colors.green,
                  Icons.check_circle_outline,
                ),
                _buildStatusCard(
                  jobStatus.proses.toString(),
                  "Proses",
                  Colors.blue,
                  Icons.pending_actions,
                ),
                _buildStatusCard(
                  jobStatus.selesaiPengerjaan.toString(),
                  "Selesai Pengerjaan",
                  Colors.orange,
                  Icons.access_time,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildStatusCard(
    String count,
    String label,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF3D8361),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    final service = OrderPekerjaService(); // Panggil service di sini

    return SizedBox(
      height: 230,
      child: FutureBuilder<List<OrderPekerja>>(
        future: service.getMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pekerjaan hari ini'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildJobCard(orders[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildJobCard(OrderPekerja order) {

    return GestureDetector(
      onTap: () {
       Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => JobDetailScreen(
      userName: order.namaUser,
      userAddress: order.alamat,
      serviceName: order.service,
      status: order.status,
      tanggal: order.tanggalPemesanan,
      phone: order.phone, // harusnya ini berisi '085388393834'
    ),
  ),
);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF3D8361).withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D8361),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_repair_service,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.namaUser,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    order.service,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.tanggalPemesanan,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF3D8361),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceWidget() {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3D8361).withOpacity(0.9),
              const Color(0xFF1A5F7A),
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_error != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.red.withOpacity(0.1),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Gagal memuat statistik',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadStatistik,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_statistik == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Center(child: Text('Tidak ada data statistik')),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3D8361).withOpacity(0.9),
            const Color(0xFF1A5F7A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D8361).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Statistik Minggu Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_statistik!.completedPercentage.toStringAsFixed(0)}% ✓',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceItem(
                '${_statistik!.completedPercentage.toStringAsFixed(0)}%',
                'Penyelesaian',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildPerformanceItem(
                'Rp ${_formatCurrency(_statistik!.totalEarnings)}',
                'Pendapatan',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildPerformanceItem(
                '${_statistik!.totalOrders}',
                'Total Orders',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    // Format currency dengan titik sebagai separator ribuan
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buatDashboardContent(),
      const RiwayatScreen(),
      const ProfilePekerja(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFA),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages, // ← GANTI DARI _pages KE pages
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 65,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, "Beranda"),
                    _buildNavItem(1, Icons.work_rounded, "Daftar Pekerjaan"),
                    _buildNavItem(2, Icons.person_rounded, "Profil"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: const Color(0xFF3D8361).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                )
                : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF3D8361) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3D8361) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}