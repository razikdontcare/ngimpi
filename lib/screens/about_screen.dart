import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang Ngimpi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C2E), Color(0xFF2C2C4E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Icon/Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // App Name
                Text(
                  'Ngimpi',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Version
                Text(
                  'Versi 1.0.0',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 32),

                // Description Card
                Card(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Tentang Aplikasi',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ngimpi adalah aplikasi yang membantu Anda mewujudkan impian dan tujuan finansial. '
                          'Dengan fitur yang mudah digunakan, Anda dapat:\n\n'
                          '• Menambahkan impian atau tujuan yang ingin dicapai\n'
                          '• Menetapkan target harga dan menabung secara bertahap\n'
                          '• Memantau progress tabungan dengan visual yang menarik\n'
                          '• Menambahkan foto untuk memotivasi diri\n'
                          '• Mengelola multiple impian sekaligus',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Features Card
                Card(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.featured_play_list_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Fitur Utama',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          context,
                          Icons.add_circle_outline,
                          'Buat Impian Baru',
                          'Tambahkan impian dengan target harga dan deskripsi',
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.savings_outlined,
                          'Tabungan Bertahap',
                          'Catat setiap tabungan untuk mencapai target',
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.photo_camera_outlined,
                          'Upload Foto',
                          'Tambahkan foto impian untuk motivasi ekstra',
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.track_changes_outlined,
                          'Progress Tracking',
                          'Lihat kemajuan tabungan dengan progress bar',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Developer Info Card
                Card(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.code_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Developer',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Developed by: @razikdontcare\n'
                          'Made with ❤️ using Flutter\n\n'
                          'Dibuat untuk membantu mewujudkan impian Anda',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        // GitHub Links
                        Row(
                          children: [
                            Icon(
                              Icons.link_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Source Code:',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _launchUrl(
                            'https://github.com/razikdontcare/ngimpi',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.open_in_new,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'View on GitHub',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _launchUrl(
                            'https://github.com/razikdontcare/ngimpi/issues',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bug_report_outlined,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Report Issues',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Copyright
                Text(
                  '© 2025 Ngimpi App',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
