/// @author: Andreas Ambühl, https://github.com/AndiSwiss
///
/// This file is for testing only - run separately in your IDE
/// I mainly developed the string-conversions of the ratings with this file.
main() {
  SimpleMovie movie = SimpleMovie();
  print(movie.convertRatingsToOneString());

  print('\n-- RATE the movie:');
  rateMovie(movie);
  print(movie.convertRatingsToOneString());

//  // The following updates the first two elements, but would throw an error:
//  movie.convertStringToRatings("4.3 -24.5");
//  print(movie.convertRatingsToOneString());

  print('\n-- NEW rating from a string:');
  String newRatingString =
      "0 0.0 1.11111 33.23 10.0 10.0 99.999 11.2394892212333122231 77";
  movie.convertStringToRatings(newRatingString);
  print(movie.convertRatingsToOneString());

  print('\n-- Getting the object print-out:');
  print(movie);
}

class SimpleMovie {
  double abstractness = 50;
  double cinematography = 50;
  double romanticness = 50;
  double complexity = 50;
  double darkness = 50;
  double humor = 50;
  double realism = 50;
  double suspense = 50;
  double wokeness = 50;

  String convertRatingsToOneString() {
    return '$abstractness $cinematography $romanticness $complexity $darkness '
        '$humor $realism $suspense $wokeness';
  }

  bool convertStringToRatings(String string) {
    // Try with NO error handling -> it really should not occur, otherwise
    // as a dev, I should see the error!
//    try {
    List<double> individual = string.split(' ').map(double.parse).toList();
    abstractness = individual.removeAt(0);
    cinematography = individual.removeAt(0);
    romanticness = individual.removeAt(0);
    complexity = individual.removeAt(0);
    darkness = individual.removeAt(0);
    humor = individual.removeAt(0);
    realism = individual.removeAt(0);
    suspense = individual.removeAt(0);
    wokeness = individual.removeAt(0);
//    } catch (e) {
//      print('ERROR: ${e.toString()}');
//    }
  }

  @override
  String toString() {
    return 'SimpleMovie{abstractness: $abstractness, '
        'cinematography: $cinematography, romanticness: $romanticness, '
        'complexity: $complexity, darkness: $darkness, humor: $humor, '
        'realism: $realism, suspense: $suspense, wokeness: $wokeness}';
  }
}

rateMovie(SimpleMovie movie) {
  movie.abstractness = 20.0;
  movie.cinematography = 75.4;
  movie.romanticness = 40.2;
  movie.complexity = 0.0;
  movie.darkness = 100.0;
  movie.humor = 50.04;
  movie.realism = 30.324532;
  movie.suspense = 23.34;
  movie.wokeness = 14.14;
}
