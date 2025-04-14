import 'package:flutter/material.dart';
import 'package:flutter_project_test/home_page.dart';
import 'promosi_page.dart';
import 'profile_page.dart';
import 'pesanan_page.dart';
import 'pesanansayapage.dart'; // pastikan path-nya sesuai

class KuponDiskonPage extends StatefulWidget {
  final String token;

  KuponDiskonPage({required this.token}); // ✅ Tambahkan token ke konstruktor

  @override
  _KuponDiskonPageState createState() => _KuponDiskonPageState();
}

class _KuponDiskonPageState extends State<KuponDiskonPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: widget.token)),
      );
    } else if (index == 1) {
      // Halaman Kupon saat ini, tidak perlu navigasi
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BuatPesananPage()),
      );
    } else if (index == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PesananSayaPage())); // 🆕 Ini dia!
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(token: widget.token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Kupon & Promosi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "Kupon"),
            Tab(text: "Promosi"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKuponTab(),
          PromosiPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: "Kupon"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildKuponTab() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        _buildVoucher("DISKON 30%", "Promo untuk Augment Treatment",
            "31 Maret 2025", "2025DISC30"),
        _buildVoucher("DISKON 15%", "Promo untuk Bag Treatment",
            "15 April 2025", "2025DISC15"),
        _buildVoucher(
            "DISKON 50%", "Diskon Spesial", "30 April 2025", "2025DISC50"),
      ],
    );
  }

  Widget _buildVoucher(
      String title, String description, String date, String code) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 5),
            Text(description,
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 8),
            Text("Berlaku s/d $date",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kode: $code",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Kode $code disalin")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text("Salin"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
