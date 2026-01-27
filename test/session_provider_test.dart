import 'package:flutter_test/flutter_test.dart';
import 'package:ink_log/models/session.dart';
import 'package:ink_log/providers/session_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Add session to provider', () async {
    final provider = SessionProvider();
    final session = Session(title: 'Test', notes: 'Notes', date: '2026-01-31');

    await provider.addSession(session);

    expect(provider.sessions.length, 1);
    expect(provider.sessions.first.title, 'Test');
  });
}
