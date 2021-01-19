import 'dart:convert';
import 'package:ara/models/badge.dart';
import 'package:flutter/material.dart';

class GreyImage extends StatelessWidget {
  final Badge _badge;
  final double _radius;

  const GreyImage({Badge badge, double radius, Key key})
      : _badge = badge,
        _radius = radius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
        colorFilter: _badge.redeemed
            ? ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply,
              )
            : ColorFilter.matrix(<double>[
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
        child: CircleAvatar(
          backgroundImage: MemoryImage(base64Decode(_badge.image)) ?? '',
          radius: _radius,
        ));
  }
}
