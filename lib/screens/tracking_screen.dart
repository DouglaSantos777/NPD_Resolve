import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'cancel_screen.dart';

class TrackingScreen extends StatelessWidget {
  final String ticketNumber;
  final ProblemType problem;
  final LocationOption location;

  const TrackingScreen({
    super.key,
    required this.ticketNumber,
    required this.problem,
    required this.location,
  });

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.arrow_back,
                    color: AppColors.outline, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Voltar',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.outline,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Status do Chamado #$ticketNumber',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sua solicitação de reparo está em processamento.',
              style: GoogleFonts.inter(
                  fontSize: 15, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // Segmented progress
            Row(
              children: [
                _progressSegment(true),
                const SizedBox(width: 6),
                _progressSegment(true),
                const SizedBox(width: 6),
                _progressSegment(false),
                const SizedBox(width: 6),
                _progressSegment(false),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Em análise',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Etapa 2 de 4',
                  style:
                      GoogleFonts.inter(fontSize: 12, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ETA card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
                ],
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.schedule,
                        color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previsão de atendimento',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        '15 minutos',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timeline card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
                ],
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                children: [
                  _timelineItem(
                    status: _TimelineStatus.completed,
                    title: 'Chamado recebido',
                    subtitle: 'Hoje, 09:30',
                    isLast: false,
                  ),
                  _timelineItem(
                    status: _TimelineStatus.active,
                    title: 'Em análise',
                    subtitle: 'Atualizado há 2 min',
                    description:
                        'O técnico João Silva está revisando as especificações do seu equipamento.',
                    isLast: false,
                  ),
                  _timelineItem(
                    status: _TimelineStatus.pending,
                    title: 'Técnico a caminho',
                    subtitle: 'Aguardando análise',
                    isLast: false,
                  ),
                  _timelineItem(
                    status: _TimelineStatus.pending,
                    title: 'Problema resolvido',
                    subtitle: 'Conclusão do atendimento',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Technician card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.surfaceContainerLow,
                    child: const Icon(Icons.person,
                        color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'João Silva',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          'Técnico de Redes',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.outline),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _actionBtn(Icons.chat_bubble_outline),
                      const SizedBox(width: 8),
                      _actionBtn(Icons.call_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Cancel button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CancelScreen(ticketNumber: ticketNumber),
                    ),
                  );
                },
                child: Text(
                  'Cancelar Chamado',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _progressSegment(bool active) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _timelineItem({
    required _TimelineStatus status,
    required String title,
    required String subtitle,
    String? description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _dotIndicator(status),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.surfaceContainerHigh,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: status == _TimelineStatus.completed
                          ? AppColors.secondary
                          : status == _TimelineStatus.active
                              ? AppColors.primary
                              : AppColors.outline,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dotIndicator(_TimelineStatus status) {
    switch (status) {
      case _TimelineStatus.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        );
      case _TimelineStatus.active:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        );
      case _TimelineStatus.pending:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
          ),
        );
    }
  }

  Widget _actionBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
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

enum _TimelineStatus { completed, active, pending }
