import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

Widget imagecarousel = Container(
  height: 100.0,
  margin: EdgeInsets.only(
    right: 10.0,
    left: 10.0,
  ),
  child: Carousel(
    boxFit: BoxFit.cover,
    images: [
      AssetImage('assets/images/ad_image_horizontal.png'),
      AssetImage('assets/images/ad_image_horizontal.png'),
      AssetImage('assets/images/ad_image_1.png'),
      AssetImage('assets/images/ad_image_1.png'),
    ],
    showIndicator: false,
    autoplay: true,
    animationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 1000),
  ),
);
