import 'dart:async';
import 'package:flutter/material.dart';

class PrayerCountdownTimer extends StatefulWidget {
  final DateTime jadwal;
  const PrayerCountdownTimer({Key? key, required this.jadwal}) : super(key: key);

  @override
  State<PrayerCountdownTimer> createState() => _PrayerCountdownTimerState();
}

class _PrayerCountdownTimerState extends State<PrayerCountdownTimer> {
  late Duration _sisa;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculate();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculate());
  }

  void _calculate() {
    setState(() {
      final now = DateTime.now();
      _sisa = widget.jadwal.difference(now);
      if (_sisa.isNegative) _sisa = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sisa == Duration.zero) {
      return const Text('Sudah lewat', style: TextStyle(fontSize: 13, color: Colors.grey));
    }
    final jam = _sisa.inHours;
    final menit = _sisa.inMinutes % 60;
    final detik = _sisa.inSeconds % 60;
    return Text('Notif dalam: ${jam.toString().padLeft(2, '0')}:${menit.toString().padLeft(2, '0')}:${detik.toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.primary.withOpacity(0.9), fontWeight: FontWeight.w500));
  }
}




