import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'success_screen.dart';

class ReviewScreen extends StatefulWidget {
  final ProblemType problem;
  final LocationOption location;
  final String equipment;
  final String description;

  const ReviewScreen({
    super.key,
    required this.problem,
    required this.location,
    required this.equipment,
    required this.description,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _sending = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: const BackButton(color: AppColors.primary),
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
                color: AppColors.primary,
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full progress
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                value: 1.0,
                minHeight: 10,
                backgroundColor: AppColors.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Revise seu Chamado',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Confira os detalhes antes de enviar para nossa equipe técnica.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Review card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hero banner
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryContainer],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  // Review items
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _reviewItem(
                          icon: Icons.warning_amber,
                          label: 'Problema',
                          value: widget.problem.title,
                        ),
                        const Divider(
                            height: 24, color: AppColors.surfaceContainerHigh),
                        _reviewItem(
                          icon: Icons.location_on,
                          label: 'Local',
                          value: widget.location.name,
                        ),
                        const Divider(
                            height: 24, color: AppColors.surfaceContainerHigh),
                        _reviewItem(
                          icon: Icons.smartphone,
                          label: 'Equipamento',
                          value: 'Smartphone Pessoal',
                        ),
                        if (widget.description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                left: BorderSide(
                                    color: AppColors.primary, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Descrição',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.outline,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '"${widget.description}"',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.onSurface,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _sending ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: _sending
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Enviando...',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Abrir Chamado',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.send, size: 18),
                        ],
                      ),
              ),
            ),

            // Mensagem de erro
            if (_hasError) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Não foi possível enviar o chamado',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Verifique sua conexão e tente novamente. Seus dados foram salvos e não serão perdidos.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.onErrorContainer,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Edit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _sending ? null : () => Navigator.pop(context),
                icon:
                    const Icon(Icons.edit, size: 18, color: AppColors.primary),
                label: Text(
                  'Editar Informações',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _sending = true;
      _hasError = false;
    });

    try {
      // Simula envio para a API (substitua pela chamada real)
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            ticketNumber: '4829',
            problem: widget.problem,
            location: widget.location,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _hasError = true;
      });
    }
  }

  Widget _reviewItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
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
