import 'package:flutter/material.dart';
import 'list_rumah_sakit_page.dart';
import 'perhitungan_page.dart';
import 'pesanan_page.dart';
import 'tracking_process_page.dart'; // Import the new page

class ButtonData {
  final String label;
  final Widget page;
  final IconData icon;

  ButtonData({required this.label, required this.page, required this.icon});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ButtonData(label: 'List Rumah Sakit', page: const ListRumahSakitPage(), icon: Icons.local_hospital),
      ButtonData(label: 'Buat Order Baru', page: const PerhitunganPage(), icon: Icons.add_shopping_cart),
      ButtonData(label: 'Pesanan', page: const PesananPage(), icon: Icons.list_alt),
      ButtonData(label: 'Tracking Process', page: const TrackingProcessPage(), icon: Icons.track_changes),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIMTECH Gordyn'),
        centerTitle: true, // Center the title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: buttons.map((button) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => button.page));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(button.icon, size: 40),
                  const SizedBox(height: 8),
                  Text(button.label),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
