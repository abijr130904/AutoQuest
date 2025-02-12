import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  static const _quoteUrl = 'https://zenquotes.io/api/random';

  Future<Quote?> fetchQuote() async {
    final response = await http.get(Uri.parse(_quoteUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      return Quote.fromJson(data);
    }
    return null;
  }

  Future<String?> translateQuote(String text) async {
    final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=id&dt=t&q=${Uri.encodeComponent(text)}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data[0][0][0];
    }
    return null;
  }
}
