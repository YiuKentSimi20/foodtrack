class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String dataNasterii; // yyyy-MM-dd
  final String gen; // M/F/ALTUL
  final String nivelActivitate; // SEDENTAR, USOR_ACTIV, MODERAT_ACTIV, FOARTE_ACTIV

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.dataNasterii,
    required this.gen,
    required this.nivelActivitate,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'data_nasterii': dataNasterii,
    'gen': gen,
    'nivel_activitate': nivelActivitate,
  };
}