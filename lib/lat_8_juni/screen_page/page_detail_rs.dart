import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_4/lat_8_juni/Model/model_kamar.dart' as kamarModel;
import 'package:mobile_4/lat_8_juni/Model/model_rs.dart' as rsModel;

class PageDetailRS extends StatefulWidget {
  final rsModel.Datum rumahSakit;

  const PageDetailRS({Key? key, required this.rumahSakit}) : super(key: key);

  @override
  State<PageDetailRS> createState() => _PageDetailRSState();
}

class _PageDetailRSState extends State<PageDetailRS> {
  bool isLoading = false;
  List<kamarModel.Datum> listKamar = [];

  @override
  void initState() {
    super.initState();
    fetchKamarData(widget.rumahSakit.id);
  }

  Future<void> fetchKamarData(String rumahSakitId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.216.154/rumahsakitDB/getKamar.php?id_rs=$rumahSakitId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data kamar diterima: $data'); // Debug print

        setState(() {
          kamarModel.ModelKamar modelKamar = kamarModel.ModelKamar.fromJson(data);
          listKamar = modelKamar.data.where((kamar) => kamar.rumahsakitId == rumahSakitId).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rumahSakit.namaRs,
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFff7074),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.rumahSakit.lat), double.parse(widget.rumahSakit.long)),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.rumahSakit.id),
                    position: LatLng(double.parse(widget.rumahSakit.lat), double.parse(widget.rumahSakit.long)),
                    infoWindow: InfoWindow(
                      title: widget.rumahSakit.namaRs,
                      snippet: widget.rumahSakit.alamat,
                    ),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.rumahSakit.namaRs,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcc6066),
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoText('Alamat', widget.rumahSakit.alamat ?? 'N/A'),
                      _buildInfoText('Deskripsi', widget.rumahSakit.deskripsi ?? 'N/A'),
                      _buildInfoText('No Telp', widget.rumahSakit.noTelp ?? 'N/A'),
                    ],
                  ),

                  SizedBox(height: 16),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listKamar.length,
                    itemBuilder: (context, index) {
                      final kamar = listKamar[index];
                      return Padding(
                        padding: EdgeInsets.all(3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          color: Colors.white, // Mengubah warna card menjadi putih
                          shadowColor: Colors.grey.withOpacity(0.1), // Menambahkan shadow color
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(Icons.hotel, size: 40, color: Color(0xFFcc6066)),
                              title: Text(
                                kamar.namaKamar,
                                style: TextStyle(
                                  color: Color(0xFFcc6066),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kamar Tersedia: ${int.tryParse(kamar.kamarTersedia) ?? 0}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Kamar Kosong: ${int.tryParse(kamar.kamarKosong) ?? 0}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Jumlah Antrian: ${int.tryParse(kamar.jumlahAntrian) ?? 0}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoText(String label, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
