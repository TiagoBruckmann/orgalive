import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class AccountFunction {

  decrementValue( num oldValue, num newValue ) {

    num value = oldValue - newValue;
    double valueReplaced = double.parse(value.toString());
    final MoneyMaskedTextController _finalValue = MoneyMaskedTextController( thousandSeparator: '.', decimalSeparator: ',', initialValue: valueReplaced );
    return _finalValue.text;

  }

  sumValue( num oldValue, num newValue ) {

    num value = oldValue + newValue;
    double valueReplaced = double.parse(value.toString());
    final MoneyMaskedTextController _finalValue = MoneyMaskedTextController( thousandSeparator: '.', decimalSeparator: ',', initialValue: valueReplaced );
    return _finalValue.text;

  }
}