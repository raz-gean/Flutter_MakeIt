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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Recipe",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Recipe Title"),
                validator: (val) =>
                    val!.isEmpty ? "Please enter a title" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Short Description",
                ),
                validator: (val) =>
                    val!.isEmpty ? "Please enter a description" : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: "Ingredients (separate by comma)",
                ),
                validator: (val) =>
                    val!.isEmpty ? "Please list ingredients" : null,
              ),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: "Steps (separate by comma)",
                ),
                validator: (val) => val!.isEmpty ? "Please list steps" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Save Recipe",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
