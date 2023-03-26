import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/exceptions/auth_exception.dart';
import 'package:udy_shop/models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text(msg),
            title: const Text('Ocorreu um erro.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              )
            ],
          );
        });
  }

  void onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      showErrorDialog(error.toString());
    } catch (error) {
      showErrorDialog('Ocorreu um erro inesperado.');
    }

    setState(() => _isLoading = false);
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));

    // _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        height: _isLogin() ? 310 : 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (email) {
                  final _email = email ?? '';
                  if (_email.trim().isEmpty || !_email.contains('@')) {
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
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: _isSignup()
                        ? TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Confirme a senha'),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            validator: (password) {
                              final _password = password ?? '';

                              if (_password != _passwordController.text) {
                                return 'Senhas informadas não conferem!';
                              }
                              return null;
                            },
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                      _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR'),
                ),
              const Spacer(),
              TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      _isLogin() ? 'DESEJA REGISTRAR' : 'JÁ POSSUI CONTA?'))
            ],
          ),
        ),
      ),
    );
  }
}
