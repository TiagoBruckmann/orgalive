// imports nativos do flutter
import 'dart:math';

class SharedFunctions {

  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  getRandomString( int length ) {
    return String.fromCharCodes(

      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );

  }

  // buscar o ultimo dia do mes
  getLastDay() {

    DateTime dateTime = DateTime.now();
    int lastDay = 30;
    switch( dateTime.month ) {
      case( 1 ):
        lastDay = 31;
        break;
      case( 2 ):
        lastDay = 28;
        break;
      case( 3 ):
        lastDay = 31;
        break;
      case( 4 ):
        lastDay = 30;
        break;
      case( 5 ):
        lastDay = 31;
        break;
      case( 6 ):
        lastDay = 30;
        break;
      case( 7 ):
        lastDay = 31;
        break;
      case( 8 ):
        lastDay = 31;
        break;
      case( 9 ):
        lastDay = 30;
        break;
      case( 10 ):
        lastDay = 31;
        break;
      case( 11 ):
        lastDay = 30;
        break;
      case( 12 ):
        lastDay = 31;
        break;
    }

    return lastDay;
  }

}