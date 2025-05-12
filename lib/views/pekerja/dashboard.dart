import 'package:flutter/material.dart';

class Dashboardp extends StatefulWidget {
  const Dashboardp({super.key});

  @override
  State<Dashboardp> createState() => _DashboardpState();
}

class _DashboardpState extends State<Dashboardp> {
  int _selectedIndex = 0;

  final List<Map<String, String>> jobs = [
    {'name': 'Alex', 'task': 'paiton'},
    {'name': 'Gani', 'task': 'nengkaan'},
    {'name': 'Fariz', 'task': 'grujukan'},
    {'name': 'Wahyu', 'task': 'tegal ampel'},
    {'name': 'Joshua', 'task': 'pujer'},
    {'name': 'Adel', 'task': 'tapen'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buatDashboardContent(),
      const Center(child: Text('Bukti')),
      const Center(child: Text('Riwayat')),
      const Center(child: Text('Profil')),
    ]);
  }

  Widget _buatDashboardContent() {
    return Stack(
      children: [
        // Warna hijau full background
        Container(color: const Color(0xFF3D8361)),

        // Konten ditimpa dari atas
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight + 40),

            // Tambahkan header sapaan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Selamat Datang", style: TextStyle(color: Colors.white)),
                  Text(
                    "Alex Rohmatullah",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kontainer putih
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Pekerjaan hari ini",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(job['name'] ?? ''),
                              subtitle: Text(job['task'] ?? ''),
                              trailing: const Text(
                                "Selengkapnya >",
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF3D8361),
      elevation: 0,
      centerTitle: true,
      title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40, // Increased size of the circle
          child: Icon(Icons.account_circle, color: Colors.grey, size: 40), // Adjusted icon size
        ),
      ),
    ),
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
          icon: Icon(Icons.add_photo_alternate),
          label: 'Bukti',
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
