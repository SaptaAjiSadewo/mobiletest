import 'package:flutter/material.dart';

class BuatPesananPage extends StatefulWidget {
  @override
  _BuatPesananPageState createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  Map<String, int> layananDipilih = {};
  Map<String, int> hargaLayanan = {
    "Quick clean (5 jam)": 20000,
    "Deep clean (3 hari)": 40000,
    "Leather care/perawatan sepatu kulit (3 hari)": 55000,
    "Kids shoes cleaning (2 hari)": 20000,
    "Women shoes (2 hari)": 25000,
    "Unyellowing midsole (4 hari)": 65000,
    "Cap cleaning (2 hari)": 20000,
    "Sandals cleaning (2 hari)": 85000,
  };

  Map<String, bool> kategoriTerbuka = {
    "SHOES TREATMENT": true,
    "AUGMENT": true,
  };

  int hitungTotalHarga() {
    int total = 0;
    layananDipilih.forEach((key, value) {
      total += (hargaLayanan[key] ?? 0) * value;
    });
    return total;
  }

  void tambahLayanan(String layanan) {
    setState(() {
      layananDipilih[layanan] = (layananDipilih[layanan] ?? 0) + 1;
    });
  }

  void kurangiLayanan(String layanan) {
    setState(() {
      if (layananDipilih[layanan] != null && layananDipilih[layanan]! > 0) {
        layananDipilih[layanan] = layananDipilih[layanan]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Buat Pesanan',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildKategori("SHOES TREATMENT", [
                    "Quick clean (5 jam)",
                    "Deep clean (3 hari)",
                    "Leather care/perawatan sepatu kulit (3 hari)",
                    "Kids shoes cleaning (2 hari)",
                    "Women shoes (2 hari)",
                    "Unyellowing midsole (4 hari)"
                  ]),
                  _buildKategori("AUGMENT", [
                    "Cap cleaning (2 hari)",
                    "Sandals cleaning (2 hari)"
                  ]),
                ],
              ),
            ),
            _buildTotalHarga(),
          ],
        ),
      ),
    );
  }

  Widget _buildKategori(String kategori, List<String> layanan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              kategoriTerbuka[kategori] = !(kategoriTerbuka[kategori] ?? true);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kategori,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                kategoriTerbuka[kategori]! ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                size: 24,
              ),
            ],
          ),
        ),
        if (kategoriTerbuka[kategori]!)
          Column(
            children: layanan.map((layanan) => _buildLayanan(layanan)).toList(),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLayanan(String layanan) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(layanan, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Rp. ${hargaLayanan[layanan]}", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              _buildButton(Icons.remove, () => kurangiLayanan(layanan)),
              SizedBox(width: 10),
              Text(
                "${layananDipilih[layanan] ?? 0}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              _buildButton(Icons.add, () => tambahLayanan(layanan)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buildTotalHarga() {
    return Column(
      children: [
        Divider(thickness: 1),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Rp. ${hitungTotalHarga()}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Aksi Checkout
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          ),
          child: Text("Checkout", style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
