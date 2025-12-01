import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_view_model.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),

          // Ola superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopWave(primary: primary, secondary: secondary),
          ),

          // Ola inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomWave(primary: primary),
          ),

          const SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LoginHeader(),
                    SizedBox(height: 24),
                    _LoginCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Column(
      children: [
        // Logo de la UTH, ajusta la ruta si usaste otro nombre
        SizedBox(
          height: 90,
          child: Image.asset(
            'assets/images/ut_hermosillo_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'FixIt',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: primary, fontSize: 26),
        ),
        const SizedBox(height: 4),
        const Text(
          'Reporta incidencias en el campus',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(22, 22, 22, 16),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    // Mantengo sincronizado el texto con el ViewModel
    emailController.addListener(() {
      context.read<LoginViewModel>().updateEmail(emailController.text);
    });

    passwordController.addListener(() {
      context.read<LoginViewModel>().updatePassword(passwordController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final vm = context.read<LoginViewModel>();
    final ok = await vm.submit();

    if (!mounted) return;

    if (ok) {
      // Login simulado, ahora sí mandamos al Home (HU-05)
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa email y contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Login', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 16),

        // Email
        _AnimatedFieldContainer(
          focusNode: emailFocus,
          child: TextField(
            controller: emailController,
            focusNode: emailFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.person_outline),
            ),
            onSubmitted: (_) => passwordFocus.requestFocus(),
          ),
        ),
        const SizedBox(height: 12),

        // Password
        _AnimatedFieldContainer(
          focusNode: passwordFocus,
          child: TextField(
            controller: passwordController,
            focusNode: passwordFocus,
            obscureText: !showPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
        ),
        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: vm.isLoading ? null : _handleSubmit,
            child: vm.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Ingresar'),
          ),
        ),
        const SizedBox(height: 8),

        TextButton(
          onPressed: () {
            // Aquí luego se puede abrir la pantalla de registro
          },
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}

class _AnimatedFieldContainer extends StatefulWidget {
  const _AnimatedFieldContainer({required this.focusNode, required this.child});

  final FocusNode focusNode;
  final Widget child;

  @override
  State<_AnimatedFieldContainer> createState() =>
      _AnimatedFieldContainerState();
}

class _AnimatedFieldContainerState extends State<_AnimatedFieldContainer> {
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  // Solo resalto el contenedor cuando el campo tiene foco
  void _onFocusChange() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: hasFocus ? primary.withValues(alpha: 0.06) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasFocus
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: widget.child,
    );
  }
}

class _TopWave extends StatelessWidget {
  const _TopWave({required this.primary, required this.secondary});

  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TopWaveClipper(),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              secondary.withValues(alpha: 0.9),
              primary.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class _BottomWave extends StatelessWidget {
  const _BottomWave({required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomWaveClipper(),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withValues(alpha: 0.25), Colors.white],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}

class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.95,
        size.width * 0.5,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.6,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.45,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
