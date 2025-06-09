import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function(String) onStatusChange;

  const OrderDetailsPage({
    Key? key,
    required this.order,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order['status'];
  }

  Future<void> _saveStatusLocally(String summary, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSummaries = prefs.getStringList('saved_summaries') ?? [];
    final updatedSummaries = savedSummaries.map((item) {
      final parts = item.split('|');
      if (parts[0] == summary) {
        return '$summary|$status'; // Save summary with updated status
      }
      return item;
    }).toList();
    await prefs.setStringList('saved_summaries', updatedSummaries);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      case 'Done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        centerTitle: true, // Center the title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(widget.order['summary']),
            const SizedBox(height: 16),
            Text(
              'Status:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: currentStatus,
              items: ['Pending', 'In Progress', 'Cancelled', 'Done']
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(color: _getStatusColor(status)),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newStatus) {
                if (newStatus != null) {
                  setState(() {
                    currentStatus = newStatus; // Update local state
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Simpan perubahan status dibawah:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await _saveStatusLocally(widget.order['summary'], currentStatus); // Save locally
                      widget.onStatusChange(currentStatus); // Save changes
                      Navigator.pop(context); // Return to the previous page
                    },
                    child: const Text(
                      'Ubah status',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
