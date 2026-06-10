import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CancelScreen extends StatefulWidget {
  final String ticketNumber;

  const CancelScreen({super.key, required this.ticketNumber});

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  bool _confirming = false;
  bool _cancelling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cancelar Chamado',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Ajuda',
                style: GoogleFonts.inter(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          children: [
            // Red progress bar
            Container(
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Main card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Warning icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: AppColors.error,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Tem certeza que deseja cancelar o chamado #${widget.ticketNumber}?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Warning info box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.errorRed, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Esta ação não pode ser desfeita. Todos os dados e o histórico de atendimento deste pedido serão permanentemente encerrados.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Keep button (primary/positive)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: Text(
                        'Manter Chamado',
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: _cancelling
                        ? OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor:
                                  AppColors.errorRed.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: AppColors.errorRed,
                                      strokeWidth: 2),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Cancelando...',
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: AppColors.errorRed,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: OutlinedButton.icon(
                              onPressed: () => _handleCancelTap(context),
                              icon: Icon(
                                _confirming
                                    ? Icons.warning_rounded
                                    : Icons.cancel_outlined,
                                size: 20,
                                color: _confirming
                                    ? Colors.white
                                    : AppColors.errorRed,
                              ),
                              label: Text(
                                _confirming
                                    ? 'Clique novamente para confirmar'
                                    : 'Confirmar Cancelamento',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _confirming
                                      ? Colors.white
                                      : AppColors.errorRed,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _confirming
                                    ? AppColors.errorRed
                                    : Colors.transparent,
                                side: BorderSide(
                                  color: _confirming
                                      ? AppColors.errorRed
                                      : AppColors.outlineVariant,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Sua solicitação ainda está em análise por nossa equipe técnica.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Decorative image placeholder
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A7F5A), Color(0xFF0D5C8B)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.headset_mic,
                        color: Colors.white70, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      'Suporte técnico disponível',
                      style: GoogleFonts.inter(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancelTap(BuildContext context) {
    if (_confirming) {
      setState(() {
        _confirming = false;
        _cancelling = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Chamado #${widget.ticketNumber} cancelado com sucesso.',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    } else {
      setState(() => _confirming = true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _confirming = false);
      });
    }
  }
}
