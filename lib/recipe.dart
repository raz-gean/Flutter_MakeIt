// lib/recipe.dart

class Recipe {
  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
  });

  /// Converts Recipe to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'ingredients': ingredients.join('|'),
      'steps': steps.join('|'),
    };
  }

  /// Creates a Recipe object from a Map (when reading from the DB)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? 'assets/images/recipe1.jpg',
      ingredients: _splitField(map['ingredients']),
      steps: _splitField(map['steps']),
    );
  }

  /// Helper function to safely split list fields
  static List<String> _splitField(dynamic field) {
    if (field == null) return [];
    final text = field.toString();
    return text.isEmpty ? [] : text.split('|');
  }

  /// For easier debugging
  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, desc: $description, ingredients: ${ingredients.length}, steps: ${steps.length})';
  }
}
