import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_4/rumah_sakit/Model/model_provinsi.dart';
import 'page_kabupaten.dart';

class PageBeranda extends StatefulWidget {
  const PageBeranda({Key? key}) : super(key: key);

  @override
  State<PageBeranda> createState() => _PageBerandaState();
}

class _PageBerandaState extends State<PageBeranda> {
  bool isLoading = false;
  List<Datum> listProvinsi = [];
  List<Datum> filteredProvinsi = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProvinsi();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getProvinsi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse("http://192.168.216.154/rumahsakitDB/getProvinsi.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ModelProvinsi modelProvinsi = ModelProvinsi.fromJson(data);
          listProvinsi = modelProvinsi.data;
          filteredProvinsi = List.from(listProvinsi);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  void searchProvinsi(String query) {
    setState(() {
      filteredProvinsi = listProvinsi.where((provinsi) {
        return provinsi.namaProvinsi.toLowerCase().contains(query.toLowerCase()) ||
            provinsi.id.toLowerCase() == query.toLowerCase();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'MediSearch',
          style: TextStyle(
            color: Color(0xFFff7074),
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Image.asset('gambar/rs3.png', width: 600, height: 130), // Mengatur ukuran gambar
                SizedBox(height: 2), // Memberikan jarak vertikal antara gambar dan teks
                Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF023047),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchProvinsi,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Provinsi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProvinsi.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(3),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageKabupaten(idProv: filteredProvinsi[index].id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Image.asset('gambar/rs1.png', width: 35),
                          title: Text(
                            filteredProvinsi[index].namaProvinsi,
                            style: TextStyle(
                              color: Color(0xFFff7074),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
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
