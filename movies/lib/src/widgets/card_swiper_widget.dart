import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/pelicula_model.dart';

class CardSwiperWidget extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiperWidget({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].heroId = "${peliculas[index].id}-main";
          return GestureDetector(
            child: Hero(
              tag: peliculas[index].heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/imgs/no-image.jpg"),
                  image: NetworkImage(
                    peliculas[index].getPosterImg(),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "detalle",
                  arguments: peliculas[index]);
            },
          );
        },
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemCount: peliculas.length,
      ),
    );
  }
}
