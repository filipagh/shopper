import 'package:home_storage/screens/detail.dart';
import 'package:home_storage/utils/navigator/regex_custom_path.dart';

List<RegexCustomPath> globalRoutes = [
  RegexCustomPath(
    r'^/xxx/(\d*)$',
    (context, match) => DetailScreen(id: match),
  ),
];
