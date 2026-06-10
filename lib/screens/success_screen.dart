import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'tracking_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String ticketNumber;
  final ProblemType problem;
  final LocationOption location;

  const SuccessScreen({
    super.key,
    required this.ticketNumber,
    required this.problem,
    required this.location,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late Animation<double> _checkAnimation;
  final List<_ConfettiParticle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    );

    // Generate confetti
    for (int i = 0; i < 30; i++) {
      _particles.add(_ConfettiParticle(random: _random));
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _checkController.forward();
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 1,
        shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'NeoNPD',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Ajuda',
                style: GoogleFonts.inter(color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) {
              return CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _confettiController.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Center(
              child: Column(
                children: [
                  // Main success card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Checkmark
                        ScaleTransition(
                          scale: _checkAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.secondary,
                                size: 80,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Chamado enviado\ncom sucesso!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Número do chamado: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                TextSpan(
                                  text: '#${widget.ticketNumber}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Sua solicitação foi registrada e um técnico será designado em breve. Você receberá atualizações por e-mail.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Acompanhar button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TrackingScreen(
                                    ticketNumber: widget.ticketNumber,
                                    problem: widget.problem,
                                    location: widget.location,
                                  ),
                                ),
                              );
                            },
                            icon:
                                const Icon(Icons.confirmation_number, size: 20),
                            label: Text(
                              'Acompanhar',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          child: Text(
                            'Voltar para o Início',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info cards
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          icon: Icons.schedule,
                          iconColor: AppColors.secondary,
                          borderColor: AppColors.secondary,
                          title: 'Prazo estimado',
                          subtitle: 'Até 24 horas úteis',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(
                          icon: Icons.notifications_outlined,
                          iconColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          title: 'Notificações',
                          subtitle: 'Ativadas para este ticket',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, 'Home'),
              _navItemActive(Icons.confirmation_number, 'Meus Chamados'),
              _navItem(Icons.person_outline, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _navItemActive(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.onPrimaryContainer, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.onPrimaryContainer,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ConfettiParticle {
  late double x;
  late double vx;
  late double vy;
  late Color color;
  late double size;
  late double rotation;

  _ConfettiParticle({required Random random}) {
    x = random.nextDouble();
    vx = (random.nextDouble() - 0.5) * 0.3;
    vy = 0.3 + random.nextDouble() * 0.5;
    color = [
      AppColors.secondaryContainer,
      AppColors.secondary,
      AppColors.primaryFixed,
      AppColors.primary.withOpacity(0.6),
    ][random.nextInt(4)];
    size = 6 + random.nextDouble() * 8;
    rotation = random.nextDouble() * 2 * pi;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color;
      final x = p.x * size.width + p.vx * progress * size.width;
      final y = p.vy * progress * size.height;
      final opacity = 1.0 - progress;

      paint.color = p.color.withOpacity(opacity.clamp(0, 1));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + progress * 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 1.6),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
