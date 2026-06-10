import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'review_screen.dart';

const Map<String, EquipmentInfo> kKnownQrCodes = {
  'LOC-LIBRARY': EquipmentInfo(
      name: 'Biblioteca', tag: 'LOC-LIBRARY', location: 'Biblioteca'),
  'LOC-LAB1': EquipmentInfo(
      name: 'Laboratório 1', tag: 'LOC-LAB1', location: 'Laboratório 1'),
  'LOC-LAB2': EquipmentInfo(
      name: 'Laboratório 2', tag: 'LOC-LAB2', location: 'Laboratório 2'),
  'LOC-CLASSROOM': EquipmentInfo(
      name: 'Sala de aula', tag: 'LOC-CLASSROOM', location: 'Sala de aula'),
  'LOC-OTHER': EquipmentInfo(
      name: 'Outro local', tag: 'LOC-OTHER', location: 'Outro local'),
};

class EquipmentInfo {
  final String name;
  final String tag;
  final String location;
  const EquipmentInfo(
      {required this.name, required this.tag, required this.location});
}

class QrScanScreen extends StatefulWidget {
  final ProblemType selectedProblem;
  final LocationOption selectedLocation;
  final String description;

  const QrScanScreen({
    super.key,
    required this.selectedProblem,
    required this.selectedLocation,
    required this.description,
  });

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnim;

  final MobileScannerController _cameraController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _scanned = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnim = CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(Barcode barcode, MobileScannerArguments? args) {
    if (_scanned) return;
    final raw = barcode.rawValue;
    if (raw == null || raw.isEmpty) return;

    setState(() => _scanned = true);
    HapticFeedback.mediumImpact();
    _cameraController.stop();

    final equipment = kKnownQrCodes[raw];
    if (equipment != null) {
      _showFoundDialog(equipment);
    } else {
      _showUnknownDialog(raw);
    }
  }

  void _showFoundDialog(EquipmentInfo eq) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.secondary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Localização identificada!',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.location_on, 'Local', eq.location),
            const SizedBox(height: 8),
            _infoRow(Icons.qr_code, 'Código QR', eq.tag),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToReview(eq.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Confirmar localização',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _scanned = false);
                _cameraController.start();
              },
              child: Text(
                'Escanear novamente',
                style:
                    GoogleFonts.inter(color: AppColors.outline, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnknownDialog(String raw) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.help_outline,
                  color: AppColors.error, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Local não cadastrado',
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta localização não está cadastrada no NPD. Deseja abrir o chamado assim mesmo?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(raw,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.outline)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _scanned = false);
                      _cameraController.start();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Cancelar',
                        style: GoogleFonts.inter(color: AppColors.outline)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToReview(raw);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Continuar',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    GoogleFonts.inter(fontSize: 11, color: AppColors.outline)),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface)),
          ],
        ),
      ],
    );
  }

  void _navigateToReview(String equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewScreen(
          problem: widget.selectedProblem,
          location: widget.selectedLocation,
          equipment: equipment,
          description: widget.description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Escanear QR Code',
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white),
            onPressed: () {
              _cameraController.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),
          _buildScanOverlay(context),
          _buildScanLine(context),
          _buildBottomPanel(context),
        ],
      ),
    );
  }

  Widget _buildScanOverlay(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const cutoutSize = 260.0;
    final cutoutTop = (size.height - cutoutSize) / 2 - 60;
    const cornerRadius = 12.0;
    const cornerLen = 30.0;
    const cornerThick = 4.0;
    const cornerColor = AppColors.primaryContainer;

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut)),
              Positioned(
                top: cutoutTop,
                left: (size.width - cutoutSize) / 2,
                child: Container(
                  width: cutoutSize,
                  height: cutoutSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cornerRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: cutoutTop,
            left: (size.width - cutoutSize) / 2,
            child: _corner(
                top: true,
                left: true,
                len: cornerLen,
                thick: cornerThick,
                color: cornerColor,
                radius: cornerRadius)),
        Positioned(
            top: cutoutTop,
            right: (size.width - cutoutSize) / 2,
            child: _corner(
                top: true,
                left: false,
                len: cornerLen,
                thick: cornerThick,
                color: cornerColor,
                radius: cornerRadius)),
        Positioned(
            top: cutoutTop + cutoutSize - cornerLen,
            left: (size.width - cutoutSize) / 2,
            child: _corner(
                top: false,
                left: true,
                len: cornerLen,
                thick: cornerThick,
                color: cornerColor,
                radius: cornerRadius)),
        Positioned(
            top: cutoutTop + cutoutSize - cornerLen,
            right: (size.width - cutoutSize) / 2,
            child: _corner(
                top: false,
                left: false,
                len: cornerLen,
                thick: cornerThick,
                color: cornerColor,
                radius: cornerRadius)),
      ],
    );
  }

  Widget _corner({
    required bool top,
    required bool left,
    required double len,
    required double thick,
    required Color color,
    required double radius,
  }) {
    return SizedBox(
      width: len,
      height: len,
      child: CustomPaint(
        painter: _CornerPainter(
            top: top, left: left, thick: thick, color: color, radius: radius),
      ),
    );
  }

  Widget _buildScanLine(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const cutoutSize = 260.0;
    final cutoutTop = (size.height - cutoutSize) / 2 - 60;

    return AnimatedBuilder(
      animation: _scanLineAnim,
      builder: (_, __) {
        final y = cutoutTop + 4 + _scanLineAnim.value * (cutoutSize - 8);
        return Positioned(
          top: y,
          left: (size.width - cutoutSize) / 2 + 8,
          right: (size.width - cutoutSize) / 2 + 8,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Colors.transparent,
                AppColors.primaryContainer,
                Colors.transparent,
              ]),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.8),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Escaneie o QR Code da localização para preencher os dados automaticamente e evitar erros.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showManualInputDialog(),
                icon:
                    const Icon(Icons.keyboard, color: Colors.white70, size: 18),
                label: Text('Inserir manualmente',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _simulateScan(String code) {
    if (_scanned) return;
    setState(() => _scanned = true);
    HapticFeedback.mediumImpact();
    final equipment = kKnownQrCodes[code]!;
    _showFoundDialog(equipment);
  }

  void _showManualInputDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Inserir código do local',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'Ex.: LOC-LAB1',
            hintStyle: GoogleFonts.inter(color: AppColors.outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: GoogleFonts.inter(color: AppColors.outline)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final val = controller.text.trim().toUpperCase();
              if (val.isEmpty) return;
              final eq = kKnownQrCodes[val];
              if (eq != null) {
                _showFoundDialog(eq);
              } else {
                _navigateToReview(val);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirmar',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top, left;
  final double thick, radius;
  final Color color;

  const _CornerPainter({
    required this.top,
    required this.left,
    required this.thick,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - radius);
      path.arcToPoint(Offset(radius, size.height),
          radius: Radius.circular(radius));
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width - radius, size.height);
      path.arcToPoint(Offset(size.width, size.height - radius),
          radius: Radius.circular(radius));
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
