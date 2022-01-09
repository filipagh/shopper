

import 'utils/validator.dart';

class IdentityValidator extends Validator {
  late final dynamic o1;
  late final dynamic o2;

  IdentityValidator(this.o1, this.o2,this.errorMessage);

  @override
  void validate() {
      if (!identical(o1, o2)) {
        throw FormatException(errorMessage);
      }
  }

  @override
  String errorMessage;

}
