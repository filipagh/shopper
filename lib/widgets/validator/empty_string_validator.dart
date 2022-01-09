import 'utils/validator.dart';

class EmptyValidator extends Validator {
  @override
  String errorMessage;
  late final String? value;

  EmptyValidator(this.value, this.errorMessage);

  @override
  void validate() {
    if (value == null || value!.isEmpty) {
      throw FormatException(errorMessage);
    }
  }
}
