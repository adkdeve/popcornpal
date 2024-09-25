import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkTheme;
  late ThemeNotifier themeNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeNotifier = Provider.of<ThemeNotifier>(context);
    _isDarkTheme = themeNotifier.isDarkTheme; // Initialize the theme state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingsCard(
              title: 'Dark Theme',
              subtitle: 'Enable dark mode for the app',
              icon: Icons.dark_mode,
              trailingWidget: Switch(
                value: _isDarkTheme,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkTheme = value; // Update the toggle state
                  });
                  themeNotifier.toggleTheme(value); // Update the theme notifier
                },
              ),
            ),
            const Divider(),
            _buildSettingsCard(
              title: 'Notifications',
              subtitle: 'Manage your notifications settings',
              icon: Icons.notifications,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon!')),
                );
              },
            ),
            const Divider(),
            _buildSettingsCard(
              title: 'Feedback',
              subtitle: 'Send us your feedback',
              icon: Icons.feedback,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback form coming soon!')),
                );
              },
            ),
            const Divider(),
            _buildSettingsCard(
              title: 'Contact Us',
              subtitle: 'Get in touch with us',
              icon: Icons.contact_mail,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact us at support@movieapp.com')),
                );
              },
            ),
            const Divider(),
            _buildSettingsCard(
              title: 'About App',
              subtitle: 'Learn more about the app',
              icon: Icons.info_outline,
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: _isDarkTheme ? Colors.grey[850] : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: _isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: _isDarkTheme ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: trailingWidget ?? const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Movie App',
      applicationVersion: '1.0.0',
      applicationIcon: Image.network(
        'https://via.placeholder.com/100',
        width: 50,
        height: 50,
      ),
      applicationLegalese: '© 2024 Movie App Inc. All rights reserved.',
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'This app allows you to explore and enjoy a wide range of movies across different genres. '
                'You can search, browse, and view movie details. Stay tuned for more features!',
          ),
        ),
      ],
    );
  }
}
