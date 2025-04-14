import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PesananSayaPage extends StatefulWidget {
  const PesananSayaPage({super.key});

  @override
  _PesananSayaPageState createState() => _PesananSayaPageState();
}

class _PesananSayaPageState extends State<PesananSayaPage> {
  List<dynamic> pesananList = [];
  bool isLoading = true;

  final String baseUrl = 'http://192.168.1.13:8000';
  TextEditingController noTeleponController =
      TextEditingController(); // 👈 Tambahkan ini

  final List<String> statusList = [
    "pending",
    "diproses",
    "Terima orderan",
    "Proses Menyikat",
    "Proses Pengeringan",
    "Proses Cleaning",
    "Proses Mewangikan",
    "Proses Packing",
    "dikirim",
    "selesai",
  ];

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    setState(() {
      isLoading = true;
    });

    final String noTelepon = noTeleponController.text.trim();
    final url = Uri.parse(noTelepon.isEmpty
        ? '$baseUrl/api/pesanan'
        : '$baseUrl/api/pesanan?no_telepon=$noTelepon');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          pesananList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildPesananItem(dynamic pesanan) {
    final String? buktiTransfer = pesanan['bukti_transfer'];
    final String? imageUrl = (buktiTransfer != null && buktiTransfer.isNotEmpty)
        ? 'http://192.168.1.13:8000/uploads/${Uri.encodeComponent(buktiTransfer)}'
        : null;
    print(pesananList);

    final String statusPesanan = pesanan['status'];
    final int currentStep =
        statusList.indexOf(statusPesanan); // PENTING: pastikan ini ada!

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${pesanan['nama']}",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Telepon: ${pesanan['no_telepon']}"),
            Text("Alamat: ${pesanan['alamat']}"),
            Text("Layanan: ${pesanan['layanan_dipesan']}"),
            Text("Metode Pembayaran: ${pesanan['metode_pembayaran']}"),
            Text("Total: Rp ${pesanan['total_pembayaran']}"),
            Text("Status: ${pesanan['status']}"),
            Text("Catatan: ${pesanan['catatan'] ?? '-'}"),
            Text("Tanggal Pemesanan: ${pesanan['waktu_pemesanan']}"),
            Text("Jenis_pengiriman: ${pesanan['jenis_pengiriman']}"),
            Text("Jarak: ${pesanan['jarak']}"),
            SizedBox(height: 12),

            // Tracking status
            Text("Tracking Pesanan:",
                style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Column(
              children: List.generate(statusList.length, (index) {
                final status = statusList[index];
                final isActive = index <= currentStep;
                return Row(
                  children: [
                    Icon(
                      isActive
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isActive ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.grey,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 12),
            if (imageUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bukti Transfer:",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Text("Gagal memuat gambar"),
                    ),
                  ),
                ],
              )
            else
              Text("Bukti transfer: Tidak tersedia"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pesanan Saya")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: noTeleponController,
                    decoration: InputDecoration(
                      labelText: 'Cari berdasarkan No. Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: fetchPesanan,
                  child: Text("Cari"),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : pesananList.isEmpty
                    ? Center(child: Text("Belum ada pesanan"))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pesananList.length,
                        itemBuilder: (context, index) {
                          return buildPesananItem(pesananList[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
