import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recipe.dart';
import '../db_helper.dart';
import 'make_recipe.dart';

class OwnRecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const OwnRecipeDetailPage({super.key, required this.recipe});

  void _deleteRecipe(BuildContext context) async {
    if (recipe.id != null) {
      await DBHelper.instance.deleteRecipe(recipe.id!);
      if (context.mounted) {
        //
        Navigator.pop(context, true);
      } // Return true to indicate deletion
    }
  }

  void _editRecipe(BuildContext context) async {
    // Open MakeRecipePage with existing recipe details
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MakeRecipePage()),
    );

    if (!context.mounted) return;

    if (result != null) {
      Navigator.pop(context, result); // Return updated recipe
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: GoogleFonts.oswald(color: Colors.redAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredients
            Text(
              "Ingredients",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (ing) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• $ing", style: GoogleFonts.poppins(fontSize: 14)),
              ),
            ),

            const SizedBox(height: 16),

            // Steps
            Text(
              "Steps",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "$idx. $step",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _editRecipe(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Recipe"),
                          content: const Text(
                            "Are you sure you want to delete this recipe?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteRecipe(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
