import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db_helper.dart';
import '../recipe.dart';

class MakeRecipePage extends StatefulWidget {
  const MakeRecipePage({super.key});

  @override
  State<MakeRecipePage> createState() => _MakeRecipePageState();
}

class _MakeRecipePageState extends State<MakeRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      Recipe newRecipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        imagePath: "assets/images/custom.jpg", // default or placeholder
        ingredients: _ingredientsController.text.split(','),
        steps: _stepsController.text.split(','),
      );

      await DBHelper.instance.insertUserRecipe(newRecipe);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe saved successfully!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Recipe",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
          ),
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Title Input
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Recipe Title",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    validator: (val) =>
                        val!.isEmpty ? "Please enter a title" : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Description Input
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Short Description",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    validator: (val) =>
                        val!.isEmpty ? "Please enter a description" : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Ingredients Input
                  TextFormField(
                    controller: _ingredientsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Ingredients (separate by comma)",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    validator: (val) =>
                        val!.isEmpty ? "Please list ingredients" : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Steps Input
                  TextFormField(
                    controller: _stepsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Steps (separate by comma)",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    validator: (val) =>
                        val!.isEmpty ? "Please list steps" : null,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: _saveRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Save Recipe",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
