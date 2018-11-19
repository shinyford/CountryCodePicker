import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> countryCodes;

  /// countryCodes passed as favorite
  final List<CountryCode> highlightedCountryCodes;

  SelectionDialog(this.countryCodes, this.highlightedCountryCodes);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  List<CountryCode> shownElements = [];

  @override
  Widget build(BuildContext context) {
    final List<CountryCode> options = [];
    final Size size = MediaQuery.of(context).size;
    if (widget.highlightedCountryCodes.isNotEmpty) {
      options
        ..addAll(widget.highlightedCountryCodes)
        ..add(null);
    }
    options..addAll(shownElements);
    return SimpleDialog(
      title: Column(
        children: [
          TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: _filterElements,
          ),
        ],
      ),
      children: [
        Container(
          height: size.height - 300.0,
          width: size.width - 300.0,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (BuildContext _, int index) => _countryCode(options[index]),
            itemExtent: 40.0,
          ),
        )
      ]
    );
  }

Widget _countryCode(CountryCode cc) =>
  cc == null
    ? Divider()
    : SimpleDialogOption(
        key: Key(cc.toLongString()),
        child: Stack(
          children: [
            Text(cc.flag, style: TextStyle(fontSize: 25.0)),
            Positioned(
              left: 35.0,
              top: 6.0,
              child: Text(
                cc.toLongString(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
        onPressed: () {
          _selectItem(cc);
        });

  @override
  void initState() {
    shownElements = widget.countryCodes;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      shownElements = widget.countryCodes
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
