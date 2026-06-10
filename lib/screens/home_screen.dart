import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import '../widgets/bottom_nav.dart';
import 'problem_details_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  // mude para StatefulWidget
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _isOffline = result.contains(ConnectivityResult.none));
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isOffline = result.contains(ConnectivityResult.none));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/banner.png',
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'NeoNPD',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Ajuda',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // banner de aviso preventivo
          if (_isOffline)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off,
                      color: Color(0xFF856404), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sem conexão. Você ainda pode preencher o chamado — ele será enviado automaticamente quando a internet voltar.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF856404),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar
                  _buildProgressBar(1, 5, 'Passo 1 de 5: Identificação'),
                  const SizedBox(height: 32),

                  // Hero Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Como podemos ajudar?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selecione o problema que você está enfrentando.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Problem Grid
                  ...problemTypes.map((p) => _ProblemCard(
                        problem: p,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProblemDetailsScreen(selectedProblem: p),
                            ),
                          );
                        },
                      )),

                  const SizedBox(height: 24),

                  // Banner
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.primaryContainer,
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Nossa equipe está pronta para resolver seu chamado com rapidez e eficiência.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildProgressBar(int current, int total, String label) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 10,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.outline,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProblemCard extends StatefulWidget {
  final ProblemType problem;
  final VoidCallback onTap;

  const _ProblemCard({required this.problem, required this.onTap});

  @override
  State<_ProblemCard> createState() => _ProblemCardState();
}

class _ProblemCardState extends State<_ProblemCard> {
  bool _isHovered = false;

  static const _iconColors = [
    [Color(0xFFEBF2FF), AppColors.primaryContainer],
    [Color(0xFFE8F5E9), AppColors.secondary],
    [Color(0xFFD9E2FF), AppColors.tertiary],
    [AppColors.surfaceContainerHigh, AppColors.onSurfaceVariant],
    [AppColors.errorContainer, AppColors.error],
    [AppColors.surfaceContainer, AppColors.outline],
  ];

  static const _icons = [
    Icons.wifi,
    Icons.computer,
    Icons.public,
    Icons.print,
    Icons.videocam,
    Icons.help_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = _iconColors[widget.problem.colorIndex][0];
    final iconColor = _iconColors[widget.problem.colorIndex][1];
    final icon = _icons[widget.problem.colorIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isHovered = true),
          onTapUp: (_) {
            setState(() => _isHovered = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isHovered = false),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.problem.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.problem.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
