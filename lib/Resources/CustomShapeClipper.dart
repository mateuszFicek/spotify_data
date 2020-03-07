import 'package:flutter/material.dart';

/// Klasa, która zwraca ścieżkę do stworzenia UI.
/// Krzywa, które przechodzi przez pewne punkty i na jej podstawie przycina Container do odpowiadającego kształtu.
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 50, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
