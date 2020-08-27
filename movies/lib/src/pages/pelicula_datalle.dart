import 'package:flutter/material.dart';
import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _crearAppBar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 10.0,
            ),
            _posterTitulo(pelicula),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _crearCasting(pelicula),
          ]),
        ),
      ],
    ));
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 4.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title, overflow: TextOverflow.ellipsis),
        background: FadeInImage(
          placeholder: AssetImage("assets/imgs/loading.gif"),
          image: NetworkImage(pelicula.getBackImg()),
          fadeInDuration: Duration(milliseconds: 500),
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pelicula.title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pelicula.originalTitle,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_border,
                    color: Colors.amber,
                  ),
                  Text(
                    pelicula.voteAverage.toString(),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final PeliculasProvider peliculasProvider = new PeliculasProvider();

    return Column(
      children: [
        Text(
          "Casting",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        FutureBuilder(
          future: peliculasProvider.getCast(pelicula.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return _crearActoresPageView(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
        height: 200.0,
        child: PageView.builder(
            pageSnapping: false,
            controller: PageController(viewportFraction: 0.3, initialPage: 1),
            itemCount: actores.length,
            itemBuilder: (context, i) {
              return _actorTarjeta(actores[i]);
            }));
  }

  Widget _actorTarjeta(Actor actor) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FadeInImage(
              placeholder: AssetImage("assets/imgs/no-image.jpg"),
              image: NetworkImage(actor.getProfileImg()),
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
