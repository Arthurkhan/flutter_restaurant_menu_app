import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../config/themes.dart';
import '../../config/constants.dart';

/// Screen that shows app settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme section
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSelector(context),
          
          // Language section
          _buildSectionHeader(context, 'Language'),
          _buildLanguageSelector(context),
          
          // General settings
          _buildSectionHeader(context, 'General'),
          _buildGeneralSettings(context),
          
          // About section
          _buildSectionHeader(context, 'About'),
          _buildAboutSection(context),
        ],
      ),
    );
  }
  
  /// Builds a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
  
  /// Builds the theme selector section
  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final currentTheme = state.appTheme;
        
        return Column(
          children: [
            ListTile(
              title: Text('Theme'),
              subtitle: Text(currentTheme.name),
              leading: Icon(Icons.palette),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showThemePickerDialog(context, currentTheme.type);
              },
            ),
            ListTile(
              title: Text('Customize Theme'),
              subtitle: Text('Create your own custom theme'),
              leading: Icon(Icons.color_lens),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushNamed('/admin/theme');
              },
            ),
          ],
        );
      },
    );
  }
  
  /// Shows a dialog to pick a theme
  void _showThemePickerDialog(BuildContext context, AppThemeType currentThemeType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppThemes.themes.length,
            itemBuilder: (context, index) {
              final themeType = AppThemeType.values[index];
              final appTheme = AppThemes.themes[themeType];
              
              // Skip custom theme in this picker
              if (themeType == AppThemeType.custom || appTheme == null) {
                return SizedBox.shrink();
              }
              
              return ListTile(
                title: Text(appTheme.name),
                trailing: themeType == currentThemeType
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  context.read<ThemeBloc>().add(ThemeChanged(themeType));
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  
  /// Builds the language selector section
  Widget _buildLanguageSelector(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final languages = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'it': 'Italiano',
    };
    
    return ListTile(
      title: Text('Language'),
      subtitle: Text(languages[currentLocale] ?? 'English'),
      leading: Icon(Icons.language),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showLanguagePickerDialog(context, currentLocale, languages);
      },
    );
  }
  
  /// Shows a dialog to pick a language
  void _showLanguagePickerDialog(
    BuildContext context,
    String currentLocale,
    Map<String, String> languages,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: languages.entries.map((entry) {
              final languageCode = entry.key;
              final languageName = entry.value;
              
              return ListTile(
                title: Text(languageName),
                trailing: languageCode == currentLocale
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  // TODO: Implement language change
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to $languageName'),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  
  /// Builds the general settings section
  Widget _buildGeneralSettings(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Enable Notifications'),
          subtitle: Text('Receive notifications about menu updates'),
          secondary: Icon(Icons.notifications),
          value: true, // Replace with actual value from preferences
          onChanged: (value) {
            // TODO: Save preference
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value
                      ? 'Notifications enabled'
                      : 'Notifications disabled',
                ),
              ),
            );
          },
        ),
        SwitchListTile(
          title: Text('Cache Images'),
          subtitle: Text('Store images locally for offline use'),
          secondary: Icon(Icons.image),
          value: true, // Replace with actual value from preferences
          onChanged: (value) {
            // TODO: Save preference
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value
                      ? 'Image caching enabled'
                      : 'Image caching disabled',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  /// Builds the about section
  Widget _buildAboutSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('App Version'),
          subtitle: Text('1.0.0'),
          leading: Icon(Icons.info_outline),
        ),
        ListTile(
          title: Text('Terms of Service'),
          leading: Icon(Icons.description),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to terms of service
          },
        ),
        ListTile(
          title: Text('Privacy Policy'),
          leading: Icon(Icons.privacy_tip),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to privacy policy
          },
        ),
      ],
    );
  }
}