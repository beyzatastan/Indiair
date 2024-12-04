import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState(); 
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _cities = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara', 
    'Antalya', 'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 
    'Bitlis', 'Bolu', 'Burdur', 'Bursa',
  ];
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities; 
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _cities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onCityTap(String city) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$city seçildi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şehir Seçiniz',),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama çubuğu
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _controller,
                onChanged: _filterCities,
                decoration: InputDecoration(
                  labelText: 'Şehir Ara',
                  hintText: 'Şehir adı yazın...',
                  prefixIcon: const Icon(Icons.search),
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                ),
              ),
            ),
            // Eğer şehirler boşsa, bir mesaj göster
            if (_filteredCities.isEmpty)
              Center(child: Text('Hiçbir şehir bulunamadı!')),
            // Liste
            if (_filteredCities.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCities.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3.0,
                      child: ListTile(
                        title: Text(
                          _filteredCities[index],
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () => _onCityTap(_filteredCities[index]),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
