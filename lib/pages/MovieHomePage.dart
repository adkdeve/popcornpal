import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movieapp/pages/ProfilePage.dart';
import 'package:movieapp/pages/SearchPage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:movieapp/pages/CategoryPage.dart';
import 'package:movieapp/pages/FavouritePage.dart';
import 'package:movieapp/pages/SettingsPage.dart';
import 'package:movieapp/pages/MovieItemPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenContent(),
    CategoryScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ),
            );
          },
        ),
        title: const Text('PopcornPal', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 10.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              SalomonBottomBarItem(icon: const Icon(Icons.home), title: const Text("Home"), selectedColor: Colors.blue),
              SalomonBottomBarItem(icon: const Icon(Icons.category), title: const Text("Category"), selectedColor: Colors.orange),
              SalomonBottomBarItem(icon: const Icon(Icons.favorite), title: const Text("Favorites"), selectedColor: Colors.red),
              SalomonBottomBarItem(icon: const Icon(Icons.person), title: const Text("Profile"), selectedColor: Colors.deepPurpleAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _featuredProducts = [];

  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _allProducts = ProductRepository.getProducts();
    _filteredProducts = _allProducts;

    // Start a timer to auto-slide the page every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int currentPage = _pageController.page?.round() ?? 0; // Convert to integer

      if (currentPage == _featuredProducts.length - 1) {
        // Go back to the first page
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        // Move to the next page
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Clean up the timer
    super.dispose();
  }

  List<Product> _getProductsForCategory(String category) {
    return _filteredProducts
        .where((product) => product.category == category)
        .toList();
  }

  void _viewMore(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Sci-Fi', 'Action', 'Fantasy', 'Adventure', 'Drama',
      'Crime', 'Thriller', 'Horror', 'Comedy', 'Animation',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Product PageView section
          _buildProductPageView(),

          const SizedBox(height: 10),

          // SmoothPageIndicator for sliding page view
          _buildPageIndicator(),

          const SizedBox(height: 10),

          // Category list with horizontal movie sliders
          _buildCategoryList(categories),
        ],
      ),
    );
  }

  // Build PageView for featured movies
  Widget _buildProductPageView() {
    _featuredProducts = _allProducts;
    _featuredProducts.shuffle();
    _featuredProducts = _featuredProducts.take(5).toList();

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _featuredProducts.length,
        itemBuilder: (context, index) {
          final product = _featuredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(product: product),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/default.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Build Horizontal list of products for each category
  Widget _buildCategoryProductList(List<Product> categoryProducts) {
    if (categoryProducts.isEmpty) {
      return Center(
        child: Text(
          'No movies available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryProducts.length,
        itemBuilder: (context, productIndex) {
          final product = categoryProducts[productIndex];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(product: product),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Main image with CachedNetworkImage
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/default.jpeg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  // Overlay for the title
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.black.withOpacity(0.6),
                      child: Text(
                        product.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Build SmoothPageIndicator
  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _filteredProducts.length > 5 ? 5 : _filteredProducts.length, // Limit to 5 dots
      effect: const ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: Colors.blue,
        expansionFactor: 3,
        spacing: 4.0,
      ),
      onDotClicked: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // Build category section with horizontal sliders for movies
  Widget _buildCategoryList(List<String> categories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryProducts = _getProductsForCategory(category);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryHeader(context, category),
            const SizedBox(height: 10),
            _buildCategoryProductList(categoryProducts),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  // Build Category Header with "More" button
  Widget _buildCategoryHeader(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              _viewMore(context, category);
            },
            child: const Text(
              "More",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
