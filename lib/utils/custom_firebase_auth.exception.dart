import 'package:flutter/foundation.dart';

class CustomFirebaseAuthException {
  static void error(e) {
    switch (e.code) {
      case "provider-already-linked":
        if (kDebugMode) {
          print("The provider has already been linked to the user.");
        }
        break;
      case "invalid-credential":
        if (kDebugMode) {
          print("The provider's credential is not valid.");
        }
        break;
      case "credential-already-in-use":
        if (kDebugMode) {
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
        }
        break;
      case "account-exists-with-different-credential":
        if (kDebugMode) {
          print("The account already exists with a different credential");
        }
        break;
      // See the API reference for the full list of error codes.
      default:
        if (kDebugMode) {
          print(e);
          print("Unknown error.");
        }
    }
  }
}
