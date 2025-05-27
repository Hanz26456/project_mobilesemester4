import 'package:flutter/material.dart';
import '../../data/services/service_service.dart';
import '../../data/models/service_model.dart';
import '../fitur dalam/servicespage.dart'; // Sesuaikan path

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServiceModel> services = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    setState(() => isLoading = true);
    try {
      List<ServiceModel> fetchedServices = await ServiceService.getAllServices();
      setState(() {
        services = fetchedServices;
      });
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> searchServices(String query) async {
    setState(() => isLoading = true);
    try {
      if (query.isEmpty) {
        await fetchServices();
      } else {
        services = await ServiceService.searchServices(query);
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchServices,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Layanan',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchServices(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari Layanan',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            fetchServices();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return _buildServiceItem(service, context);
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel service, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServicePage(service: service),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: service.imageAsset.isNotEmpty
                    ? Image.network(
                        service.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.build, size: 35, color: Colors.teal);
                        },
                      )
                    : const Icon(Icons.build, size: 35, color: Colors.teal),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${service.price}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}
