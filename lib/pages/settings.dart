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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.oswald(color: Colors.redAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Preferences",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Dark Mode Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Dark Mode", style: GoogleFonts.poppins()),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeThumbColor:
                  Colors.redAccent, // updated from deprecated property
              activeTrackColor: Colors.redAccent.withValues(alpha: 0.4),
            ),

            // Notifications Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Notifications", style: GoogleFonts.poppins()),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              activeThumbColor: Colors.redAccent, // updated property
              activeTrackColor: Colors.redAccent.withValues(alpha: 0.4),
            ),

            const SizedBox(height: 24),
            Text(
              "Account",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout", style: GoogleFonts.poppins()),
              onTap: () {
                //
              },
            ),
          ],
        ),
      ),
    );
  }
}
