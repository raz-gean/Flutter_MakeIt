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
      title: "Choco Cookies",
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
    // Delay precaching until after first frame to avoid MediaQuery dependency issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _precacheImages() {
    // Precache all recipe images to avoid loading delays on device
    for (var recipe in recipes) {
      precacheImage(AssetImage(recipe.imagePath), context);
    }
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      height: isMobile ? screenHeight * 0.18 : screenHeight * 0.22,
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                "Discover\nDelicious Recipes 🍳",
                style: GoogleFonts.oswald(
                  fontSize: isMobile ? screenWidth * 0.06 : screenWidth * 0.05,
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
              padding: EdgeInsets.only(
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.015,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.008,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  ).then((_) => _loadFavorites());
                },
                icon: Icon(Icons.favorite, size: screenWidth * 0.05),
                label: Text(
                  "Favorites",
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
              ),
            ),
          ),

          // User/settings button (top right)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: screenWidth * 0.04,
                top: screenHeight * 0.015,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.redAccent,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWelcomeSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.02),
      height: screenHeight * 0.26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/bagle.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              cacheHeight: (screenHeight * 0.26).toInt(),
              cacheWidth: screenWidth.toInt(),
            ),
          ),
          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.055,
                          backgroundColor: Colors.redAccent,
                          child: Text(
                            "🍳",
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: Text(
                            "Welcome to Makeit!",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.oswald(
                              fontSize: screenWidth * 0.048,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      "Discover easy-to-follow recipes for everyone. Save favorites, explore cuisines, and start cooking today!",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.032,
                        color: Colors.white,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      "Start Cooking",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.055,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.03),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01,
              ),
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
                    : const [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return RepaintBoundary(
      child: GestureDetector(
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
                      height: screenHeight * 0.15,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheHeight: (screenHeight * 0.15).toInt(),
                      cacheWidth: MediaQuery.of(context).size.width.toInt(),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    top: screenWidth * 0.02,
                    child: InkWell(
                      onTap: () {
                        if (isFavorite) {
                          _removeFavorite(recipe);
                        } else {
                          _addFavorite(recipe);
                        }
                      },
                      child: CircleAvatar(
                        radius: screenWidth * 0.045,
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                          size: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Recipe Info
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.032,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecipeGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1000;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      itemCount: recipes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile
            ? 2
            : isTablet
            ? 3
            : 4,
        mainAxisSpacing: screenWidth * 0.035,
        crossAxisSpacing: screenWidth * 0.035,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) => buildRecipeCard(recipes[i]),
    );
  }

  Widget buildMakeYourOwnSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.03,
        bottom: screenHeight * 0.02,
      ),
      padding: EdgeInsets.all(screenWidth * 0.05),
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
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "Create your own recipe masterpiece and save it locally. You can edit or delete it anytime!",
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.032,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: screenHeight * 0.016),
          Row(
            children: [
              Expanded(
                child: _customButton(
                  icon: Icons.add,
                  label: "Add Recipe",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MakeRecipePage()),
                    );
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: _customButton(
                  icon: Icons.book,
                  label: "My Recipes",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
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
    required double screenWidth,
    required double screenHeight,
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
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.014,
              horizontal: screenWidth * 0.02,
            ),
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
                    size: screenWidth * 0.04,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    label,
                    style: TextStyle(
                      color: isHovering ? Colors.white : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.032,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenWidth * 0.06),
        Divider(color: Colors.grey[300]),
        SizedBox(height: screenWidth * 0.02),
        Text(
          "© 2025 Makeit Recipes",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.032,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          "Made with ❤️ by Group ni Raz",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.03,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Makeit",
          style: GoogleFonts.oswald(
            fontSize: screenWidth * 0.07,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeroSection(),
            buildWelcomeSection(),
            SizedBox(height: screenHeight * 0.024),
            buildCategoryBar(),
            SizedBox(height: screenHeight * 0.024),
            Text(
              "Explore Recipes",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.012),
            buildRecipeGrid(),
            buildMakeYourOwnSection(),
            buildFooter(),
          ],
        ),
      ),
    );
  }
}
