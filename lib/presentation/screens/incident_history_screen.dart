import 'dart:io';

import 'package:fix_it_app/presentation/viewmodels/incident_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/incident.dart';
import '../screens/home_screen.dart';
import '../widgets/bottom_pill_nav.dart';
import 'incident_detail_screen.dart'; // ← necesario para routeName

class IncidentHistoryScreen extends StatelessWidget {
  const IncidentHistoryScreen({super.key});
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IncidentListViewModel()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis reportes')),
        body: const _Body(),
        bottomNavigationBar: SafeArea(
          top: false,
          child: BottomPillNav(
            active: BottomTab.history,
            onTapHome: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            onTapHistory: () {
              // Ya estamos en Historial
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IncidentListViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: vm.refresh,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text('Aún no has creado reportes')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: vm.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _IncidentTile(i: vm.items[i]),
      ),
    );
  }
}

class _IncidentTile extends StatelessWidget {
  const _IncidentTile({required this.i});
  final Incident i;

  @override
  Widget build(BuildContext context) {
    final subtitle = '${_pretty(i.category.name)} • ${_date(i.createdAt)}';

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      leading: _Thumb(path: i.photoPath),
      title: Text(
        i.title.isEmpty ? 'Reporte' : i.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _StatusPill(text: _pretty(i.status.name)),
      onTap: () {
        // Navega al detalle con el incidente como argumento
        Navigator.pushNamed(
          context,
          IncidentDetailScreen.routeName,
          arguments: i,
        );
      },
    );
  }

  String _pretty(String s) => '${s[0].toUpperCase()}${s.substring(1)}';
  String _date(DateTime d) =>
      '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
  String _two(int n) => n.toString().padLeft(2, '0');
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    final f = File(path);
    final child = f.existsSync()
        ? Image.file(f, fit: BoxFit.cover)
        : const Icon(Icons.image_not_supported_outlined, size: 28);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: 56,
        height: 56,
        color: Colors.black12,
        child: child,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: c, fontWeight: FontWeight.w600),
      ),
    );
  }
}
