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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Recipes",
          style: GoogleFonts.poppins(color: Colors.white),
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
        child: const Icon(Icons.add),
      ),
      body: userRecipes.isEmpty
          ? const Center(child: Text("No recipes yet. Add one!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userRecipes.length,
              itemBuilder: (context, i) {
                final recipe = userRecipes[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      recipe.title,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      // Open the detail page
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OwnRecipeDetailPage(recipe: recipe),
                        ),
                      );

                      // Reload the list in case something changed
                      _loadUserRecipes();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteRecipe(recipe.id!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
