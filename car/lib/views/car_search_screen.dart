import 'package:flutter/material.dart';
import 'package:car/models/car_model.dart';
import 'package:car/views/search_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:car/provider.dart';

class CarSearchScreen extends StatefulWidget {
  const CarSearchScreen({super.key});

  @override
  State<CarSearchScreen> createState() => _CarSearchScreenState();
}

class _CarSearchScreenState extends State<CarSearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _carNum;
  CarModel? _carModel;
  BannerAd? _banner; // 광고

  // 광고
  @override
  void initState() {
    super.initState();
    adHelper().loadBanner((ad) {
      setState(() {
        _banner = ad;
      });
    });
  }

  // 광고
  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  Future<CarModel?> searchCar(String carNum) async {
    String url = 'http://54.180.109.207:5000/api/cars?carNum=$carNum';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse == null || jsonResponse.isEmpty) {
          print('No data found');
          return null;
        }
        return CarModel.fromJson(jsonResponse);
      } else {
        print('Failed to load car data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('API ERROR: $e');
      return null;
    }
  }

  // 검색 이력 저장
  Future<void> _saveSearchHistory(String carNum, String acdnKindNm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 기존 이력 로드
    List<String> carNumbers = prefs.getStringList('carNumbers') ?? [];
    List<String> acdnKindNms = prefs.getStringList('acdnKindNms') ?? [];

    // 새로운 이력 추가 (가장 앞에 추가)
    carNumbers.insert(0, carNum);
    acdnKindNms.insert(0, acdnKindNm);

    // 저장
    await prefs.setStringList('carNumbers', carNumbers);
    await prefs.setStringList('acdnKindNms', acdnKindNms);
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '차량 검색',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 54, 52, 163),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SearchForm(
                    formKey: _formKey,
                    onSaved: (value) {
                      _carNum = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차량 번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(7.0),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState?.save();

                        searchCar(_carNum!).then((car) {
                          setState(() {
                            _carModel = car;
                          });
                          if (_carModel != null) {
                            _saveSearchHistory(_carNum!, _carModel!.acdnKindNm);
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 54, 52, 163), // 배경색 설정
                    ),
                    child: const Text('검색'),
                  ),
                ],
              ),
            ),
            // 차량 정보를 표로 보여주는 부분
            if (_carModel != null) ...[
              SizedBox(height: 15),
              SearchResult(carModel: _carModel!, carNum: _carNum!),
            ] else if (_carModel == null && _carNum != null) ...[
              Icon(
                Icons.gpp_good,
                color: Color.fromARGB(255, 0, 122, 255),
                size: 100,
              ),
              Text(
                "침수 이력이 없습니다.",
                style: TextStyle(color: Color.fromARGB(255, 0, 122, 255), fontSize: 20),
              ),
            ],
            // 배너 광고 및 그리드 뷰 표시
            if (banner != null) ...[
              _buildBanner(banner), // 배너 광고 표시
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BannerAd ad) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
    this.formKey,
    this.isEnabled = true,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final GlobalKey<FormState>? formKey;
  final bool isEnabled;
  final ValueChanged<String?>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autofocus,
      decoration: const InputDecoration(
        labelText: '차량 번호 입력',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 54, 52, 163), // 포커스 시 색상
          ),
        ),
      ),
    );
  }
}
