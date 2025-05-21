import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simtech Gordyn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      'List Rumah Sakit',
      'Perhitungan',
      'Pesanan',
    ];

    final buttonNavigators = [
          () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ListRumahSakitPage()));
      },
          () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PerhitunganPage()));
      },
          () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PesananPage()));
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(buttonLabels.length, (index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              ),
              onPressed: buttonNavigators[index],
              child: Text(buttonLabels[index]),
            );
          }),
        ),
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          'This is the second page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

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
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.local_hospital),
            title: Text(hospitals[index]),
          );
        },
      ),
    );
  }
}

class PerhitunganPage extends StatefulWidget {
  const PerhitunganPage({super.key});

  @override
  State<PerhitunganPage> createState() => _PerhitunganPageState();
}

class _PerhitunganPageState extends State<PerhitunganPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaRsController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _bedController = TextEditingController();
  final TextEditingController _jenisItemController = TextEditingController();
  final TextEditingController _lebarSisiController = TextEditingController();
  final TextEditingController _lebarKakiController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();
  final TextEditingController _lipatanController = TextEditingController();
  final TextEditingController _koefLipatanController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  String? _tipeTirai;
  String? _tipeRell;

  double get totalKeliling {
    final sisi = double.tryParse(_lebarSisiController.text) ?? 0;
    final kaki = double.tryParse(_lebarKakiController.text) ?? 0;
    return sisi + kaki;
  }

  double get totalTinggi {
    final tinggi = double.tryParse(_tinggiController.text) ?? 0;
    final lipatan = double.tryParse(_lipatanController.text) ?? 0;
    return tinggi + lipatan;
  }

  double get subTotalKebutuhan {
    return totalKeliling * totalTinggi;
  }

  double get totalKebutuhanBahan {
    final qty = int.tryParse(_qtyController.text) ?? 0;
    return subTotalKebutuhan * qty;
  }

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field ini wajib diisi';
    }
    return null;
  }

  String? numberValidator(String? value, {bool allowDecimal = false}) {
    if (value == null || value.trim().isEmpty) return 'Field ini wajib diisi';
    final parsed = allowDecimal
        ? double.tryParse(value)
        : int.tryParse(value);
    if (parsed == null) {
      return 'Harus berupa angka yang valid';
    }
    return null;
  }

  String? lipatanValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final parsed = double.tryParse(value);
    if (parsed == null || parsed < 0 || parsed > 1) {
      return 'Lipatan harus antara 0.00 - 1.00';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final summaryData = {
        'Nama RS': _namaRsController.text,
        'Kelas': _kelasController.text,
        'Bed': _bedController.text,
        'Jenis Item': _jenisItemController.text,
        'Tipe Tirai': _tipeTirai,
        'Tipe Rell': _tipeRell,
        'Lebar Sisi (m)': _lebarSisiController.text,
        'Lebar Kaki (m)': _lebarKakiController.text,
        'Total Keliling (m)': totalKeliling.toStringAsFixed(2),
        'Tinggi (m)': _tinggiController.text,
        'Lipatan (m)': _lipatanController.text,
        'Total Tinggi (m)': totalTinggi.toStringAsFixed(2),
        'Koef. Lipatan': _koefLipatanController.text,
        'Sub Total Keb. (m²)': subTotalKebutuhan.toStringAsFixed(2),
        'Qty': _qtyController.text,
        'Total Kebutuhan Bahan (m²)': totalKebutuhanBahan.toStringAsFixed(2),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerhitunganSummaryPage(data: summaryData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perhitungan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaRsController,
                decoration: getInputDecoration('Nama RS'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kelasController,
                decoration: getInputDecoration('Kelas'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bedController,
                decoration: getInputDecoration('Bed'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _jenisItemController,
                decoration: getInputDecoration('Jenis Item'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _tipeTirai,
                items: ['Track', 'Roller', 'Vertical']
                    .map((tipe) => DropdownMenuItem(
                  value: tipe,
                  child: Text(tipe),
                ))
                    .toList(),
                decoration: getInputDecoration('Tipe Tirai'),
                onChanged: (value) => setState(() => _tipeTirai = value),
                validator: (value) =>
                value == null ? 'Pilih tipe tirai' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _tipeRell,
                items: ['Aluminium', 'Stainless', 'PVC']
                    .map((tipe) => DropdownMenuItem(
                  value: tipe,
                  child: Text(tipe),
                ))
                    .toList(),
                decoration: getInputDecoration('Tipe Rell'),
                onChanged: (value) => setState(() => _tipeRell = value),
                validator: (value) =>
                value == null ? 'Pilih tipe rell' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lebarSisiController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration('Lebar Sisi (m)'),
                validator: (val) => numberValidator(val, allowDecimal: true),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lebarKakiController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration('Lebar Kaki (m)'),
                validator: (val) => numberValidator(val, allowDecimal: true),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Text('Total Keliling: ${totalKeliling.toStringAsFixed(2)} m'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tinggiController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration('Tinggi (m)'),
                validator: (val) => numberValidator(val, allowDecimal: true),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lipatanController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: getInputDecoration('Lipatan (m)'),
                validator: lipatanValidator,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Text('Total Tinggi: ${totalTinggi.toStringAsFixed(2)} m'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _koefLipatanController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: getInputDecoration('Koef. Lipatan (admin only)'),
              ),
              const SizedBox(height: 10),
              Text('Sub Total Kebutuhan: ${subTotalKebutuhan.toStringAsFixed(2)} m²'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration('Qty'),
                validator: (val) => numberValidator(val),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Text('Total Kebutuhan Bahan: ${totalKebutuhanBahan.toStringAsFixed(2)} m²'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerhitunganSummaryPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const PerhitunganSummaryPage({super.key, required this.data});

  Future<void> _saveData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing saved summaries or start fresh
    final List<String> savedSummaries = prefs.getStringList('saved_summaries') ?? [];

    // Convert the current data map to a formatted string
    final jsonString = data.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    // Add the new summary to the list
    savedSummaries.add(jsonString);

    // Save updated list back to shared preferences
    await prefs.setStringList('saved_summaries', savedSummaries);

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data tersimpan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Perhitungan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: data.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      tileColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Data'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _saveData(context),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_summaries');
    setState(() {
      savedSummaries = [];
    });
  }

  // Update one summary after editing
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
                // Show first line or truncated summary
                summary.split('\n').first,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                // Navigate to detail/edit page, await result
                final editedSummary = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PerhitunganEditPage(
                      initialData: summary,
                    ),
                  ),
                );
                if (editedSummary != null) {
                  // Update summary after edit
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
  final String initialData; // The saved summary string

  const PerhitunganEditPage({super.key, required this.initialData});

  @override
  State<PerhitunganEditPage> createState() => _PerhitunganEditPageState();
}

class _PerhitunganEditPageState extends State<PerhitunganEditPage> {
  late Map<String, String> dataMap;
  final _formKey = GlobalKey<FormState>();

  // Convert string summary to map
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

  // Convert map back to summary string
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
              // Generate TextFormFields dynamically for each field in dataMap
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





