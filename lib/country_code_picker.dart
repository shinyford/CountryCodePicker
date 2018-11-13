library country_code_picker;

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_data.dart';
import 'package:country_code_picker/selection_dialog.dart';
import 'package:flutter/material.dart';

export 'country_code.dart';

class CountryCodePicker extends StatefulWidget {
  final Function(CountryCode) onChanged;
  final String initialSelection;
  final List<String> favorites;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  CountryCodePicker({
    this.onChanged,
    this.initialSelection,
    this.favorites = const [],
    this.textStyle,
    this.padding
  });

  @override
  State<StatefulWidget> createState() {
    List<CountryCode> countryCodes =
        countryCodeData
          .map((countryCodeDatum) => CountryCode.from(countryCodeDatum))
          .toList();

    return new _CountryCodePickerState(countryCodes, favorites);
  }
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  CountryCode selectedItem;

  final List<CountryCode> countryCodes;
  final List<CountryCode> highlightedCountryCodes;
  Widget selectionDialog;

  _CountryCodePickerState(this.countryCodes, favorites)
    : this.highlightedCountryCodes = List<CountryCode>.from(
        favorites.map((String code) =>
          countryCodes.firstWhere((e) => e.code == code || e.dialCode == code)
        ).toList()
      );

  @override
  Widget build(BuildContext context) =>
      FlatButton(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(selectedItem.flag, style: TextStyle(fontSize: 20.0))
              ),
            ),
            Flexible(
              child: Text(
                selectedItem.toString(),
                style: widget.textStyle ?? Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
        padding: widget.padding,
        onPressed: _showSelectionDialog,
      );

  @override
  initState() {
    if (widget.initialSelection != null) {
      selectedItem = countryCodes.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => countryCodes[0]);
    } else {
      selectedItem = countryCodes[0];
    }

    Future(() {
      selectionDialog = SelectionDialog(countryCodes, highlightedCountryCodes);
    });

    super.initState();

    if (mounted) {
      _publishSelection(selectedItem);
    }
  }

  void _showSelectionDialog() {
    if (selectionDialog == null) {
      selectionDialog = SelectionDialog(countryCodes, highlightedCountryCodes);
    }

    showDialog(
      context: context,
      builder: (_) => selectionDialog,
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        _publishSelection(e);
      }
    });
  }

  void _publishSelection(CountryCode e) {
    if (widget.onChanged != null) widget.onChanged(e);
  }
}
