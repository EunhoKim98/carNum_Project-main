import 'package:flutter/material.dart';
import 'package:car/models/car_model.dart';

class SearchResult extends StatelessWidget {
  final CarModel carModel;
  final String carNum;

  const SearchResult({super.key, required this.carModel, required this.carNum});

  @override
  Widget build(BuildContext context) {
    
    // 스크롤 변경
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Divider(color: Colors.grey, thickness: 2.0),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,

            child: DataTable(
                columns: [
                  DataColumn(
                    label: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '사고수준',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '사고날짜',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '차량번호',
                      ),
                    ),
                  ),
                ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                        Container(
                          child: Text(carModel.acdnKindNm),
                        ),
                      ),
                      DataCell(
                        Container(
                          child: Text(carModel.acdnOccrDtm),
                        ),
                      ),
                      DataCell(
                        Container(
                          child: Text(carModel.nowVhclNo),
                        ),
                      ),
                    ]),
                  ],
                ),
          ),

          Container(padding: const EdgeInsets.all(8)),
          const Icon(Icons.car_crash, color: Color.fromARGB(255, 0, 122, 255), size: 100),
          const Text("침 수 차 량", style: TextStyle(color: Color.fromARGB(255, 0, 122, 255), fontSize: 20)),
        ],
      ),
    );
  }
}
