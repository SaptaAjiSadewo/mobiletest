import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
import 'transaksi_berhasilPage.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, int> layananDipilih;
  final int totalHarga;
  final List<dynamic> layananList;

  CheckoutPage({
    required this.layananDipilih,
    required this.totalHarga,
    required this.layananList,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _jarakController = TextEditingController();

  String? _selectedPaymentMethod;
  String? _selectedDeliveryType;
  String _status = "pending";
  DateTime _waktuPemesanan = DateTime.now();
  double _biayaPengiriman = 0;

  Uint8List? _buktiTransfer;
  String? _buktiFileName;

  final List<String> metodePembayaran = ["Bank Transfer", "E-Wallet", "COD"];
  final List<String> jenisPengiriman = ["Drop Off", "Pickup"];

  Future<void> _pickImage() async {
    Uint8List? bytes = await ImagePickerWeb.getImageAsBytes();
    if (bytes != null) {
      setState(() {
        _buktiTransfer = bytes;
        _buktiFileName = "bukti_transfer.png";
      });
    }
  }

  void _hitungBiayaPengiriman() {
    if (_selectedDeliveryType == "Drop Off") {
      _biayaPengiriman = 0;
    } else if (_selectedDeliveryType == "Pickup") {
      String jarakText = _jarakController.text.trim();

      if (jarakText.isEmpty) {
        _biayaPengiriman = 0;
        return;
      }

      double? jarak = double.tryParse(jarakText);

      if (jarak != null && jarak >= 0) {
        if (jarak <= 3) {
          _biayaPengiriman = 5000;
        } else if (jarak <= 5) {
          _biayaPengiriman = 10000;
        } else {
          _biayaPengiriman = 15000 + ((jarak - 5) * 1000);
        }
      } else {
        _biayaPengiriman = 0; // input invalid
      }
    } else {
      _biayaPengiriman = 0;
    }
  }

  Future<void> submitCheckout() async {
    _hitungBiayaPengiriman();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.13:8000/api/pesanan'),
      );

      request.fields['nama'] = _namaController.text;
      request.fields['no_telepon'] = _teleponController.text;
      request.fields['alamat'] = _alamatController.text;
      request.fields['total_pembayaran'] =
          (widget.totalHarga + _biayaPengiriman).toString();
      request.fields['metode_pembayaran'] = _selectedPaymentMethod!;
      request.fields['layanan_dipesan'] = widget.layananDipilih.keys.join(', ');
      request.fields['waktu_pemesanan'] = _waktuPemesanan.toIso8601String();
      request.fields['status'] = _status;
      request.fields['jenis_pengiriman'] = _selectedDeliveryType ?? "";
      request.fields['jarak'] = _jarakController.text; // <-- Tambahkan ini

      if (_catatanController.text.isNotEmpty) {
        request.fields['catatan'] = _catatanController.text;
      }

      if (_buktiTransfer != null && _buktiFileName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'bukti_transfer',
          _buktiTransfer!,
          filename: _buktiFileName,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pesanan berhasil dikirim!")),
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TransaksiBerhasilPage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim pesanan, coba lagi!")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, periksa koneksi Anda!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _hitungBiayaPengiriman();

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_namaController, "Nama"),
            _buildTextField(_teleponController, "No. Telepon",
                type: TextInputType.phone),
            _buildTextField(_alamatController, "Alamat"),
            _buildTextField(_catatanController, "Catatan (Opsional)"),
            DropdownButtonFormField<String>(
              value: _selectedDeliveryType,
              decoration: InputDecoration(labelText: "Jenis Pengiriman"),
              items: jenisPengiriman.map((jenis) {
                return DropdownMenuItem(value: jenis, child: Text(jenis));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDeliveryType = value;
                });
              },
            ),
            if (_selectedDeliveryType == "Pickup")
              _buildTextField(_jarakController, "Jarak ke lokasi (km)",
                  type: TextInputType.number),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(labelText: "Metode Pembayaran"),
              items: metodePembayaran.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            SizedBox(height: 20),
            _buildLayananList(),
            Divider(thickness: 1),
            Text(
              "Total Bayar: Rp ${(widget.totalHarga + _biayaPengiriman).toStringAsFixed(0)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Bukti Transfer (Opsional):",
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buktiTransfer != null
                ? Image.memory(_buktiTransfer!, height: 100)
                : Text("Belum ada gambar"),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Unggah Bukti Transfer"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedPaymentMethod == null ||
                    _selectedDeliveryType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Pilih metode pembayaran dan jenis pengiriman!")),
                  );
                  return;
                }
                submitCheckout();
              },
              child: Text("Konfirmasi Pesanan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildLayananList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Layanan yang dipilih:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        ...widget.layananDipilih.keys.map((item) => Text("- $item")).toList(),
      ],
    );
  }
}
