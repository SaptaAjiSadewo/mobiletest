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

  String? _selectedPaymentMethod;
  String _status = "pending";
  DateTime _waktuPemesanan = DateTime.now();
  double _biayaPengiriman = 10000; // Biaya pengiriman tetap

  Uint8List? _buktiTransfer;
  String? _buktiFileName;

  final List<String> metodePembayaran = ["Bank Transfer", "E-Wallet", "COD"];

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    Uint8List? bytes = await ImagePickerWeb.getImageAsBytes();
    if (bytes != null) {
      setState(() {
        _buktiTransfer = bytes;
        _buktiFileName = "bukti_transfer.png";
      });
    }
  }

  Future<void> submitCheckout() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.9:8000/api/pesanan'),
      );

      request.fields['nama'] = _namaController.text;
      request.fields['no_telepon'] = _teleponController.text;
      request.fields['alamat'] = _alamatController.text;
      request.fields['total_pembayaran'] =
          (_biayaPengiriman + widget.totalHarga).toString();
      request.fields['metode_pembayaran'] = _selectedPaymentMethod!;
      request.fields['layanan_dipesan'] = widget.layananDipilih.keys.join(', ');
      request.fields['waktu_pemesanan'] = _waktuPemesanan.toIso8601String();
      request.fields['status'] = _status;

      if (_catatanController.text.isNotEmpty) {
        request.fields['catatan'] = _catatanController.text;
      }

      // Tambah bukti transfer jika ada
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
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: _teleponController,
              decoration: InputDecoration(labelText: "No. Telepon"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: "Alamat"),
            ),
            TextField(
              controller: _catatanController,
              decoration: InputDecoration(labelText: "Catatan (Opsional)"),
            ),
            SizedBox(height: 10),

            // Dropdown Metode Pembayaran
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(labelText: "Metode Pembayaran"),
              items: metodePembayaran.map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),

            SizedBox(height: 10),
            Text("Layanan yang dipilih:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...widget.layananDipilih.keys
                .map((item) => Text("- $item"))
                .toList(),
            SizedBox(height: 10),

            Text("Total Harga: Rp ${widget.totalHarga.toStringAsFixed(0)}"),
            Text("Biaya Pengiriman: Rp $_biayaPengiriman"),
            Text(
              "Total Bayar: Rp ${(widget.totalHarga + _biayaPengiriman).toStringAsFixed(0)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 10),
            Text("Bukti Transfer (Opsional):",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),

            _buktiTransfer != null
                ? Image.memory(_buktiTransfer!, height: 100)
                : Text("Belum ada gambar"),
            SizedBox(height: 5),

            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Unggah Bukti Transfer"),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedPaymentMethod == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Pilih metode pembayaran!")),
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
}
