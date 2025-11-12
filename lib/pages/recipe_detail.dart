import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recipe.dart';
import '../db_helper.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await DBHelper.instance.getRecipes();
    setState(() {
      isFavorite = favorites.any((r) => r.title == widget.recipe.title);
    });
  }

  Future<void> _toggleFavorite() async {
    final favorites = await DBHelper.instance.getRecipes();
    final existing = favorites.firstWhere(
      (r) => r.title == widget.recipe.title,
      orElse: () => Recipe(
        title: '',
        description: '',
        imagePath: '',
        ingredients: [],
        steps: [],
      ),
    );

    if (isFavorite && existing.id != null) {
      await DBHelper.instance.deleteRecipe(existing.id!);
    } else {
      await DBHelper.instance.insertRecipe(widget.recipe);
    }

    setState(() => isFavorite = !isFavorite);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to Favorites ❤️' : 'Removed from Favorites 💔',
          style: GoogleFonts.poppins(),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[850],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(
          recipe.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.oswald(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 Recipe Image - Responsive and optimized
              RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    recipe.imagePath,
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheHeight: (screenHeight * 0.25).toInt(),
                    cacheWidth: screenWidth.toInt(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 📝 Description
              Text(
                recipe.description,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.038,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // 🍳 Ingredients Section
              Text(
                "Ingredients",
                style: GoogleFonts.oswald(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: recipe.ingredients
                      .map(
                        (ingredient) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.006,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "• ",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ingredient.trim(),
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // 🧾 Steps Section
              Text(
                "Steps",
                style: GoogleFonts.oswald(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: recipe.steps.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    String step = entry.value;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.008,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth * 0.08,
                            height: screenWidth * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "$index",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.005,
                              ),
                              child: Text(
                                step.trim(),
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // ❤️ Favorite Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.06,
                  child: ElevatedButton.icon(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                    label: Text(
                      isFavorite ? "In Favorites" : "Add to Favorites",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFavorite
                          ? Colors.redAccent
                          : Colors.redAccent.withValues(alpha: 0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
