import 'package:flutter/material.dart';
import 'MovieItemPage.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return favoriteProducts.isEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Favorites Screen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Manage your favorite items here.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        : ListView.builder(
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return GestureDetector(
          onTap: () {
            // Navigate to ProductDetailPage when a favorited item is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(product: product),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Image.network(product.imageUrl,
                  width: 100, fit: BoxFit.cover),
              title: Text(product.title),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    favoriteProducts.remove(product);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}