import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'qr_scan_screen.dart';

class ProblemDetailsScreen extends StatefulWidget {
  final ProblemType selectedProblem;

  const ProblemDetailsScreen({super.key, required this.selectedProblem});

  @override
  State<ProblemDetailsScreen> createState() => _ProblemDetailsScreenState();
}

class _ProblemDetailsScreenState extends State<ProblemDetailsScreen> {
  String? _selectedLocationId;
  final _descController = TextEditingController();
  int _charCount = 0;
  bool _isOffline = false;

  static const _locationIcons = {
    'library': Icons.menu_book,
    'lab1': Icons.science,
    'lab2': Icons.biotech,
    'classroom': Icons.school,
    'other': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();
    _descController.addListener(
        () => setState(() => _charCount = _descController.text.length));
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
  void dispose() {
    _descController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalhes do Problema',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Ajuda',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PASSO 2 DE 3',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Quase lá',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                value: 0.66,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),

            // Banner verde — cache offline (sempre visível, informativo)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done_outlined,
                      color: AppColors.secondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dados protegidos offline · Sincronização automática ativa',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Banner vermelho — aviso do servidor (só aparece offline)
            if (_isOffline)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.error, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.onErrorContainer,
                            height: 1.45,
                          ),
                          children: [
                            TextSpan(
                              text: 'Atenção: ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onErrorContainer,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  'Identificamos uma instabilidade geral no servidor da UESPI no momento. A equipe já está trabalhando nisso!',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: _isOffline ? 20 : 10),

            // Chip do problema selecionado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.5),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: AppColors.primaryContainer.withOpacity(0.3)),
              ),
              child: Text(
                widget.selectedProblem.title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção de localização
            Text(
              'Onde você está?',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ...locationOptions.map((loc) => _LocationCard(
                  location: loc,
                  icon: _locationIcons[loc.id] ?? Icons.location_on,
                  isSelected: _selectedLocationId == loc.id,
                  onTap: () => setState(() => _selectedLocationId = loc.id),
                )),

            const SizedBox(height: 24),

            // Descrição
            Text(
              'Descreva o que aconteceu (Opcional)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  maxLength: 500,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  style: GoogleFonts.inter(
                      fontSize: 15, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    hintText: 'Ex.: O computador não liga desde que cheguei.',
                    hintStyle: GoogleFonts.inter(
                        color: AppColors.outline, fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Text(
                    '$_charCount/500',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: _charCount > 450
                          ? AppColors.error
                          : AppColors.outline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Botão Continuar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _selectedLocationId != null
                    ? () {
                        final loc = locationOptions
                            .firstWhere((l) => l.id == _selectedLocationId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QrScanScreen(
                              selectedProblem: widget.selectedProblem,
                              selectedLocation: loc,
                              description: _descController.text,
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const SizedBox.shrink(),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continuar',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.surfaceContainerHigh,
                  disabledForegroundColor: AppColors.outline,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationOption location;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationCard({
    required this.location,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryContainer : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  location.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.onSurface,
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
