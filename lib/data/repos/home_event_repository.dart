import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/home_event.dart';

class HomeEventRepository {
  HomeEventRepository._();
  static final HomeEventRepository instance = HomeEventRepository._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('home_events');

  Stream<List<HomeEvent>> recent(String uid, {int limit = 50}) {
    return _col(uid)
        .orderBy('receivedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => HomeEvent.fromMap(d.data(), id: d.id))
            .toList());
  }

  /// Simula eventos
  Future<void> simulateDemo(String uid, {int seconds = 45}) async {
    final ref = _col(uid);
    final rand = Random();
    final deadline = DateTime.now().add(Duration(seconds: seconds));

    Future<void> _emitMotion(String sensorName, String state) async {
      await ref.add({
        'type': 'binary_sensor.motion.$sensorName',
        'state': state, // 'on' | 'off'
        'device': 'betsy',
        'source': 'sim',
        'ts': FieldValue.serverTimestamp(),
        'receivedAt': FieldValue.serverTimestamp(),
      });
    }

    Future<void> _emitSoundPeak(int dbVal) async {
      await ref.add({
        'type': 'sensor.sound.inmp441',
        'state': '$dbVal dB',
        'device': 'betsy',
        'source': 'sim',
        'ts': FieldValue.serverTimestamp(),
        'receivedAt': FieldValue.serverTimestamp(),
      });
    }

    while (DateTime.now().isBefore(deadline)) {
      final path = rand.nextBool()
          ? ['Sensor_1', 'Sensor_2', 'Sensor_3']
          : ['Sensor_3', 'Sensor_2', 'Sensor_1'];

      for (final s in path) {
        await _emitMotion(s, 'on');

        if (rand.nextDouble() < 0.35) {
          final peak = 60 + rand.nextInt(15); // 60–74 dB
          await _emitSoundPeak(peak);
        }

        await Future.delayed(Duration(milliseconds: 600 + rand.nextInt(800)));
        await _emitMotion(s, 'off');
        await Future.delayed(Duration(milliseconds: 200 + rand.nextInt(500)));

        if (DateTime.now().isAfter(deadline)) break;
      }

      if (rand.nextDouble() < 0.5) {
        final ambient = 40 + rand.nextInt(8); // 40–47 dB
        await _emitSoundPeak(ambient);
      }

      await Future.delayed(Duration(milliseconds: 800 + rand.nextInt(1400)));
    }
  }
}