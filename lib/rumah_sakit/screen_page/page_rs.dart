import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_4/rumah_sakit/Model/model_rs.dart';
import 'package:mobile_4/rumah_sakit/screen_page/page_detail_rs.dart';

class PageRumahSakit extends StatefulWidget {
  final String kabupatenId;

  const PageRumahSakit({Key? key, required this.kabupatenId}) : super(key: key);

  @override
  State<PageRumahSakit> createState() => _PageRumahSakitState();
}

class _PageRumahSakitState extends State<PageRumahSakit> {
  bool isLoading = false;
  List<Datum> listRumahSakit = [];
  List<Datum> filteredRumahSakit = [];

  @override
  void initState() {
    super.initState();
    fetchRumahSakitData();
  }

  Future<void> fetchRumahSakitData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.216.154/rumahsakitDB/getRS.php?id_kabupaten=${widget.kabupatenId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ModelRs modelRs = ModelRs.fromJson(data);
          listRumahSakit = modelRs.data.where((datum) => datum.kabupatenId == widget.kabupatenId).toList();
          filteredRumahSakit = List.from(listRumahSakit);
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

  void searchRumahSakit(String query) {
    setState(() {
      filteredRumahSakit = listRumahSakit.where((rumahSakit) {
        return rumahSakit.namaRs.toLowerCase().contains(query.toLowerCase()) ||
            rumahSakit.id.toLowerCase() == query.toLowerCase();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFff7074),
        title: Text(
          'Daftar Rumah Sakit',
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchRumahSakit,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                hintText: 'Search Rumah Sakit',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRumahSakit.length,
              itemBuilder: (context, index) {
                final rumahSakit = filteredRumahSakit[index];
                return Padding(
                  padding: EdgeInsets.all(3),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    // Mengubah warna card menjadi putih
                    shadowColor: Colors.grey.withOpacity(0.1),
                    // Menambahkan shadow color
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                        leading: Image.network(
                          'http://192.168.216.154/rumahsakitDB/gambar/${rumahSakit
                              .gambar}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          rumahSakit.namaRs,
                          style: TextStyle(
                            color: Color(0xFFcc6066),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat: ${rumahSakit.alamat ?? 'N/A'}',
                              style: TextStyle(color: Color(0xFFcc6066)),
                            ),
                            Text(
                              'Deskripsi: ${rumahSakit.deskripsi ?? 'N/A'}',
                              style: TextStyle(color: Color(0xFFcc6066)),
                              maxLines: 1, // Maksimal satu baris
                              overflow: TextOverflow
                                  .ellipsis, // Menampilkan tanda titik-titik jika terlalu panjang
                            ),
                            Text(
                              'No Telp: ${rumahSakit.noTelp ?? 'N/A'}',
                              style: TextStyle(color: Color(0xFFcc6066)),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailRS(
                                      rumahSakit: filteredRumahSakit[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}