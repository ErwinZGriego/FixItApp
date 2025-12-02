import 'package:flutter/material.dart';

/// Dos pestañas posibles
enum BottomTab { home, history }

/// Barra inferior tipo "segmented control" con pulgar blanco.
/// - Fondo = primary
/// - Pestaña activa = pulgar blanco + texto en primary
/// - Pestaña inactiva = texto blanco
class BottomPillNav extends StatelessWidget {
  const BottomPillNav({
    super.key,
    required this.active,
    required this.onTapHome,
    required this.onTapHistory,
  });

  final BottomTab active;
  final VoidCallback onTapHome;
  final VoidCallback onTapHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: _SegmentedPill(
            active: active,
            onTapHome: onTapHome,
            onTapHistory: onTapHistory,
          ),
        ),
      ),
    );
  }
}

class _SegmentedPill extends StatelessWidget {
  const _SegmentedPill({
    required this.active,
    required this.onTapHome,
    required this.onTapHistory,
  });

  final BottomTab active;
  final VoidCallback onTapHome;
  final VoidCallback onTapHistory;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    // Altura fija para el control; ancho se adapta al contenedor padre.
    const double controlHeight = 48;
    const double innerPad = 4; // padding interno del track

    return LayoutBuilder(
      builder: (context, constraints) {
        final double trackWidth = constraints.maxWidth;
        final double thumbWidth = (trackWidth - (innerPad * 2)) / 2;

        return Container(
          height: controlHeight,
          width: trackWidth,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Pulgar blanco que se mueve entre izquierda/derecha
              AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: active == BottomTab.history
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(innerPad),
                  child: Container(
                    width: thumbWidth,
                    height: controlHeight - (innerPad * 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Zonas táctiles + etiquetas
              Row(
                children: [
                  // IZQ: Historial
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: active == BottomTab.history ? null : onTapHistory,
                      child: Center(
                        child: _SegmentLabel(
                          icon: Icons.history,
                          text: 'Historial',
                          // Cuando activo, el texto va en primary (sobre pulgar blanco)
                          color: active == BottomTab.history
                              ? primary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // DER: Home
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: active == BottomTab.home ? null : onTapHome,
                      child: Center(
                        child: _SegmentLabel(
                          icon: Icons.home,
                          text: 'Inicio',
                          color: active == BottomTab.home
                              ? primary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Comentario breve: tipografía consistente con el tema
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
