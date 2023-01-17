import 'package:flutter/material.dart';

class ForbiddenMouseCursor extends MaterialStateMouseCursor {
  const ForbiddenMouseCursor();

  @override
  MouseCursor resolve(Set<MaterialState> states) =>
      SystemMouseCursors.forbidden;

  @override
  String get debugDescription => 'ForbiddenMouseCursor()';
}
