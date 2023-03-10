import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void onSubmit() {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        height: 320,
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) => _authData['email'] = email ?? '',
              validator: (email) {
                final _email = email ?? '';
                if (_email.trim().isEmpty || _email.contains('@')) {
                  return 'Informe um e-mail válido!';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              controller: _passwordController,
              onSaved: (password) => _authData['password'] = password ?? '',
              validator: (password) {
                final _password = password ?? '';
                if (_password.isEmpty || _password.length < 5) {
                  return 'Informe uma senha válida!';
                }
                return null;
              },
            ),
            if (_authMode == AuthMode.signup)
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirme a senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: (password) {
                  final _password = password ?? '';

                  if (_password != _passwordController.text) {
                    return 'Senhas informadas não conferem!';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(_authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  )),
            ),
          ],
        )),
      ),
    );
  }
}
