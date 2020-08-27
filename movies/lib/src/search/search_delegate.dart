import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izq del appbar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.amber,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.getSearch(query.toLowerCase()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _listSearch(snapshot.data),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  Widget _listSearch(List<Pelicula> peliculas) {
    return ListView.builder(
      itemBuilder: (context, i) {
        peliculas[i].heroId = "${peliculas[i].id}-serach";

        return ListTile(
          leading: Container(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Hero(
              tag: peliculas[i].heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage(
                  placeholder: AssetImage("assets/imgs/no-image.jpg"),
                  image: NetworkImage(peliculas[i].getPosterImg()),
                  fit: BoxFit.cover,
                  width: 40.0,
                ),
              ),
            ),
          ),
          title: Text(peliculas[i].title),
          onTap: () {
            Navigator.pushNamed(context, "detalle", arguments: peliculas[i]);
          },
        );
      },
      itemCount: peliculas.length,
    );
  }
}
