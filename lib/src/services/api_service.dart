import 'package:http/http.dart' as http;
// import 'dart:convert';

class ApiService {
  static Future<void> fetchNotes() async {
    final res = await http.get(Uri.parse("http://10.0.2.2:3001/health"));

    if (res.statusCode == 200) {
      // final data = jsonDecode(res.body);
      // print(data);
    } else {
      throw Exception("Failed to load notes");
    }
  }
}
