import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, int> layananDipilih;
  final int totalHarga;
  final List<dynamic> layananList;

  CheckoutPage({
    required this.layananDipilih,
    required this.totalHarga,
    required this.layananList, // Pastikan ada di konstruktor
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedPaymentMethod;
  int _selectedDeliveryOption = 0; // 0: Antar Jemput, 1: Drop Off
  TextEditingController _jarakController = TextEditingController();
  int _biayaPengiriman = 0;

  void _hitungBiayaPengiriman() {
    setState(() {
      double jarak = double.tryParse(_jarakController.text) ?? 0;
      if (jarak > 0) {
        _biayaPengiriman = (jarak <= 5) ? 1000 : 15000;
      } else {
        _biayaPengiriman = 0;
      }
    });
  }

  int _hitungTotalKeseluruhan() {
    return widget.totalHarga + _biayaPengiriman;
  }

  Widget _buildTextField(String label,
      {bool isMultiline = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 3 : 1,
          keyboardType:
              label == "Jarak (km)" ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: (value) {
            if (label == "Jarak (km)") {
              _hitungBiayaPengiriman();
            }
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Detail Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(),
        ...widget.layananDipilih.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${entry.key} (x${entry.value})"),
                Text(
                    "Rp. ${entry.value * (widget.layananList.firstWhere((layanan) => layanan["nama"] == entry.key)["harga"] ?? 0)}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Biaya Pengiriman",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Rp. $_biayaPengiriman",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Keseluruhan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Rp. ${_hitungTotalKeseluruhan()}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
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
            _buildOrderSummary(),
            SizedBox(height: 20),
            Text("Pilih Metode Pengiriman",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              color: Colors.black,
              fillColor: Colors.black,
              isSelected: [
                _selectedDeliveryOption == 0,
                _selectedDeliveryOption == 1
              ],
              onPressed: (int index) {
                setState(() {
                  _selectedDeliveryOption = index;
                });
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Antar Jemput"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Drop Off di Outlet"),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTextField("Nama"),
            _buildTextField("Link URL Penjemputan"),
            _buildTextField("Alamat"),
            _buildTextField("Nomor Telepon/WhatsApp"),
            _buildTextField("Jarak (km)", controller: _jarakController),
            _buildTextField("Catatan", isMultiline: true),
            SizedBox(height: 10),
            Text("Upload Foto Sepatu",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
              child: Text("Pilih File"),
            ),
            SizedBox(height: 20),
            Text("Metode Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              items: [
                DropdownMenuItem(
                    value: "Transfer Bank", child: Text("Transfer Bank")),
                DropdownMenuItem(value: "E-Wallet", child: Text("E-Wallet")),
                DropdownMenuItem(value: "COD", child: Text("COD")),
              ],
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Pembayaran Berhasil!")),
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text("Bayar Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
