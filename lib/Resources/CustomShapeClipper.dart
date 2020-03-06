import 'package:flutter/material.dart';

/// Klasa, która zwraca ścieżkę do stworzenia UI.
/// Krzywa, które przechodzi przez pewne punkty i na jej podstawie przycina Container do odpowiadającego kształtu.
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);

    var firstEndPoint = Offset(size.width, size.height * 0.5);
    var firstControlpoint = Offset(size.width, size.height * 0.95);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height * 0.5);
    var secondControlPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
