import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Global favorite list
List<Product> favoriteProducts = [];
// Global comment list for each product
Map<Product, List<Comment>> productComments = {};

class MovieDetailPage extends StatefulWidget {
  final Product product;

  const MovieDetailPage({super.key, required this.product});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if the product is already in the favorites list
    isFavorite = favoriteProducts.contains(widget.product);
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoriteProducts.remove(widget.product);
      } else {
        if (!favoriteProducts.contains(widget.product)) {
          favoriteProducts.add(widget.product);
        }
      }
      isFavorite = !isFavorite;
    });
  }

  void addComment(String text) {
    setState(() {
      if (productComments[widget.product] == null) {
        productComments[widget.product] = [];
      }
      productComments[widget.product]!.add(Comment(text: text));
    });
    _commentController.clear();
  }

  Future<void> _launchYouTubeVideo() async {
    const url = 'https://www.youtube.com/watch?v=p7RPvjNQE9k';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black87;
    final subtitleColor = theme.brightness == Brightness.dark
        ? Colors.grey[300]
        : Colors.grey[600];

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Movie banner image
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Play button over the banner image
                    Positioned.fill(
                      child: Center(
                        child: GestureDetector(
                          onTap: _launchYouTubeVideo,
                          child: const CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 30,
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie title and favorite button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          // Favorite button in the right corner of title
                          FloatingActionButton(
                            mini: true, // Use mini button to fit beside title
                            onPressed: toggleFavorite,
                            backgroundColor: isFavorite ? Colors.red : Colors.grey,
                            child: const Icon(Icons.favorite),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Movie rating and category
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          const SizedBox(width: 5),
                          Text(
                            'Rating: ${widget.product.rating}',
                            style:
                            TextStyle(fontSize: 16, color: subtitleColor),
                          ),
                          const Spacer(),
                          Text(
                            widget.product.category,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Movie description
                      Text(
                        widget.product.description,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                      const SizedBox(height: 40),
                      // Comments section
                      Text(
                        "Comments:",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Comment input field
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Write a comment...",
                          hintStyle: TextStyle(color: subtitleColor),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, color: textColor),
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                addComment(_commentController.text);
                              }
                            },
                          ),
                        ),
                        style: TextStyle(color: textColor,fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      // Display comments
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productComments[widget.product]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final comment =
                          productComments[widget.product]![index];
                          return CommentCard(comment: comment);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AppBar overlay for back navigation and movie title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.product.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment {
  final String text;
  final List<String> replies;

  Comment({required this.text, this.replies = const []});
}

class CommentCard extends StatefulWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.comment.text),
            if (widget.comment.replies.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showReplies = !showReplies;
                  });
                },
                child: Text(
                  showReplies ? "Hide Replies" : "Show Replies",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            if (showReplies)
              ...widget.comment.replies.map((reply) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Text(reply),
              )),
          ],
        ),
      ),
    );
  }
}

class ProductRepository {
  static final List<Product> _products = [
    // Action
    Product(
      imageUrl: 'https://i.pinimg.com/564x/ea/a2/6e/eaa26e2c3bfa234c3cdd3c4d9fabad35.jpg',
      title: 'The Dark Knight',
      description: 'Batman faces the Joker, a criminal mastermind who seeks to undermine Gotham\'s order.',
      rating: 4.9,
      category: 'Action',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/c3/e6/34/c3e634ab06efa4bd37f239e8604cef48.jpg',
      title: 'Mad Max: Fury Road',
      description: 'In a post-apocalyptic wasteland, Max teams up with a mysterious woman to escape a tyrannical warlord.',
      rating: 4.6,
      category: 'Action',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/25/82/b4/2582b4a9b2174193380ad366886ee5a3.jpg',
      title: 'John Wick',
      description: 'An ex-hitman comes out of retirement to track down the gangsters who killed his dog.',
      rating: 4.7,
      category: 'Action',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/6d/e5/31/6de531a097aa27729fb21b6d00cf29b1.jpg',
      title: 'Die Hard',
      description: 'John McClane battles terrorists who have taken hostages in a Los Angeles skyscraper.',
      rating: 4.7,
      category: 'Action',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/80/ef/6b/80ef6bd60a8e75dcb3e7347ca50cfe5a.jpg',
      title: 'Gladiator',
      description: 'A Roman general seeks vengeance after being betrayed and reduced to slavery.',
      rating: 4.6,
      category: 'Action',
    ),

    // Adventure
    Product(
      imageUrl: 'https://i.pinimg.com/564x/eb/71/fa/eb71fa4f5980f97ae56c705686db850e.jpg',
      title: 'Jurassic Park',
      description: 'A group of people try to survive on an island with cloned dinosaurs.',
      rating: 4.8,
      category: 'Adventure',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/50/c7/7b/50c77b1f78797d7915b1d237ee6eb913.jpg',
      title: 'Indiana Jones: Raiders of the Lost Ark',
      description: 'Indiana Jones sets out to find the Ark of the Covenant before the Nazis do.',
      rating: 4.7,
      category: 'Adventure',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/71/51/4e/71514e83eb01965c3b38aa7b0b62929e.jpg',
      title: 'Pirates of the Caribbean: The Curse of the Black Pearl',
      description: 'A blacksmith teams up with a pirate to rescue a kidnapped woman from cursed pirates.',
      rating: 4.6,
      category: 'Adventure',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/e9/57/3e/e9573eccf1269c66e225bfdef0512996.jpg',
      title: 'The Revenant',
      description: 'A frontiersman fights for survival after being left for dead by his companions.',
      rating: 4.6,
      category: 'Adventure',
    ),

    // Animation
    Product(
      imageUrl: 'https://i.pinimg.com/564x/32/9a/8e/329a8ef32824895d65ff6217cec83632.jpg',
      title: 'Finding Nemo',
      description: 'A timid clownfish sets out on a journey to bring his son home.',
      rating: 4.8,
      category: 'Animation',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/ff/ba/c3/ffbac3218ac7704e2d8eb5b63380d485.jpg',
      title: 'Toy Story',
      description: 'A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy.',
      rating: 4.8,
      category: 'Animation',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/80/e0/8c/80e08cf494d3149c2ca02a5bfc8216ee.jpg',
      title: 'The Lion King',
      description: 'Lion cub and future king Simba flees his kingdom after the death of his father.',
      rating: 4.7,
      category: 'Animation',
    ),
    Product(
      imageUrl: 'https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg',
      title: 'Frozen',
      description: 'A princess sets off on a journey alongside a rugged iceman, his loyal reindeer, and a naive snowman.',
      rating: 4.5,
      category: 'Animation',
    ),
    Product(
      imageUrl: 'https://media.themoviedb.org/t/p/w220_and_h330_face/uPibLH5heWv9pZ0URKtyhccfOyX.jpg',
      title: 'Spider-Man: Into the Spider-Verse',
      description: 'Teen Miles Morales becomes the Spider-Man of his dimension, crossing paths with his counterparts from other dimensions.',
      rating: 4.9,
      category: 'Animation',
    ),

    // Comedy
    Product(
      imageUrl: 'https://i.pinimg.com/564x/96/7c/76/967c76a5c899ef553e1aee7bc69f43a1.jpg',
      title: 'The Wolf of Wall Street',
      description: 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker to his fall involving crime.',
      rating: 4.4,
      category: 'Comedy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/4b/49/b6/4b49b66956c004409f5dfc323faf432f.jpg',
      title: 'Superbad',
      description: 'Two high school friends trying to make the most of their last days before graduation.',
      rating: 4.5,
      category: 'Comedy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/a1/cc/b5/a1ccb58d1f7236be839e2e44de8e498a.jpg',
      title: 'Step Brothers',
      description: 'Two aimless middle-aged losers become roommates after their parents marry.',
      rating: 4.3,
      category: 'Comedy',
    ),
    Product(
      imageUrl: 'https://m.media-amazon.com/images/I/71NSaiNKO9L.jpg',
      title: 'Bridesmaids',
      description: 'Competition between the maid of honor and a bridesmaid, over who is the bride\'s best friend.',
      rating: 4.5,
      category: 'Comedy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/29/6c/1f/296c1f15a09e788f4054abcc6e031f2f.jpg',
      title: 'The Hangover',
      description: 'Three buddies wake up from a bachelor party in Las Vegas with no memory of the previous night.',
      rating: 4.6,
      category: 'Comedy',
    ),

    // Crime
    Product(
      imageUrl: 'https://i.pinimg.com/564x/1d/fa/6c/1dfa6ce2aca118aeddd66249d425c575.jpg',
      title: 'The Godfather',
      description: 'An organized crime dynasty\'s aging patriarch transfers control of his clandestine empire to his reluctant son.',
      rating: 4.9,
      category: 'Crime',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/e4/05/0b/e4050b92335cde4a3b5ae340fc8c5ee3.jpg',
      title: 'Pulp Fiction',
      description: 'The lives of two mob hitmen, a boxer, a gangster\'s wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
      rating: 4.8,
      category: 'Crime',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/8a/53/32/8a53323e0c5108d210a7d1a6658b4cc9.jpg',
      title: 'Se7en',
      description: 'Two detectives, a rookie and a veteran, hunt a serial killer who uses the seven deadly sins as his modus operandi.',
      rating: 4.8,
      category: 'Crime',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/07/26/ba/0726ba618e509ecb7b0f494d483441c6.jpg',
      title: 'Gone Girl',
      description: 'With his wife\'s disappearance, a man becomes the prime suspect in her murder.',
      rating: 4.7,
      category: 'Crime',
    ),
    Product(
      imageUrl: 'https://cdn.europosters.eu/image/750/posters/scarface-movie-i8166.jpg',
      title: 'Scarface',
      description: 'In 1980 Miami, a determined Cuban immigrant takes over a drug empire while succumbing to greed.',
      rating: 4.7,
      category: 'Crime',
    ),

    // Drama
    Product(
      imageUrl: 'https://image.tmdb.org/t/p/original/yu26pJwGFUyqTJWMWo1mMgBFJ0N.jpg',
      title: 'Forrest Gump',
      description: 'The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal, and other historical events unfold through the viewpoint of an Alabama man with an IQ of 75.',
      rating: 4.8,
      category: 'Drama',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/08/6f/fe/086ffeccab22baa2b4d49ab8787f9b90.jpg',
      title: 'The Shawshank Redemption',
      description: 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
      rating: 4.9,
      category: 'Drama',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/de/1b/80/de1b8002fd9024279fccc4ccc96f18f6.jpg',
      title: 'Fight Club',
      description: 'An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.',
      rating: 4.7,
      category: 'Drama',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/dd/4f/a0/dd4fa0752e4662e768e441f8d748492f.jpg',
      title: 'The Pursuit of Happyness',
      description: 'A struggling salesman takes custody of his son as he\'s poised to begin a life-changing professional career.',
      rating: 4.7,
      category: 'Drama',
    ),
    Product(
      imageUrl: 'https://m.media-amazon.com/images/I/61QFAKXbb5L.jpg',
      title: '12 Years a Slave',
      description: 'In the pre-Civil War United States, Solomon Northup, a free African-American man, is abducted and sold into slavery.',
      rating: 4.8,
      category: 'Drama',
    ),

    // Horror
    Product(
      imageUrl: 'https://i.pinimg.com/564x/26/b7/ec/26b7ec329d3be21ce0c02b5bf2349f82.jpg',
      title: 'Get Out',
      description: 'A young African-American man visits his white girlfriend\'s family, uncovering a disturbing secret.',
      rating: 4.8,
      category: 'Horror',
    ),
    Product(
      imageUrl: 'https://framein.lt/255-thickbox_default/80s-movie-a-nightmare-on-elm-street-poster.jpg',
      title: 'A Nightmare on Elm Street',
      description: 'A group of teenagers is stalked by a deformed killer who preys on their dreams.',
      rating: 4.5,
      category: 'Horror',
    ),
    Product(
      imageUrl: 'https://designbuddy.com/wp-content/uploads/2012/12/saul-bass-poster-design.jpg',
      title: 'The Shining',
      description: 'A family heads to an isolated hotel for the winter where an evil spiritual presence influences the father into violence.',
      rating: 4.7,
      category: 'Horror',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/38/c2/9d/38c29db1e2dd6a663804d4e48e98caac.jpg',
      title: 'Hereditary',
      description: 'A grieving family is haunted by tragic and disturbing occurrences.',
      rating: 4.6,
      category: 'Horror',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/09/fa/c7/09fac7572faf725994c01a38e035453e.jpg',
      title: 'It',
      description: 'In a small town, a group of kids faces off against a shape-shifting monster that exploits the fears of its victims.',
      rating: 4.5,
      category: 'Horror',
    ),

    // Sci-Fi
    Product(
      imageUrl: 'https://i.pinimg.com/564x/43/9a/1c/439a1c4583a953c26b63d08a1d832f53.jpg',
      title: 'Inception',
      description: 'A thief who enters the dreams of others to steal secrets from their subconscious is given the inverse task of planting an idea into a target\'s mind.',
      rating: 4.8,
      category: 'Sci-Fi',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/4b/1c/ab/4b1cab19aed05183b61c11e399b53833.jpg',
      title: 'Blade Runner 2049',
      description: 'A young blade runner discovers a long-buried secret that has the potential to plunge what’s left of society into chaos.',
      rating: 4.7,
      category: 'Sci-Fi',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/18/d7/4e/18d74ef46e722828f75cca91b009f4a5.jpg',
      title: 'The Matrix',
      description: 'A computer hacker learns about the true nature of his reality and his role in the war against its controllers.',
      rating: 4.8,
      category: 'Sci-Fi',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/0b/34/ce/0b34ce2145b475247577a5d438a199b0.jpg',
      title: 'Interstellar',
      description: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      rating: 4.7,
      category: 'Sci-Fi',
    ),

    // Fantasy
    Product(
      imageUrl: 'https://i.pinimg.com/564x/4d/8c/eb/4d8ceb7c6e967c8c7948475e43791a2b.jpg',
      title: 'The Lord of the Rings: The Fellowship of the Ring',
      description: 'A young hobbit, Frodo, embarks on a quest to destroy a powerful ring.',
      rating: 4.9,
      category: 'Fantasy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/68/08/e2/6808e2893d29d0e7fd07c1d5f30bfbcf.jpg',
      title: 'Harry Potter and the Sorcerer\'s Stone',
      description: 'An orphaned boy discovers he is a wizard and attends a magical school.',
      rating: 4.8,
      category: 'Fantasy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/6c/4c/ec/6c4cec5b3419886dc6c9746114c31fc2.jpg',
      title: 'Pan\'s Labyrinth',
      description: 'A young girl in post-Civil War Spain discovers a mystical labyrinth.',
      rating: 4.8,
      category: 'Fantasy',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/3c/23/b0/3c23b075843f56d4e35ae68ae0783575.jpg',
      title: 'The Chronicles of Narnia: The Lion, the Witch and the Wardrobe',
      description: 'Four siblings discover a magical land and fight against an evil queen.',
      rating: 4.7,
      category: 'Fantasy',
    ),

    // Mystery
    Product(
      imageUrl: 'https://i.pinimg.com/474x/8e/1a/64/8e1a6461bfb34d51a7337c0c356d51d0.jpg',
      title: 'Knives Out',
      description: 'A detective investigates the death of a wealthy patriarch during his family reunion.',
      rating: 4.7,
      category: 'Mystery',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/736x/3e/4d/5e/3e4d5ee5c09e728bb1868f2a6b9d8a51.jpg',
      title: 'The Girl with the Dragon Tattoo',
      description: 'A journalist and a hacker uncover dark secrets while investigating a disappearance.',
      rating: 4.6,
      category: 'Mystery',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/be/42/79/be42798ae9f2053ce10dd4e4a33d091f.jpg',
      title: 'Shutter Island',
      description: 'A U.S. Marshal investigates a psychiatric facility after a patient goes missing.',
      rating: 4.6,
      category: 'Mystery',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/02/f8/eb/02f8eb40632e292470f7c1edc529c134.jpg',
      title: 'The Sixth Sense',
      description: 'A boy communicates with spirits that don\'t know they\'re dead.',
      rating: 4.8,
      category: 'Mystery',
    ),

    // Romance
    Product(
      imageUrl: 'https://i.pinimg.com/564x/a7/c7/39/a7c739ebfa8a75433d871e2e14de99f6.jpg',
      title: 'Pride and Prejudice',
      description: 'In 19th-century England, a spirited young woman navigates issues of class, marriage, and family.',
      rating: 4.7,
      category: 'Romance',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/7e/d5/64/7ed5643e2fb4f2b5575a898a197f2aea.jpg',
      title: 'The Notebook',
      description: 'A romantic drama about a young couple falling in love during the early years of World War II.',
      rating: 4.6,
      category: 'Romance',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/f2/c8/88/f2c8885af2052f299015347504ea93d2.jpg',
      title: 'La La Land',
      description: 'A jazz musician and an aspiring actress fall in love while pursuing their dreams in Los Angeles.',
      rating: 4.7,
      category: 'Romance',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/c6/09/b5/c609b598f91abdd4ad720a4fafe61c57.jpg',
      title: 'Titanic',
      description: 'A love story unfolds on the ill-fated RMS Titanic.',
      rating: 4.8,
      category: 'Romance',
    ),

    // Thriller
    Product(
      imageUrl: 'https://m.media-amazon.com/images/I/41HSJe5AuJL._AC_UF894,1000_QL80_.jpg',
      title: 'Prisoners',
      description: 'A desperate father takes matters into his own hands after his daughter and her friend go missing.',
      rating: 4.7,
      category: 'Thriller',
    ),
    Product(
      imageUrl: 'https://media.posterlounge.com/img/products/710000/706556/706556_poster.jpg',
      title: 'The Silence of the Lambs',
      description: 'A young FBI trainee seeks the help of an imprisoned cannibalistic serial killer to catch another killer.',
      rating: 4.8,
      category: 'Thriller',
    ),
    Product(
      imageUrl: 'https://image.tmdb.org/t/p/original/ydIO7g1XWLoWdTwVURsrQFfl0uW.jpg',
      title: 'Zodiac',
      description: 'A cartoonist becomes an amateur detective obsessed with the Zodiac killer.',
      rating: 4.7,
      category: 'Thriller',
    ),

    // Documentary
    Product(
      imageUrl: 'https://i.pinimg.com/564x/50/56/0c/50560c479e40eff159a2ba25e4c1d426.jpg',
      title: '13th',
      description: 'An in-depth look at the prison system in the United States and how it reveals the nation\'s history of racial inequality.',
      rating: 4.8,
      category: 'Documentary',
    ),
    Product(
      imageUrl: 'https://m.media-amazon.com/images/I/61V5JM526cL._AC_UF894,1000_QL80_.jpg',
      title: 'The Social Dilemma',
      description: 'Explores the dangerous human impact of social networking, with tech experts sounding the alarm.',
      rating: 4.7,
      category: 'Documentary',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/94/93/c2/9493c2bf22dac099827d2a78ec333703.jpg',
      title: 'Won\'t You Be My Neighbor?',
      description: 'An exploration of the life and legacy of Fred Rogers, the beloved host of the popular children\'s TV show.',
      rating: 4.7,
      category: 'Documentary',
    ),
    Product(
      imageUrl: 'https://m.media-amazon.com/images/I/71cw+rbRZOL.jpg',
      title: 'Blackfish',
      description: 'A documentary about the captivity of killer whales and its dangers for both humans and whales.',
      rating: 4.8,
      category: 'Documentary',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/a4/31/00/a43100cbe40920fbbc485794ab7c75ed.jpg',
      title: 'Jiro Dreams of Sushi',
      description: 'Follows an acclaimed sushi chef and his pursuit of perfection in his culinary art.',
      rating: 4.6,
      category: 'Documentary',
    ),

    // War
    Product(
      imageUrl: 'https://i.pinimg.com/564x/26/2e/40/262e405482be6b7383d59ece8e677242.jpg',
      title: 'Saving Private Ryan',
      description: 'A group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.',
      rating: 4.8,
      category: 'War',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/77/90/7a/77907a9f494419056461166640ffdb1e.jpg',
      title: '1917',
      description: 'Two soldiers are assigned to deliver a message to save a battalion from walking into a deadly trap.',
      rating: 4.7,
      category: 'War',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/cc/8c/74/cc8c74f8d3b44cd7fe5f30fb54b72f41.jpg',
      title: 'Full Metal Jacket',
      description: 'A two-phased look at the Vietnam War, focusing on the lives of soldiers.',
      rating: 4.6,
      category: 'War',
    ),
    Product(
      imageUrl: 'https://i.pinimg.com/564x/cd/c6/26/cdc626130e033b8174e016de5e41bf6b.jpg',
      title: 'Black Hawk Down',
      description: 'A historical war film based on the U.S. military\'s 1993 raid in Somalia.',
    rating: 4.5,
      category: 'War',
    ),
  ];



  static List<Product> getProducts() {
    return _products;
  }

  static List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}

class Product {
  final String imageUrl;
  final String title;
  final String description;
  final double rating;
  final String category;

  Product({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.rating,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              description == other.description &&
              imageUrl == other.imageUrl &&
              rating == other.rating &&
              category == other.category;

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      rating.hashCode ^
      category.hashCode;
}
