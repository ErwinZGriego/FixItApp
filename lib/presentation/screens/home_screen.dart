import 'package:fix_it_app/presentation/screens/create_report_screen.dart';
import 'package:fix_it_app/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: const SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12),
            _HomeHeaderBanner(),
            SizedBox(height: 24),

            // Botón en el centro para crear el reporte
            Expanded(child: Center(child: _NewReportButton())),
          ],
        ),
      ),

      // Barra de navegación inferior (la levantamos con SafeArea para que no se
      // encime con la barra de navegación del sistema).
      bottomNavigationBar: const SafeArea(top: false, child: _BottomNavBar()),
    );
  }
}

class _HomeHeaderBanner extends StatelessWidget {
  const _HomeHeaderBanner();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.95),
              secondary.withValues(alpha: 0.9),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(Icons.campaign_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenido a FixIt',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reporta incidencias y ayuda a mantener la UTH en buen estado.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Botón de logout en el banner
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Logout simulado: regresamos al login
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NewReportButton extends StatefulWidget {
  const _NewReportButton();

  @override
  State<_NewReportButton> createState() => _NewReportButtonState();
}

class _NewReportButtonState extends State<_NewReportButton>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;

  // Pequeña animación de escala al presionar
  void _onTapDown(TapDownDetails details) {
    setState(() {
      scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      scale = 1.0;
    });

    // Abrimos la pantalla de creación de reporte
    Navigator.pushNamed(context, CreateReportScreen.routeName);
  }

  void _onTapCancel() {
    setState(() {
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fabColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(shape: BoxShape.circle, color: fabColor),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 42, color: Colors.white),
              SizedBox(height: 6),
              Text(
                'Nuevo reporte',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.history,
            label: 'Historial',
            isSelected: false,
            onTap: () {
              // Navega al listado de mis reportes
              Navigator.pushNamed(context, '/history');
            },
          ),
          _CenterHomeButton(color: primary),
          _NavItem(
            icon: Icons.settings,
            label: 'Ajustes',
            isSelected: false,
            onTap: () {
              // futuro
            },
          ),
        ],
      ),
    );
  }
}

class _CenterHomeButton extends StatelessWidget {
  const _CenterHomeButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const Icon(Icons.home, color: Colors.white),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? primary : Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? primary : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
