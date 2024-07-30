
import 'package:flutter/material.dart';

typedef CloseLoadingScreen=bool Function();
typedef UpdateLoadingSScreen=bool Function(String text);

@immutable
class LoadingScreenController{
  final CloseLoadingScreen close;
  final UpdateLoadingSScreen update;

  const LoadingScreenController({required this.close, required this.update});
}