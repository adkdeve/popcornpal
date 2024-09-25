import 'package:flutter/material.dart';
import 'package:movieapp/pages/MovieItemPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _allProducts = ProductRepository.getProducts();
    _filteredProducts = _allProducts;
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent, // Customize AppBar background color
        iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      body: Column(
        children: [
          // Search bar for filtering products
          _buildSearchBar(),

          const SizedBox(height: 10),

          // Display search results
          _filteredProducts.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No Movies Found",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          )
              : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Image background with error handling
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover, // Ensure image fills the area
                              width: double.infinity, // Fill the width of the card
                              height: double.infinity, // Fill the height of the card
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default.jpeg', // Fallback image
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              },
                            ),
                          ),
                        ),
                        // Text overlay at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              product.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Search bar
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Add margin if needed
      decoration: BoxDecoration(
        color: Colors.white, // Set a background color for the search bar
        borderRadius: BorderRadius.circular(30), // Keep the rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 5, // Soft shadow
            offset: const Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent, // Make the fill color transparent
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.grey, // Color of the search icon
          ),
        ),
        onChanged: (query) {
          _filterProducts(query);
        },
      ),
    );
  }
}
