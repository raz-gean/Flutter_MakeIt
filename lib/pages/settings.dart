import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
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
              // User Preferences Section
              Text(
                "User Preferences",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Dark Mode Toggle
              _buildSwitchTile(
                screenWidth,
                screenHeight,
                title: "Dark Mode",
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),

              // Notifications Toggle
              _buildSwitchTile(
                screenWidth,
                screenHeight,
                title: "Notifications",
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),

              SizedBox(height: screenHeight * 0.035),

              // Account Section
              Text(
                "Account",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              _buildSettingsTile(
                screenWidth,
                title: "Logout",
                icon: Icons.logout,
                onTap: () {
                  // Logout action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    double screenWidth,
    double screenHeight, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.012,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.036,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.redAccent,
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    double screenWidth, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenWidth * 0.04,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: screenWidth * 0.05),
              SizedBox(width: screenWidth * 0.035),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.036,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: screenWidth * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
