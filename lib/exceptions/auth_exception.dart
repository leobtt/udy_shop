class AuthException implements Exception {
  final String key;
  static const Map<String, String> errors = {
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!',
    'INVALID_PASSWORD': 'Senha informada não confere.',
    'USER_DISABLED': 'A conta de usuário foi desabilitada.',
    'EMAIL_EXISTS': 'E-mail já cadastrado, tente outro e-mail.',
  };

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autentificação.';
  }
}
