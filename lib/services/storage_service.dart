import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> saveFavorite(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await loadFavorites();

    if (!favorites.contains(quote)) {
      favorites.add(quote);
      await prefs.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await loadFavorites();

    favorites.removeAt(index);
    await prefs.setStringList('favorites', favorites);
  }
}
