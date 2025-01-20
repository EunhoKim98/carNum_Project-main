
class CarModel {
  final String acdnKindNm;
  final String acdnOccrDtm;
  final String dtaWrtDt;
  final String nowVhclNo;

  CarModel({
    required this.acdnKindNm,
    required this.acdnOccrDtm,
    required this.dtaWrtDt,
    required this.nowVhclNo,
  });

  // JSON 데이터를 CarModel 객체로 변환하는 메서드
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      acdnKindNm: json['acdnKindNm'],
      acdnOccrDtm: json['acdnOccrDtm'],
      dtaWrtDt: json['dtaWrtDt'],
      nowVhclNo: json['nowVhclNo'],
    );
  }

}
