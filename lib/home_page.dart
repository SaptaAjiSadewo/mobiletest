import 'package:flutter/material.dart';
import 'package:flutter_project_test/pesanan_page.dart';
import 'kupondiskon_page.dart';
import 'profile_page.dart'; // pastikan path-nya sesuai
import 'pesanansayapage.dart'; // pastikan path-nya sesuai

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> kuponList = [
    {
      "title": "DISKON 30%",
      "desc": "Aughment treatment",
      "date": "22 Februari 2025"
    },
    {"title": "DISKON 50%", "desc": "Shoes treatment", "date": "5 Maret 2025"},
    {"title": "DISKON 15%", "desc": "Bag treatment", "date": "15 Maret 2025"},
    {"title": "DISKON 10%", "desc": "Carpet treatment", "date": "1 April 2025"},
    {"title": "DISKON 20%", "desc": "Jacket treatment", "date": "10 Mei 2025"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // ✅ Tetap di halaman Home
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KuponDiskonPage(token: widget.token)));
    } else if (index == 2) {
      // ✅ Pindah ke halaman Keranjang (PesananPage)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BuatPesananPage()));
    } else if (index == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PesananSayaPage())); // 🆕 Ini dia!
    } else if (index == 4) {
      // ✅ Navigasi ke halaman profil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(token: widget.token),
        ),
      );
    }
  }

  /// ✅ Pindahkan fungsi ini keluar dari `onPressed`
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ✅ Tutup dialog tanpa logout
              },
              child: Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ✅ Tutup dialog
                Navigator.pushReplacementNamed(context, "/"); // ✅ Logout
              },
              child: Text("Ya", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.token; // Tetap menggunakan variabel ini untuk header

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _showLogoutConfirmationDialog(context); // ✅ Tidak error lagi
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Ucapan (TETAP SESUAI PERMINTAAN)
              Text(
                "Halo, $name!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Banner Promo
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PesananSayaPage()),
                  );
                },
                icon: Icon(Icons.receipt_long),
                label: Text("Pesanan Saya"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),

              SizedBox(height: 20),

              // Menu Kupon & Promosi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuItem(Icons.local_offer, "Kupon/diskon"),
                  menuItem(Icons.campaign, "Promosi"),
                ],
              ),
              SizedBox(height: 20),

              // List Kupon
              Text("Kupon",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: kuponList.length,
                itemBuilder: (context, index) {
                  final kupon = kuponList[index];
                  return kuponItem(
                      kupon['title']!, kupon['desc']!, kupon['date']!);
                },
              ),
            ],
          ),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.black),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget kuponItem(String title, String desc, String date) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.local_offer, color: Colors.black),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(desc, softWrap: true),
            Text("Berlaku s/d $date",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
