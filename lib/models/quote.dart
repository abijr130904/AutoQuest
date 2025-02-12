class Quote {
  final String text;
  final String author;
  final String translatedText;

  Quote({required this.text, required this.author, required this.translatedText});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'],
      author: json['a'],
      translatedText: "",
    );
  }
}
