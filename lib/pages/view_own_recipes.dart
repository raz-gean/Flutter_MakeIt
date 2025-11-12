import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db_helper.dart';
import '../recipe.dart';
import 'make_recipe.dart';
import 'ownrecipedetail.dart';

class ViewOwnRecipesPage extends StatefulWidget {
  const ViewOwnRecipesPage({super.key});

  @override
  State<ViewOwnRecipesPage> createState() => _ViewOwnRecipesPageState();
}

class _ViewOwnRecipesPageState extends State<ViewOwnRecipesPage> {
  List<Recipe> userRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }

  void _loadUserRecipes() async {
    final data = await DBHelper.instance.getUserRecipes();
    setState(() {
      userRecipes = data;
    });
  }

  void _deleteRecipe(int id) async {
    await DBHelper.instance.deleteUserRecipe(id);
    _loadUserRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Recipes",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
          ),
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MakeRecipePage()),
          ).then((_) => _loadUserRecipes());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: userRecipes.isEmpty
          ? Center(
              child: Text(
                "No recipes yet. Add one!",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[700],
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: userRecipes.length,
              itemBuilder: (context, i) {
                final recipe = userRecipes[i];
                return _buildRecipeCard(recipe, screenWidth, screenHeight, i);
              },
            ),
    );
  }

  Widget _buildRecipeCard(
    Recipe recipe,
    double screenWidth,
    double screenHeight,
    int index,
  ) {
    return RepaintBoundary(
      child: Card(
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        child: ListTile(
          contentPadding: EdgeInsets.all(screenWidth * 0.03),
          title: Text(
            recipe.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.038,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.008),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * 0.006),
                Text(
                  "${recipe.ingredients.length} ingredients • ${recipe.steps.length} steps",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OwnRecipeDetailPage(recipe: recipe),
              ),
            );
            _loadUserRecipes();
          },
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: screenWidth * 0.05,
            ),
            onPressed: () => _deleteRecipe(recipe.id!),
          ),
        ),
      ),
    );
  }
}
