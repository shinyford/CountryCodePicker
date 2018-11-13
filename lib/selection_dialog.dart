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
  Widget build(BuildContext context) => SimpleDialog(
      title: Column(
        children: [
          TextField(
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: _filterElements,
          ),
        ],
      ),
      children: [
        widget.highlightedCountryCodes.isEmpty
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: []
                  ..addAll(widget.highlightedCountryCodes.map((f) {
                    return SimpleDialogOption(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(f.flag, style: TextStyle(fontSize: 20.0))
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                f.toLongString(),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _selectItem(f);
                        });
                  }).toList())
                  ..add(Divider())),
      ]..addAll(shownElements
          .map((e) => SimpleDialogOption(
              key: Key(e.toLongString()),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(e.flag, style: TextStyle(fontSize: 20.0))
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      e.toLongString(),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _selectItem(e);
              }))
          .toList()));

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
