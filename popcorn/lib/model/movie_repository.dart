import 'package:githubtrends/services/api_service.dart';

import 'movie_response.dart';

class MovieRepository {
  final String _apiKey = "8d0bbe47677faff5e8d33e89d1aac537";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Movie>> fetchMovieList() async {
    final response = await _helper.get("movie/popular?api_key=$_apiKey");
    return MovieResponse.fromJson(response).results;
  }
}