import 'package:flutter/material.dart';

// Halaman Promosi tanpa tombol kembali dan tanpa tulisan "Promosi"
class PromosiPage extends StatefulWidget {
  @override
  _PromosiPageState createState() => _PromosiPageState();
}

class _PromosiPageState extends State<PromosiPage> {
  int _selectedIndex = 2; // Indeks default untuk halaman "Promosi"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logika untuk navigasi antar halaman bisa ditambahkan di sini
    print("Navigasi ke halaman indeks: $index");
    // Contoh: Navigator.pushReplacementNamed(context, '/halaman-lain');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildPromo(
              "Diskon 50%",
              "Dapatkan diskon 50% untuk semua produk",
              "https://via.placeholder.com/400x200?text=Diskon+50%",
            ),
            _buildPromo(
              "Promo Ultah",
              "Diskon spesial untuk pelanggan yang berulang tahun!",
              "https://via.placeholder.com/400x200?text=Promo+Ultah",
            ),
            _buildPromo(
              "Cashback 20%",
              "Dapatkan cashback hingga 20% setiap pembelian!",
              "https://via.placeholder.com/400x200?text=Cashback+20%",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromo(String title, String description, String imageUrl) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(imageUrl,
                fit: BoxFit.cover, width: double.infinity, height: 150),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(description, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
