import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CustomImage {
  static ImageProvider createProvider(String url) {
    return ExtendedImage.network(
      url,
      fit: BoxFit.cover,
      cache: true,
      imageCacheName: "$url",
    ).image;
  }
}
