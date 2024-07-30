import 'package:absensi_gps/presentation/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                child: const Text("Login"),
              ),
              const SizedBox(height: 24),
              const Text("Tidak punya akun?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegisterPage();
                      },
                    ),
                  );
                },
                child: const Text("Daftar baru"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
