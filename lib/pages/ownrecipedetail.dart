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
            color: Colors.redAccent,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ingredients Section
              Text(
                "Ingredients",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              ...recipe.ingredients.map(
                (ing) => RepaintBoundary(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.006,
                    ),
                    child: Text(
                      "• $ing",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Steps Section
              Text(
                "Steps",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              ...recipe.steps.asMap().entries.map((entry) {
                int idx = entry.key + 1;
                String step = entry.value;
                return RepaintBoundary(
                  child: Padding(
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
                              "$idx",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.035),
                        Expanded(
                          child: Text(
                            step,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: screenHeight * 0.035),

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
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      child: Text(
                        "Edit",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              "Delete Recipe",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to delete this recipe?",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.032,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteRecipe(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.032,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      child: Text(
                        "Delete",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
