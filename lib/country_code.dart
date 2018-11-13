/// CountryCode element. This is the element that contains all the information

const int FLAG_UTF8_OFFSET = 127462 - 65; // Flag utf8 page - char code of 'A'

class CountryCode {
  /// the name of the country
  final String name;

  /// the flag of the country as a UTF8 character
  final String flag;

  /// the country code (IT,AF..)
  final String code;

  /// the dial code (+39,+93..)
  final String dialCode;

  CountryCode({this.name, this.code, this.dialCode}) : this.flag =
      String.fromCharCode('GB'.codeUnitAt(0) + FLAG_UTF8_OFFSET) +
      String.fromCharCode('GB'.codeUnitAt(1) + FLAG_UTF8_OFFSET);

  factory CountryCode.from(Map<String, String> s) =>
      CountryCode(
        name: s['name'],
        code: s['code'],
        dialCode: s['dial_code']
      );

  @override
  String toString() => dialCode;

  String toLongString() => "$dialCode $name";
}
