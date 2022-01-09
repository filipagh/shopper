import 'package:home_storage/widgets/validator/utils/validator.dart';

String? multyValidate(List<Validator> validators) {
  try {
    for (var v in validators) {
      v.validate();
    }
  } on FormatException catch (e) {
    return e.message;
  }
  return null;
}
