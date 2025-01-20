import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  List<String> _carNumbers = [];
  List<String> _acdnKindNms = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // 검색 이력 로드
  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _carNumbers = prefs.getStringList('carNumbers') ?? [];
      _acdnKindNms = prefs.getStringList('acdnKindNms') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '검색이력',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 54, 52, 163),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DataTable(
                columns: const [
                  DataColumn(label: Text('차량 번호')),
                  DataColumn(label: Text('사고 수준')),
                ],
                rows: List<DataRow>.generate(
                  _carNumbers.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(Text(_carNumbers[index])),
                      DataCell(Text(_acdnKindNms[index])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
