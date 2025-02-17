import 'package:car/ad_helper.dart';

AdHelper? _adHelper;

AdHelper adHelper() {
  if (_adHelper == null) {
    _adHelper = AdHelper();
  }
  return _adHelper!;
}
