import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_details_page.dart'; // Import the new page

class TrackingProcessPage extends StatefulWidget {
  const TrackingProcessPage({super.key});

  @override
  State<TrackingProcessPage> createState() => _TrackingProcessPageState();
}

class _TrackingProcessPageState extends State<TrackingProcessPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSummaries = prefs.getStringList('saved_summaries') ?? [];
    setState(() {
      orders = savedSummaries.map((item) {
        final parts = item.split('|');
        return {
          'summary': parts[0],
          'status': parts.length > 1 ? parts[1] : 'Pending', // Default to 'Pending' if status is missing
        };
      }).toList();
    });
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

  List<Map<String, dynamic>> _getOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Process'),
        centerTitle: true, // Center the title
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders to track.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Pending', Colors.orange),
                  _buildSection('In Progress', Colors.blue),
                  _buildSection('Cancelled', Colors.red),
                  _buildSection('Done', Colors.green),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String status, Color color) {
    final filteredOrders = _getOrdersByStatus(status);
    if (filteredOrders.isEmpty) return const SizedBox(); // Skip empty sections

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  order['summary'].split('\n').first,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  order['summary'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  order['status'],
                  style: TextStyle(
                    color: _getStatusColor(order['status']),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(
                        order: order,
                        onStatusChange: (newStatus) {
                          setState(() {
                            order['status'] = newStatus; // Update status in parent
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
