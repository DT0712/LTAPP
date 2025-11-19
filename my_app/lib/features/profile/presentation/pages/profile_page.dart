import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Dùng route name của màn đăng nhập
import '../../../auth/presentation/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notifOn = true;
  String _language = 'Tiếng Việt';

  // Để biết là người dùng vừa bấm Đăng xuất (để show thông báo thành công)
  bool _signedOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            final user = snap.data;

            if (user == null) {
              if (_signedOut) {
                return _SignedOut(
                  onGoLogin: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.routeName,
                          (route) => false,
                    );
                  },
                );
              }
              // Chưa đăng nhập
              return _NotSignedIn(
                onSignInHint: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hãy quay lại trang đăng nhập để đăng nhập Google.',
                      ),
                    ),
                  );
                },
              );
            }

            // Đã đăng nhập
            final photoUrl = user.photoURL;
            final displayName = user.displayName?.trim();
            final email = user.email ?? '';
            final phone = user.phoneNumber ?? '';

            final name = (displayName?.isNotEmpty ?? false)
                ? displayName!
                : (email.isNotEmpty ? email.split('@').first : 'Người dùng');

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _HeaderCard(
                        name: name,
                        email: email,
                        photoUrl: photoUrl,
                        onEdit: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng chỉnh sửa hồ sơ sẽ sớm có 😄'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // ===== Nhóm 1 =====
                      _SectionCard(
                        children: [
                          _SettingTile(
                            icon: Icons.manage_accounts_outlined,
                            title: 'Chỉnh sửa hồ sơ',
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mở màn chỉnh sửa hồ sơ…'),
                                ),
                              );
                            },
                          ),
                          _SwitchTile(
                            icon: Icons.notifications_outlined,
                            title: 'Thông báo',
                            value: _notifOn,
                            onChanged: (v) => setState(() => _notifOn = v),
                          ),
                          _SettingTile(
                            icon: Icons.language_outlined,
                            title: 'Ngôn ngữ',
                            trailing: Text(_language, style: _trailingStyle),
                            onTap: () async {
                              final val = await _pickOption(
                                context,
                                title: 'Chọn ngôn ngữ',
                                options: const ['Tiếng Việt', 'English'],
                                current: _language,
                              );
                              if (val != null) setState(() => _language = val);
                            },
                          ),
                        ],
                      ),

                      // ===== Nhóm 2 =====
                      _SectionCard(
                        children: [
                          _SettingTile(
                            icon: Icons.verified_user_outlined,
                            title: 'Bảo mật',
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mở cài đặt bảo mật…'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      // ===== Nhóm 3 =====
                      _SectionCard(
                        children: const [
                          _SettingTile(
                            icon: Icons.support_agent_outlined,
                            title: 'Trợ giúp & hỗ trợ',
                            trailing: Icon(Icons.chevron_right),
                          ),
                          _SettingTile(
                            icon: Icons.phone_in_talk_outlined,
                            title: 'Liên hệ',
                            trailing: Icon(Icons.chevron_right),
                          ),
                          _SettingTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Chính sách bảo mật',
                            trailing: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Thông tin tài khoản
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _AccountInfo(
                          email: email,
                          phone: phone,
                          providerId: user.providerData.isNotEmpty
                              ? user.providerData.first.providerId
                              : '',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Đăng xuất
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Đăng xuất'),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (!mounted) return;
                              setState(() {
                                _signedOut = true; // để biết hiển thị trạng thái đã đăng xuất
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đăng xuất thành công.'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static const _trailingStyle = TextStyle(
    color: Colors.blueGrey,
    fontWeight: FontWeight.w600,
  );

  Future<String?> _pickOption(
      BuildContext context, {
        required String title,
        required List<String> options,
        required String current,
      }) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...options.map(
                  (o) => ListTile(
                title: Text(o),
                trailing:
                o == current ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () => Navigator.pop(context, o),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// =================== Sub-widgets ===================

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // nền bo dưới
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE9F0FF), Color(0xFFD7E6FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.mode_edit_outline_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                            ? NetworkImage(photoUrl!)
                            : null,
                        child: (photoUrl == null || photoUrl!.isEmpty)
                            ? const Icon(Icons.person,
                            size: 42, color: Colors.blueGrey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Icon(Icons.edit, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Tên + Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Switch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo({
    required this.email,
    required this.phone,
    required this.providerId,
  });

  final String email;
  final String phone;
  final String providerId;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _infoRow(Icons.alternate_email, email.isNotEmpty ? email : '—'),
      _infoRow(Icons.phone, phone.isNotEmpty ? phone : '—'),
      _infoRow(Icons.verified_user_outlined, providerId),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _NotSignedIn extends StatelessWidget {
  const _NotSignedIn({required this.onSignInHint});
  final VoidCallback onSignInHint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Bạn chưa đăng nhập',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vui lòng đăng nhập bằng Google để hiển thị hồ sơ.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSignInHint,
              child: const Text('Hướng dẫn đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut({required this.onGoLogin});
  final VoidCallback onGoLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 68, color: Colors.green),
            const SizedBox(height: 12),
            const Text(
              'Bạn đã đăng xuất thành công',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bạn có thể quay lại trang đăng nhập để đăng nhập tài khoản khác.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onGoLogin,
              icon: const Icon(Icons.login),
              label: const Text('Về trang đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
