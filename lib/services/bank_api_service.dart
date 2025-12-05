import 'dart:convert';
import 'dart:io';

// سرویس ساده برای ارتباط با سرور جاوا روی سوکت
class BankApiService {
  final String host;
  final int port;

  BankApiService({
    this.host = '127.0.0.1', // روی macOS همینه
    this.port = 4040,
  });

  // متد داخلی برای ارسال یک درخواست JSON و گرفتن جواب
  Future<Map<String, dynamic>> _send(Map<String, dynamic> body) async {
    final socket = await Socket.connect(host, port);

    final jsonString = jsonEncode(body);
    socket.write('$jsonString\n');

    final responseLine = await socket
        .map((event) => utf8.decode(event))
        .transform(const LineSplitter())
        .first;

    await socket.close();

    return jsonDecode(responseLine) as Map<String, dynamic>;
  }

  // تست ارتباط
  Future<bool> ping() async {
    final res = await _send({
      'action': 'PING',
    });
    return res['status'] == 'ok';
  }

  // لاگین واقعی با سرور جاوا
  Future<bool> login(String username, String password) async {
    final res = await _send({
      'action': 'LOGIN',
      'username': username,
      'password': password,
    });
    return res['status'] == 'ok';
  }

  // گرفتن لیست حساب‌ها (فعلاً raw)
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final res = await _send({
      'action': 'GET_ACCOUNTS',
    });

    if (res['status'] != 'ok') {
      throw Exception('Failed to load accounts');
    }

    final List<dynamic> list = res['accounts'] as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }
}