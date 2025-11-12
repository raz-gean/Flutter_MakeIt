import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db_helper.dart';
import '../recipe.dart';
import 'recipe_detail.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    // Precache images after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _precacheImages() {
    // Precache all favorite recipe images for smooth rendering
    for (var recipe in favoriteRecipes) {
      if (recipe.imagePath.isNotEmpty) {
        precacheImage(AssetImage(recipe.imagePath), context);
      }
    }
  }

  void _loadFavorites() async {
    final favs = await DBHelper.instance.getRecipes();
    setState(() => favoriteRecipes = favs);
    // Precache newly loaded images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _removeFavorite(int id) async {
    await DBHelper.instance.deleteRecipe(id);

    if (!mounted) return;

    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed from Favorites 💔',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.grey[850],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: GoogleFonts.oswald(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(221, 251, 87, 87),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Text(
                "No favorites yet!",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[700],
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(screenWidth * 0.035),
              itemCount: favoriteRecipes.length,
              addAutomaticKeepAlives: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile
                    ? 2
                    : isTablet
                    ? 3
                    : 4,
                crossAxisSpacing: screenWidth * 0.025,
                mainAxisSpacing: screenWidth * 0.025,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return _buildFavoriteCard(recipe, screenWidth, screenHeight);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(
    Recipe recipe,
    double screenWidth,
    double screenHeight,
  ) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailPage(recipe: recipe),
            ),
          );
          _loadFavorites();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Recipe Image - Optimized height for smooth rendering
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.asset(
                  recipe.imagePath.isNotEmpty
                      ? recipe.imagePath
                      : 'assets/images/recipe1.jpg',
                  height: screenHeight * 0.14,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheHeight: (screenHeight * 0.14).toInt(),
                  cacheWidth: (screenWidth * 0.42).toInt(),
                ),
              ),

              // Recipe Info - Compact and responsive
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenWidth * 0.025,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    // Ingredients count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${recipe.ingredients.length} ingredients • ${recipe.steps.length} steps",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.028,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (recipe.id != null) {
                              _removeFavorite(recipe.id!);
                            }
                          },
                          child: Icon(
                            Icons.close,
                            size: screenWidth * 0.036,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
