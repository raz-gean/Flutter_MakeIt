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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: GoogleFonts.oswald(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 🔴 Changed to white text
          ),
        ),
        backgroundColor: Colors.redAccent, // 🔴 AppBar background red
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // 🔴 White icons
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(
                  alpha: 0.1,
                ), // 🔴 Soft red glow
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 Recipe Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  recipe.imagePath,
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // 📝 Description
              Text(
                recipe.description,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // 🍳 Ingredients
              Text(
                "Ingredients",
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent, // 🔴 Title color
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(
                    alpha: 0.05,
                  ), // 🔴 Light red bg
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: recipe.ingredients
                      .map(
                        (ing) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.redAccent, // 🔴 Changed dot color
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ing,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
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

              const SizedBox(height: 24),

              // 🧾 Steps
              Text(
                "Steps",
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent, // 🔴 Title color
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: recipe.steps.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    String step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$index.",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent, // 🔴 Step number color
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),

              // ❤️ Favorite Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
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
