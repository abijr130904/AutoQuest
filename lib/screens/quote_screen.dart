import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/quote.dart';
import 'favorite_screen.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  Quote? currentQuote;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() => isLoading = true);
    Quote? quote = await _apiService.fetchQuote();
    if (quote != null) {
      String? translatedText = await _apiService.translateQuote(quote.text);
      setState(() {
        currentQuote = Quote(
          text: quote.text,
          author: quote.author,
          translatedText: translatedText ?? "Gagal menerjemahkan",
        );
        isLoading = false;
      });
    }
  }

  void saveFavorite() async {
    if (currentQuote != null) {
      String fullQuote = '"${currentQuote!.text}"\n➜ ${currentQuote!.translatedText}\n- ${currentQuote!.author}';
      await _storageService.saveFavorite(fullQuote);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kutipan disimpan ke favorit')));
    }
  }

  void shareQuote() {
    if (currentQuote != null) {
      String textToShare = '"${currentQuote!.text}"\n➜ ${currentQuote!.translatedText}\n- ${currentQuote!.author}';
      Share.share(textToShare);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AutoQuest - Generator Kutipan"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteQuotesScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircularProgressIndicator()
                : currentQuote != null
                    ? Column(
                        children: [
                          Text(currentQuote!.text, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Text("➜ ${currentQuote!.translatedText}", textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Text("- ${currentQuote!.author}", textAlign: TextAlign.center),
                        ],
                      )
                    : const Text("Tekan tombol untuk mendapatkan kutipan!"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: fetchQuote, child: const Text("Dapatkan Kutipan")),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: saveFavorite, icon: const Icon(Icons.favorite), label: const Text("Favorit")),
                const SizedBox(width: 10),
                ElevatedButton.icon(onPressed: shareQuote, icon: const Icon(Icons.share), label: const Text("Bagikan")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
