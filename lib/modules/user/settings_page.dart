import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Text(
              "Manage your preferences and personalize your\nexperience by adjusting options in settings",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const Divider(thickness: 0.5),

          _buildSettingsTile(context, "Languages(English)", const LanguagePage()),
          _buildDivider(),

          _buildSettingsTile(context, "Red Card", const RedCardPage()),
          _buildDivider(),

          _buildSettingsTile(context, "Allow Notifications", const NotificationPage()),
          _buildDivider(),

          _buildSettingsTile(context, "Sounds", const SoundPage()),
          _buildDivider(),

          _buildSettingsTile(context, "Repeat Alerts", const RepeatAlertsPage()),
          _buildDivider(),

          _buildSettingsTile(context, "Privacy  Policy", const PrivacyPolicyPage()),
          _buildDivider(),

          _buildSettingsTile(context, "Terms & Conditions", const TermsConditionsPage()),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
    );
  }

  Widget _buildDivider() => const Divider(thickness: 0.5, height: 0);
}





class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Languages")),
      body: const Center(child: Text("Language Settings Page")),
    );
  }
}







class RedCardPage extends StatelessWidget {
  const RedCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Red Card")),
      body: const Center(child: Text("Red Card Settings Page")),
    );
  }
}


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(child: Text("Notification Settings Page")),
    );
  }
}



class SoundPage extends StatelessWidget {
  const SoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sounds")),
      body: const Center(child: Text("Sound Settings Page")),
    );
  }
}


class RepeatAlertsPage extends StatelessWidget {
  const RepeatAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Repeat Alerts")),
      body: const Center(child: Text("Repeat Alerts Settings Page")),
    );
  }
}





class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Delivery Partner Privacy Policy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Divider(thickness: 1.2),
                SizedBox(height: 16),
                Text(
                  'The Delivery Partner Privacy Policy outlines how personal information of delivery partners is collected, used, and protected. It covers data such as contact details, location tracking, payment information, and delivery history. Ensuring that all sensitive information is handled securely and only shared with necessary third parties for the purpose of completing deliveries. The policy also explains how data can be updated or removed, the rights of the delivery partner regarding their data, and the measures taken to maintain confidentiality and privacy.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'The Delivery Partner Privacy Policy ensures that personal information provided by delivery partners is collected, processed, and stored in compliance with data protection laws. Information such as name, contact details, vehicle information, location, and delivery history is gathered to facilitate seamless delivery operations. This data is used to verify identities, improve service efficiency, and ensure timely payments. The policy guarantees that all data is securely stored and only shared with third parties when necessary to complete deliveries, such as with restaurants and customers.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: const Center(child: Text("Terms & Conditions Page")),
    );
  }
}