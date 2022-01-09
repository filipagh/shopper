import 'package:flutter/cupertino.dart';

class RegexCustomPath {
  const RegexCustomPath(this.pattern, this.builder);

  final String pattern;
  final Widget Function(BuildContext, String) builder;
}
