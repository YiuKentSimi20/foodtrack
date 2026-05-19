class AuthenticationRequest {
  final String identifier;
  final String password;

  AuthenticationRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
  };
}