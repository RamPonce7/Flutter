import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';

class HorizontalMovieWidget extends StatelessWidget {
  final List<Pelicula> peliculas;

  final Function siguientePagina;

  HorizontalMovieWidget(
      {@required this.peliculas, @required this.siguientePagina});

  final _pageControler =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageControler.addListener(() {
      if (_pageControler.position.pixels >=
          (_pageControler.position.maxScrollExtent - 200)) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageControler,
        itemBuilder: _tarjeta,
        itemCount: peliculas.length,
      ),
    );
  }

  Widget _tarjeta(BuildContext context, int index) {
    peliculas[index].heroId = "${peliculas[index].id}-second";
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: peliculas[index].heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: AssetImage("assets/imgs/no-image.jpg"),
                image: NetworkImage(peliculas[index].getPosterImg()),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
          ),
          SizedBox(
            height: 2.5,
          ),
          Text(
            peliculas[index].title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, "detalle", arguments: peliculas[index]);
      },
    );
  }
}
