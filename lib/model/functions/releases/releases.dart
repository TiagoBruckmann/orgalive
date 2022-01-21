class ReleaseFunction {

  formatDate( int date ) {

    String? newDate;
    if ( date < 10 ) {
      newDate = "0$date";
    } else {
      newDate = date.toString();
    }

    return newDate;
  }

  formatMonth( String date ) {

    String day = date.split("-")[2].split(" ")[0];
    String month = date.split("-")[1];
    String year = date.split("-")[0];
    String newDate;

    if ( month == "01" ) {
      newDate = "$day de Janeiro de $year";
    } else if ( month == "02" ) {
      newDate = "$day de Fevereiro de $year";
    } else if ( month == "03" ) {
      newDate = "$day de Março de $year";
    } else if ( month == "04" ) {
      newDate = "$day de Abril de $year";
    } else if ( month == "05" ) {
      newDate = "$day de Maio de $year";
    } else if ( month == "06" ) {
      newDate = "$day de Junho de $year";
    } else if ( month == "07" ) {
      newDate = "$day de Julho de $year";
    } else if ( month == "08" ) {
      newDate = "$day de Agosto de $year";
    } else if ( month == "09" ) {
      newDate = "$day de Setembro de $year";
    } else if ( month == "10" ) {
      newDate = "$day de Outubro de $year";
    } else if ( month == "11" ) {
      newDate = "$day de Novembro de $year";
    } else {
      newDate = "$day de Dezembro de $year";
    }

    return newDate;
  }
}