import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.network(
                "https://cdn-icons-png.flaticon.com/512/295/295128.png",
                width: 100,
                height: 100,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }

                  // must be a valid email address
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Email tidak valid";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username tidak boleh kosong";
                  }

                  if (value == "admin") {
                    return "Username admin tidak boleh digunakan";
                  }

                  if (value.contains("@")) {
                    return "Username tidak boleh mengandung '@'";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: GestureDetector(
                    child: _isPasswordVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: _isPasswordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password tidak boleh kosong";
                  }

                  if (value.length < 8) {
                    return "Password minimal 8 karakter";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate() ?? false;

                  if (isValid) {
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    print("username: $username");
                    print("password: $password");
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
                child: const Text("Register"),
              ),
              const SizedBox(height: 24),
              const Text("Sudah punya akun?"),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
