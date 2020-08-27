import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/pelicula_model.dart';

import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = "f79ef72d3897800a4bc75d0658bd6527";
  String _url = 'api.themoviedb.org';
  String _language = "es-MX";

  int _pagePopulares = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _streamControllerPopulares =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _streamControllerPopulares.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _streamControllerPopulares.stream;

  Future<List<Pelicula>> getLiveNow() async {
    final url = Uri.https(_url, "3/movie/now_playing",
        {"api_key": _apiKey, "language": _language});

    return await _getAPI(url);
  }

  void getPopular() async {
    if (!_cargando) {
      _cargando = true;
      _pagePopulares++;
      final url = Uri.https(_url, "3/movie/popular", {
        "api_key": _apiKey,
        "language": _language,
        "page": _pagePopulares.toString()
      });

      final respuesta = await _getAPI(url);
      _populares.addAll(respuesta);
      popularesSink(_populares);
      _cargando = false;
    }
  }

  Future<List<Pelicula>> _getAPI(Uri url) async {
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    final peliculas =
        new Peliculas.fromJsonList(decodedData['results']).peliculas;
    return peliculas;
  }

  void disposeStreams() {
    _streamControllerPopulares?.close();
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(_url, "3/movie/$peliculaId/credits",
        {"api_key": _apiKey, "language": _language});

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    return Cast.fromJsonList(decodedData['cast']).actores;
  }

  Future<List<Pelicula>> getSearch(String query) async {
    final url = Uri.https(_url, "3/search/movie",
        {"api_key": _apiKey, "language": _language, "query": query});

    return await _getAPI(url);
  }
}
