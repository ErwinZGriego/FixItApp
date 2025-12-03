import 'package:fix_it_app/presentation/screens/create_report_screen.dart';
import 'package:fix_it_app/presentation/screens/login_screen.dart';
import 'package:fix_it_app/presentation/widgets/bottom_pill_nav.dart';
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
            Expanded(child: Center(child: _NewReportButton())),
          ],
        ),
      ),
      // Usa el nav compartido (pestaña activa = home)
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomPillNav(
          active: BottomTab.home,
          onTapHome: () {
            // Ya estás en Home; no hacemos nada.
          },
          onTapHistory: () {
            Navigator.pushNamed(context, '/history');
          },
        ),
      ),
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido a FixIt',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Reporta incidencias y ayuda a mantener la UTH en buen estado.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              key: const ValueKey('home.logout'),
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
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

  void _onTapDown(TapDownDetails d) => setState(() => scale = 0.95);
  void _onTapCancel() => setState(() => scale = 1.0);
  void _onTapUp(TapUpDetails d) {
    setState(() => scale = 1.0);
    Navigator.pushNamed(context, CreateReportScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final fabColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      key: const ValueKey('home.newReport'),
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
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
