import 'package:flutter/material.dart';
import 'package:udacity_flutter_app/Unit.dart';
import 'package:meta/meta.dart';

const _paddingConstantOnTopOfThisFile = EdgeInsets.all(16.0);

class ConverterRoute extends StatefulWidget {
  final List<Unit> units;
  final String name;
  final Color color;

  const ConverterRoute({
    @required this.units,
    @required this.name,
    @required this.color,
  })  : assert(units != null),
        assert(name != null),
        assert(color != null);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ConverterRouteState();
  } //end of createState()

}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createDPMenuItems();
    _setDefaultsValues();
  }

  void _createDPMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    } //for loop
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s.
  void _setDefaultsValues() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }

  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  ///update the _convertedValue whcih is a String
  void _updateTheConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  ///update the _inputValue
  void _updateTheInputValueWithString(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          var inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateTheConversion();
        } on Exception catch (e) {
          print('-------------------------------- Error: $e');
          _showValidationError = true;
        }
      }
    });
  } //

  ///get the Unit
  Unit _getTheUnitWithItsStringName(String unitName) {
    return widget.units.firstWhere((Unit unit) {
      return unit.name == unitName;
    }, orElse: null);
  }

  ///update _fromValue with dynamic unitName
  void _updateFromValueWithDynamicUnitName(dynamic unitName) {
    setState(() {
      _fromValue = _getTheUnitWithItsStringName(unitName);
    });
    if (_inputValue != null) _updateTheConversion();
  }

  ///update _toValueWithDynamicUnitName
  void _updateToValueWithDynamicUnitName(dynamic unitName) {
    setState(() {
      _toValue = _getTheUnitWithItsStringName(unitName);
    });
    if (_inputValue != null) _updateTheConversion();
  }

  ///Create the actual Dropdown widget
  Widget _createTheActualDP(
      String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.grey[50]),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    final textFieldWidgets = Padding(
      padding: _paddingConstantOnTopOfThisFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              errorText: _showValidationError ? 'Invalid input' : null,
              labelText: 'input some number here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateTheInputValueWithString,
          ),
          _createTheActualDP(
              _fromValue.name, _updateFromValueWithDynamicUnitName),
        ],
      ),
    );

    // TODO: Create a compare arrows icon.
    final compareArrow = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].
    final outputText = Padding(
      padding: _paddingConstantOnTopOfThisFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createTheActualDP(_toValue.name, _updateToValueWithDynamicUnitName),
        ],
      ),
    );

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    final returnLayout = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        textFieldWidgets,
        compareArrow,
        outputText,
      ],
    );

    // TODO: Delete the below placeholder code.

    return Padding(
      padding: _paddingConstantOnTopOfThisFile,
      child: returnLayout,
    );
  } //end of build()

} //end of ConverterRoute class
