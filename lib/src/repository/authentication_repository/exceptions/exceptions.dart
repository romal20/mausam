class Exceptions implements Exception{
  final String message;
  const Exceptions([this.message = 'An unknown exception occurred.']);
  factory Exceptions.fromCode(String code){
    switch(code){
      case 'email-already-in-use':
        return const Exceptions('Email already exists.');
      case 'invalid-email':
        return const Exceptions('Email is not valid or badly formatted.');
      case 'weak-password':
        return const Exceptions('Please enter a strong password.');
      case 'user-disabled':
        return const Exceptions('The user has been disabled. Please contact support for help.');
      case 'user-not-found':
        return const Exceptions('Invalid Details, please create an account.');
      case 'wrong-password':
        return const Exceptions('Incorrect password, please try again.');
      case 'too-many-requests':
        return const Exceptions('Too many requests, service temporarily blocked.');
      case 'invalid-argument':
        return const Exceptions('An invalid argument was provided to an authentication method.');
      case 'invalid-password':
        return const Exceptions('Incorrect password, please try again.');
      case 'invalid-phone-number':
        return const Exceptions('The provided phone number is invalid.');
      case 'operation-not-allowed':
        return const Exceptions('The provided sign-in provider is disabled for your firebase project.');
      case 'session-cookie-expired':
        return const Exceptions('The provided firebase session cookie is expired');
      case 'uid-already-exists':
        return const Exceptions('The provided uid is already in use by an existing user.');
      default:
        return const Exceptions();
    }
  }
}