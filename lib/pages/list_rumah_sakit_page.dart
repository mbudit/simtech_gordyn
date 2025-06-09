import 'package:flutter/material.dart';
import 'hospital_details_page.dart'; // Import the new page

class ListRumahSakitPage extends StatelessWidget {
  const ListRumahSakitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> hospitals = [
      'RS Cipto Mangunkusumo',
      'RS Harapan Kita',
      'RSUP Persahabatan',
      'RS Siloam',
      'RS Hermina',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Rumah Sakit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2, // Adjust card aspect ratio
        ),
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HospitalDetailsPage(hospitalName: hospitals[index]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_hospital, size: 40, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      hospitals[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
