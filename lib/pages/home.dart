import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recipe.dart';
import '../db_helper.dart';
import 'recipe_detail.dart';
import 'favorites.dart';
import 'make_recipe.dart';
import 'view_own_recipes.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [
    Recipe(
      title: "Chocolate Cookies",
      description: "Crispy on the edges and chewy in the center",
      imagePath: "assets/images/recipe1.jpg",
      ingredients: [
        "2 1/4 cups all-purpose flour",
        "1 tsp baking soda",
        "1 cup butter (softened)",
        "3/4 cup brown sugar",
        "1/2 cup white sugar",
        "2 eggs",
        "2 cups chocolate chips",
        "1 tsp vanilla extract",
        "1/2 tsp salt",
      ],
      steps: [
        "Preheat oven to 350°F (175°C).",
        "Mix flour, baking soda, and salt in a bowl.",
        "In another bowl, beat butter and sugars until creamy.",
        "Add eggs and vanilla extract, then mix well.",
        "Gradually add the dry ingredients to the wet mixture.",
        "Stir in chocolate chips.",
        "Scoop dough onto a baking tray lined with parchment paper.",
        "Bake for 10–12 minutes or until golden brown.",
      ],
    ),
    Recipe(
      title: "Strawberry Cake",
      description:
          "Soft and moist cake layered with fresh strawberries and whipped cream.",
      imagePath: "assets/images/recipe2.jpg",
      ingredients: [
        "2 cups all-purpose flour",
        "1 cup sugar",
        "1 tbsp baking powder",
        "1/2 tsp salt",
        "3/4 cup milk",
        "1/2 cup butter (melted)",
        "2 eggs",
        "1 tsp vanilla extract",
        "1 cup chopped fresh strawberries",
        "Whipped cream (for topping)",
      ],
      steps: [
        "Preheat oven to 350°F (175°C).",
        "In a large bowl, whisk flour, sugar, baking powder, and salt.",
        "Add milk, melted butter, eggs, and vanilla extract. Mix until smooth.",
        "Fold in chopped strawberries gently.",
        "Pour the batter into a greased cake pan.",
        "Bake for 30–35 minutes or until a toothpick comes out clean.",
        "Let it cool before topping with whipped cream and extra strawberries.",
      ],
    ),
    Recipe(
      title: "Pork Sisig",
      description:
          "A Filipino sizzling dish made of crispy pork, onions, and chili with a tangy flavor.",
      imagePath: "assets/images/recipe3.jpg",
      ingredients: [
        "1 lb pork belly",
        "1 onion (chopped)",
        "2 chili peppers (chopped)",
        "2 tbsp soy sauce",
        "1 tbsp calamansi or lemon juice",
        "1 egg (optional)",
        "Salt and pepper to taste",
      ],
      steps: [
        "Boil and grill pork belly until crispy, then chop finely.",
        "In a pan, sauté onions and chili peppers.",
        "Add chopped pork and season with soy sauce, calamansi, salt, and pepper.",
        "Serve hot on a sizzling plate with an egg on top.",
      ],
    ),
    Recipe(
      title: "Chicken Curry",
      description:
          "A flavorful curry dish made with tender chicken, spices, and coconut milk.",
      imagePath: "assets/images/recipe4.jpg",
      ingredients: [
        "500g chicken (cut into pieces)",
        "2 tbsp curry powder",
        "1 cup coconut milk",
        "1 onion (chopped)",
        "2 cloves garlic (minced)",
        "1 tbsp ginger (grated)",
        "Salt and pepper to taste",
      ],
      steps: [
        "Sauté onions, garlic, and ginger in a pan.",
        "Add chicken and cook until slightly browned.",
        "Stir in curry powder, then pour in coconut milk.",
        "Simmer until chicken is tender and sauce thickens.",
        "Season with salt and pepper before serving.",
      ],
    ),
    Recipe(
      title: "Lasagna",
      description:
          "Layered pasta with beef, tomato sauce, and cheese baked to perfection.",
      imagePath: "assets/images/recipe5.jpg",
      ingredients: [
        "Lasagna noodles",
        "Ground beef",
        "Tomato sauce",
        "Cheese (mozzarella & parmesan)",
        "Salt and pepper to taste",
      ],
      steps: [
        "Boil lasagna noodles and set aside.",
        "Cook beef and mix with tomato sauce.",
        "Layer noodles, sauce, and cheese alternately in a baking dish.",
        "Bake for 40 minutes until cheese is melted and golden.",
      ],
    ),
    Recipe(
      title: "Apple Pie",
      description:
          "Classic dessert with spiced apple filling and buttery crust.",
      imagePath: "assets/images/recipe6.jpg",
      ingredients: [
        "2 pie crusts",
        "5 apples (sliced)",
        "1/2 cup sugar",
        "1 tsp cinnamon",
        "1/4 tsp nutmeg",
        "1 tbsp lemon juice",
        "1 tbsp butter",
      ],
      steps: [
        "Preheat oven to 375°F (190°C).",
        "Mix apples with sugar, cinnamon, nutmeg, and lemon juice.",
        "Place one crust in a pie dish, fill with apple mixture, and top with butter.",
        "Cover with second crust, seal edges, and cut small slits on top.",
        "Bake for 45–50 minutes until golden brown.",
      ],
    ),
  ];

  List<Recipe> favoriteRecipes = [];
  final List<String> categories = [
    "All",
    "Desserts",
    "Filipino",
    "Cakes",
    "Breakfast",
    "Main Dish",
  ];

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favs = await DBHelper.instance.getRecipes();
    setState(() {
      favoriteRecipes = favs;
    });
  }

  void _addFavorite(Recipe recipe) async {
    await DBHelper.instance.insertRecipe(recipe);
    setState(() => favoriteRecipes.add(recipe));
  }

  void _removeFavorite(Recipe recipe) async {
    final favRecipe = favoriteRecipes.firstWhere(
      (fav) => fav.title == recipe.title,
      orElse: () => recipe,
    );
    if (favRecipe.id != null) {
      await DBHelper.instance.deleteRecipe(favRecipe.id!);
      setState(() {
        favoriteRecipes.removeWhere((fav) => fav.title == recipe.title);
      });
    }
  }

  Widget buildHeroSection() {
    return Container(
      height: 180, // smaller height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA69E), Color(0xFFFF686B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Main text
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Discover\nDelicious Recipes 🍳",
                style: GoogleFonts.oswald(
                  fontSize: 24, // slightly smaller
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ),

          // Favorites button (bottom right)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  ).then((_) => _loadFavorites());
                },
                icon: const Icon(Icons.favorite),
                label: const Text("Favorites"),
              ),
            ),
          ),

          // User/settings button (top right)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: GestureDetector(
                onTap: () {
                  // Navigate to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/bagle.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54, // darken the image
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.redAccent,
                child: Text("🍳", style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Text(
                "Welcome to Makeit!",
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Discover a world of easy-to-follow recipes designed for everyone—from quick snacks to full meals. Save your favorites, explore different cuisines, and start your cooking journey today!",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Start Cooking",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryBar() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.redAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRecipeCard(Recipe recipe) {
    final isFavorite = favoriteRecipes.any((fav) => fav.title == recipe.title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
        ).then((_) => _loadFavorites());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.asset(
                    recipe.imagePath,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: () {
                      if (isFavorite) {
                        _removeFavorite(recipe);
                      } else {
                        _addFavorite(recipe);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Recipe Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecipeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) => buildRecipeCard(recipes[i]),
    );
  }

  Widget buildMakeYourOwnSection() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You can also write your own recipe!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Create your own recipe masterpiece and save it locally. You can edit or delete it anytime!",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _customButton(
                  icon: Icons.add,
                  label: "Add Recipe",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MakeRecipePage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _customButton(
                  icon: Icons.book,
                  label: "My Recipes",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewOwnRecipesPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _customButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    bool isHovering = false; // local variable inside a StatefulBuilder

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isHovering ? Colors.redAccent : Colors.white,
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isHovering ? Colors.white : Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: isHovering ? Colors.white : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 8),
        Text(
          "© 2025 Makeit Recipes",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          "Made with ❤️ by Group ni Raz",
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Makeit",
          style: GoogleFonts.oswald(
            fontSize: 28,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeroSection(),
            buildWelcomeSection(),
            const SizedBox(height: 24),
            buildCategoryBar(),
            const SizedBox(height: 24),
            Text(
              "Explore Recipes",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            buildRecipeGrid(),
            buildMakeYourOwnSection(),
            buildFooter(),
          ],
        ),
      ),
    );
  }
}
