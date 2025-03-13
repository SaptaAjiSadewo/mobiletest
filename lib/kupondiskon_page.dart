import 'package:flutter/material.dart';
import 'home_page.dart';
import 'promosi_page.dart';

class KuponDiskonPage extends StatefulWidget {
  @override
  _KuponDiskonPageState createState() => _KuponDiskonPageState();
}

class _KuponDiskonPageState extends State<KuponDiskonPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1; // Index 'Kupon' di BottomNavigationBar

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
          context, MaterialPageRoute(builder: (context) => HomePage(name: "")));
    } else if (index == 2) {
      // Nanti ganti dengan halaman Keranjang
      print("Navigasi ke Keranjang");
    } else if (index == 3) {
      // Nanti ganti dengan halaman Profil
      print("Navigasi ke Profil");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Kupon & Promosi',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: "Kupon Diskon"),
            Tab(text: "Promosi"),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PromosiPage()));
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildVoucher("DISKON 30%", "Promo untuk Aughment treatment",
                "22 Februari 2025", "2025DISC30"),
            _buildVoucher("DISKON 50%", "Promo untuk Shoes treatment",
                "5 Maret 2025", "2025DISC50"),
            _buildVoucher("DISKON 15%", "Promo untuk Bag treatment",
                "15 Maret 2025", "2025DISC50"),
            _buildVoucher("DISKON 20%", "Promo untuk Repaint treatment",
                "13 Februari 2025", "2025DISC50"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: "Kupon"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildVoucher(
      String title, String description, String date, String code) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.percent, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Berlaku s/d $date",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(description,
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    Text("Kode : $code",
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
