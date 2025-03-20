import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'checkout_page.dart';

class BuatPesananPage extends StatefulWidget {
  @override
  _BuatPesananPageState createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  List<dynamic> layananList = [];
  Map<String, List<int>> layananGrouped =
      {}; // Menyimpan harga berdasarkan nama layanan
  Map<String, int> layananDipilih = {};
  Map<String, int?> hargaDipilih = {}; // Menyimpan harga yang dipilih pengguna

  @override
  void initState() {
    super.initState();
    fetchLayanan();
  }

  Future<void> fetchLayanan() async {
    try {
      final response =
          await http.get(Uri.parse("http://kien api e ira:8000/api/get_layanan"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          layananList = data; // Perbaikan utama: layananList harus diisi
          layananGrouped.clear();
          for (var layanan in data) {
            String nama = layanan["nama"];
            int harga = layanan["harga"];
            layananGrouped.putIfAbsent(nama, () => []).add(harga);
          }
        });
      }
    } catch (e) {
      print("Error fetching layanan: $e");
    }
  }

  int hitungTotalHarga() {
    int total = 0;
    layananDipilih.forEach((key, value) {
      final harga = hargaDipilih[key] ?? 0; // Gunakan harga yang dipilih
      total += harga * value;
    });
    return total;
  }

  void tambahLayanan(String layanan) {
    setState(() {
      if (hargaDipilih[layanan] != null) {
        // Pastikan harga telah dipilih
        layananDipilih[layanan] = (layananDipilih[layanan] ?? 0) + 1;
      }
    });
  }

  void kurangiLayanan(String layanan) {
    setState(() {
      if (layananDipilih.containsKey(layanan) && layananDipilih[layanan]! > 1) {
        layananDipilih[layanan] = layananDipilih[layanan]! - 1;
      } else {
        layananDipilih.remove(layanan);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Pesanan")),
      body: layananGrouped.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: layananGrouped.entries.map((entry) {
                String nama = entry.key;
                List<int> hargaOptions =
                    entry.value.toSet().toList(); // Hilangkan harga duplikat

                return ListTile(
                  title: Text(nama),
                  subtitle: DropdownButton<int>(
                    value: hargaDipilih[nama],
                    hint: Text("Pilih harga"),
                    onChanged: (int? newValue) {
                      setState(() {
                        hargaDipilih[nama] = newValue;
                        layananDipilih[nama] =
                            1; // Perbaikan utama: otomatis pilih layanan saat harga dipilih
                      });
                    },
                    items: hargaOptions.map((harga) {
                      return DropdownMenuItem<int>(
                        value: harga,
                        child: Text("Rp. $harga"),
                      );
                    }).toList(),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: (layananDipilih[nama] ?? 0) > 0
                            ? () => kurangiLayanan(nama)
                            : null,
                      ),
                      Text("${layananDipilih[nama] ?? 0}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => tambahLayanan(nama),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: layananDipilih.isEmpty || hitungTotalHarga() == 0
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                          layananDipilih: layananDipilih,
                          totalHarga: hitungTotalHarga(),
                          layananList: layananList),
                    ),
                  );
                },
          child: Text("Checkout - Rp. ${hitungTotalHarga()}"),
        ),
      ),
    );
  }
}
