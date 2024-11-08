import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_4/lat_8_juni/Model/model_kabupaten';
import 'package:mobile_4/rumah_sakit/screen_page/page_rs.dart';

class PageKabupaten extends StatefulWidget {
  final String idProv;

  const PageKabupaten({Key? key, required this.idProv}) : super(key: key);

  @override
  _PageKabupatenState createState() => _PageKabupatenState();
}

class _PageKabupatenState extends State<PageKabupaten> {
  bool isLoading = false;
  List<Datum> listKabupaten = [];
  List<Datum> filteredKabupaten = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getKabupaten();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getKabupaten() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse("http://192.168.216.154/rumahsakitDB/getKabupaten.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ModelKabupaten modelKabupaten = ModelKabupaten.fromJson(data);
          listKabupaten = modelKabupaten.data.where((datum) => datum.provinsiId == widget.idProv).toList();
          filteredKabupaten = List.from(listKabupaten);
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

  void searchKabupaten(String query) {
    setState(() {
      filteredKabupaten = listKabupaten.where((kabupaten) {
        return kabupaten.namaKabupaten.toLowerCase().contains(query.toLowerCase()) ||
            kabupaten.id.toLowerCase() == query.toLowerCase();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFff7074),
        title: Text(
          'Kabupaten / Kota',
          style: TextStyle(color: Colors.white,  fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchKabupaten,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                hintText: 'Search Kabupaten',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredKabupaten.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(3),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.1), // Menambahkan shadow color
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
                        leading: Image.asset('gambar/rs2.png', width: 40),
                        title: Text(
                          filteredKabupaten[index].namaKabupaten,
                          style: TextStyle(
                            color: Color(0xFFff7074),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageRumahSakit(kabupatenId: filteredKabupaten[index].id),
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