import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteQuotesScreen extends StatefulWidget {
  const FavoriteQuotesScreen({super.key});

  @override
  _FavoriteQuotesScreenState createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  final StorageService _storageService = StorageService();
  List<String> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    List<String> quotes = await _storageService.loadFavorites();
    setState(() {
      favoriteQuotes = quotes;
    });
  }

  Future<void> removeFavorite(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kutipan?"),
        content: const Text("Apakah Anda yakin ingin menghapus kutipan ini dari favorit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _storageService.removeFavorite(index);
      loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kutipan dihapus dari favorit")),
      );
    }
  }

  void shareQuote(String quote) {
    Share.share(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kutipan Favorit")),
      body: favoriteQuotes.isEmpty
          ? const Center(child: Text("Belum ada kutipan favorit"))
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(favoriteQuotes[index]),
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blue),
                          onPressed: () => shareQuote(favoriteQuotes[index]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFavorite(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
