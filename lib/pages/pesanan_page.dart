import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  List<String> savedSummaries = [];

  @override
  void initState() {
    super.initState();
    _loadSavedSummaries();
  }

  Future<void> _loadSavedSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final summaries = prefs.getStringList('saved_summaries') ?? [];
    setState(() {
      savedSummaries = summaries;
    });
  }

  void _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus semua pesanan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_summaries');
      setState(() {
        savedSummaries = [];
      });
    }
  }

  Future<void> _updateSummary(int index, String newSummary) async {
    final prefs = await SharedPreferences.getInstance();
    savedSummaries[index] = newSummary;
    await prefs.setStringList('saved_summaries', savedSummaries);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (savedSummaries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Clear All',
              onPressed: _clearAll,
            )
        ],
      ),
      body: savedSummaries.isEmpty
          ? const Center(child: Text('Belum ada pesanan tersimpan.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: savedSummaries.length,
        itemBuilder: (context, index) {
          final summary = savedSummaries[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                summary.split('\n').first,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                final editedSummary = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PerhitunganEditPage(
                      initialData: summary,
                    ),
                  ),
                );
                if (editedSummary != null) {
                  await _updateSummary(index, editedSummary);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class PerhitunganEditPage extends StatefulWidget {
  final String initialData;

  const PerhitunganEditPage({super.key, required this.initialData});

  @override
  State<PerhitunganEditPage> createState() => _PerhitunganEditPageState();
}

class _PerhitunganEditPageState extends State<PerhitunganEditPage> {
  late Map<String, String> dataMap;
  final _formKey = GlobalKey<FormState>();

  Map<String, String> _parseSummary(String summary) {
    final lines = summary.split('\n');
    final map = <String, String>{};
    for (var line in lines) {
      final splitIndex = line.indexOf(':');
      if (splitIndex > 0) {
        final key = line.substring(0, splitIndex).trim();
        final value = line.substring(splitIndex + 1).trim();
        map[key] = value;
      }
    }
    return map;
  }

  String _mapToSummaryString(Map<String, String> map) {
    return map.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  @override
  void initState() {
    super.initState();
    dataMap = _parseSummary(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pesanan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...dataMap.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    initialValue: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field ini tidak boleh kosong';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      dataMap[entry.key] = value;
                    },
                  ),
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedSummary = _mapToSummaryString(dataMap);
                    Navigator.pop(context, updatedSummary);
                  }
                },
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}