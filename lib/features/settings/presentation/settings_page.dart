import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/core/theme/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: const CommonAppBar(title: '설정'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // 1. App Logo & Version Header
          const _AppVersionHeader(),

          const SizedBox(height: 32),

          // 2. App Settings Group
          _SettingsGroup(
            title: '앱 설정',
            children: [
              _SettingsSwitchTile(
                icon: Icons.notifications_outlined,
                title: '알림 설정',
                value: _isNotificationEnabled,
                onChanged: (val) {
                  setState(() => _isNotificationEnabled = val);
                },
              ),
              _SettingsActionTile(
                icon: Icons.dark_mode_outlined,
                title: '화면 모드',
                trailingText: _getThemeModeText(ThemeService().value),
                onTap: () => _showThemeSelectionSheet(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. App Info & Legal Group
          _SettingsGroup(
            title: '앱 정보',
            children: [
              _SettingsActionTile(
                icon: Icons.campaign_outlined,
                title: '공지사항',
                onTap: () {},
              ),
              _SettingsActionTile(
                icon: Icons.description_outlined,
                title: '이용약관',
                onTap: () {},
              ),
              _SettingsActionTile(
                icon: Icons.privacy_tip_outlined,
                title: '개인정보처리방침',
                onTap: () {},
              ),
              _SettingsActionTile(
                icon: Icons.code,
                title: '오픈소스 라이선스',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 40),
          
          const Center(
            child: Text(
              'Copyright © 2026 SsogSsog. All rights reserved.',
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return '시스템 설정';
      case ThemeMode.light: return '라이트 모드';
      case ThemeMode.dark: return '다크 모드';
    }
  }

  void _showThemeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _ThemeOptionTile(
                title: '시스템 설정',
                selected: ThemeService().value == ThemeMode.system,
                onTap: () {
                  ThemeService().setThemeMode(ThemeMode.system);
                  setState(() {}); // Update text UI
                  Navigator.pop(context);
                },
              ),
              _ThemeOptionTile(
                title: '라이트 모드',
                selected: ThemeService().value == ThemeMode.light,
                onTap: () {
                  ThemeService().setThemeMode(ThemeMode.light);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              _ThemeOptionTile(
                title: '다크 모드',
                selected: ThemeService().value == ThemeMode.dark,
                onTap: () {
                  ThemeService().setThemeMode(ThemeMode.dark);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        color: selected ? AppColors.primaryBlue : Colors.black,
      )),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primaryBlue) : null,
      onTap: onTap,
    );
  }
}

class _AppVersionHeader extends StatelessWidget {
  const _AppVersionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // TODO: Replace with actual App Logo Asset
          child: const Center(
            child: Icon(Icons.show_chart_rounded, size: 40, color: AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '주식 쏙쏙',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2E3137),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '현재 버전 1.0.0',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B93A1).withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B93A1),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const Divider(height: 1, thickness: 0.5, indent: 56, endIndent: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _SettingsActionTile({
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF5A5E6A)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E3137),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B93A1),
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFFC0C5DC)),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF5A5E6A)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E3137),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryBlue,
      ),
    );
  }
}
