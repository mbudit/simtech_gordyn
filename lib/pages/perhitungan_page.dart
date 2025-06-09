import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: const Text('Order Baru'),
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedSummaries = prefs.getStringList('saved_summaries') ?? [];
      final jsonString = data.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      savedSummaries.add(jsonString);
      await prefs.setStringList('saved_summaries', savedSummaries);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data tersimpan'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan data'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                      trailing: const Icon(Icons.info, semanticLabel: 'Detail'),
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