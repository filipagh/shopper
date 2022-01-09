import 'package:home_storage/widgets/validator/utils/validator.dart';

class MailValidator extends Validator {
  late final String? value;

  MailValidator(this.value, this.errorMessage);

  @override
  void validate() {
    if (value == null || !_testMail(value)) {
      throw FormatException(errorMessage);
    }
  }

  bool _testMail(value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  @override
  String errorMessage;
}
