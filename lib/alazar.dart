import 'dart:async';

import 'package:flutter/material.dart';

import 'notification_service.dart';

/// Reproductor premium reutilizable inspirado en Spotify.
class AlazarWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onPressed;
  final bool enabled;
  final String album;
  final String duration;
  final Duration trackDuration;
  final String? heroTag;

  const AlazarWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.onPressed,
    this.enabled = true,
    this.album = 'Spotify Session',
    this.duration = '3:45',
    this.trackDuration = const Duration(minutes: 3, seconds: 45),
    this.heroTag,
  });

  @override
  State<AlazarWidget> createState() => _AlazarWidgetState();
}

class _AlazarWidgetState extends State<AlazarWidget> {
  Timer? _progressTimer;
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isPressed = false;
  bool _isConnected = true;
  double _progress = 0.24;
  double _volume = 0.72;

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  Color _alpha(Color color, double alpha) => color.withValues(alpha: alpha);

  Duration get _currentPosition {
    final milliseconds = (widget.trackDuration.inMilliseconds * _progress).round();
    return Duration(milliseconds: milliseconds);
  }

  Duration get _remainingPosition {
    final remaining = widget.trackDuration - _currentPosition;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 220), (_) {
      if (!mounted || !_isPlaying) {
        return;
      }

      final step = 220 / widget.trackDuration.inMilliseconds.toDouble();
      final nextProgress = (_progress + step).clamp(0.0, 1.0);

      setState(() {
        _progress = nextProgress;
        _isConnected = true;
      });

      if (_progress >= 1.0) {
        setState(() {
          _isPlaying = false;
        });
        _progressTimer?.cancel();
      }
    });
  }

  void _togglePlayback() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });

    widget.onPressed?.call();

    if (_isPlaying) {
      _startProgressTimer();
    } else {
      _progressTimer?.cancel();
    }
  }

  void _skipForward() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _progress = (_progress + 0.1).clamp(0.0, 1.0);
      _isPlaying = true;
    });

    widget.onPressed?.call();
    _startProgressTimer();
  }

  void _skipBack() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _progress = (_progress - 0.1).clamp(0.0, 1.0);
    });
  }

  void _toggleFavorite() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _shareTrack() {
    if (!widget.enabled) {
      return;
    }

    widget.onPressed?.call();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        // FIX: antes se usaba theme.colorScheme.surface, que en un tema claro
        // es casi blanco y hacía invisible todo el texto blanco de la tarjeta.
        // Ahora el color de la tarjeta es fijo y oscuro, independiente del tema.
        const surfaceColor = Color(0xFF11140F);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF060807),
                const Color(0xFF09110D),
                _alpha(widget.primaryColor, 0.34),
                const Color(0xFF121412),
              ],
              stops: const [0.0, 0.46, 0.8, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 940),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(0.0, _isPressed ? 6.0 : 0.0, 0.0),
                    child: Card(
                      elevation: _isPressed ? 10 : 24,
                      shadowColor: _alpha(Colors.black, 0.42),
                      color: surfaceColor,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -40,
                              right: -30,
                              child: _GlowOrb(color: widget.primaryColor),
                            ),
                            Positioned(
                              bottom: -50,
                              left: -40,
                              child: _GlowOrb(color: widget.secondaryColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: AnimatedOpacity(
                                opacity: widget.enabled ? 1 : 0.7,
                                duration: const Duration(milliseconds: 220),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildHeader(theme),
                                    const SizedBox(height: 18),
                                    Flex(
                                      direction: isCompact ? Axis.vertical : Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildCoverSection(theme),
                                        if (!isCompact) const SizedBox(width: 20),
                                        if (isCompact) const SizedBox(height: 20),
                                        // FIX: "RenderFlex children have non-zero flex but
                                        // incoming height constraints are unbounded".
                                        // Antes esto era Expanded(child: ...), lo cual exige
                                        // que el Flex padre tenga una altura acotada. Cuando
                                        // isCompact es true, este Flex se comporta como una
                                        // Column dentro de otra Column con mainAxisSize.min
                                        // (y potencialmente dentro de un scroll sin altura
                                        // fija), así que la altura entrante es infinita y
                                        // Expanded truena. Con Flexible + FlexFit.loose en
                                        // modo vertical, el hijo solo mide lo que su contenido
                                        // necesita, sin exigir una altura acotada. En modo
                                        // horizontal (!isCompact) sí mantenemos el
                                        // comportamiento original (FlexFit.tight, equivalente
                                        // a Expanded) porque ahí el ancho normalmente sí está
                                        // acotado por el ConstrainedBox de más arriba.
                                        Flexible(
                                          fit: isCompact ? FlexFit.loose : FlexFit.tight,
                                          child: _buildInformationSection(theme),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),
                                    _buildProgressSection(theme),
                                    const SizedBox(height: 18),
                                    _buildControlsRow(theme),
                                    const SizedBox(height: 18),
                                    _buildFooter(theme),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: _alpha(widget.primaryColor, 0.18),
          child: Icon(
            Icons.graphic_eq_rounded,
            color: widget.primaryColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Session',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.enabled ? 'Reproducción activa' : 'Contenido bloqueado',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const Spacer(),
        _StatusBadge(
          label: _isConnected ? 'Conectado' : 'Sin señal',
          isActive: _isConnected,
          color: widget.primaryColor,
        ),
      ],
    );
  }

  Widget _buildCoverSection(ThemeData theme) {
    final heroTag = widget.heroTag ?? 'alazar-cover-${widget.title}';

    return Hero(
      tag: heroTag,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _alpha(widget.primaryColor, 0.95),
              _alpha(widget.secondaryColor, 0.92),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _alpha(widget.primaryColor, 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -18,
              right: -8,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.34),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(
                widget.icon,
                size: 84,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: AnimatedOpacity(
                opacity: _isPlaying ? 1 : 0.45,
                duration: const Duration(milliseconds: 220),
                child: _EqualizerBars(
                  color: Colors.white,
                  isActive: _isPlaying,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.06,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _InfoLine(label: 'Álbum', value: widget.album),
        const SizedBox(height: 10),
        _InfoLine(label: 'Duración', value: widget.duration),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SmallChip(label: 'Spotify Premium', color: widget.primaryColor),
            _SmallChip(
              label: _isPlaying ? 'Reproduciendo' : 'Pausado',
              color: _isPlaying ? Colors.greenAccent : Colors.white54,
            ),
            _SmallChip(
              label: '${(_volume * 100).round()}% volumen',
              color: widget.secondaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(ThemeData theme) {
    final current = _formatDuration(_currentPosition);
    final remaining = _formatDuration(_remainingPosition);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              current,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: widget.primaryColor,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: widget.primaryColor,
                  overlayColor: _alpha(widget.primaryColor, 0.18),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Slider(
                  value: _progress,
                  min: 0,
                  max: 1,
                  onChanged: widget.enabled
                      ? (value) {
                          setState(() {
                            _progress = value;
                          });
                        }
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '-$remaining',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: _progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsRow(ThemeData theme) {
    return Row(
      children: [
        _RoundActionButton(
          icon: Icons.skip_previous_rounded,
          onPressed: widget.enabled ? _skipBack : null,
          color: Colors.white70,
          size: 48,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.enabled ? _togglePlayback : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.enabled
                          ? [widget.primaryColor, widget.secondaryColor]
                          : [Colors.white24, Colors.white12],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _alpha(widget.primaryColor, 0.32),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: AnimatedOpacity(
                    opacity: widget.enabled ? 1 : 0.55,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.black.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        _RoundActionButton(
          icon: Icons.skip_next_rounded,
          onPressed: widget.enabled ? _skipForward : null,
          color: Colors.white70,
          size: 48,
        ),
        const SizedBox(width: 12),
        _RoundActionButton(
          icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          onPressed: widget.enabled ? _toggleFavorite : null,
          color: _isFavorite ? Colors.pinkAccent : Colors.white70,
          size: 44,
        ),
        const SizedBox(width: 10),
        _RoundActionButton(
          icon: Icons.share_rounded,
          onPressed: widget.enabled ? _shareTrack : null,
          color: Colors.white70,
          size: 44,
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.volume_up_rounded,
              color: Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  activeTrackColor: widget.secondaryColor,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: widget.secondaryColor,
                  overlayColor: _alpha(widget.secondaryColor, 0.16),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  value: _volume,
                  min: 0,
                  max: 1,
                  onChanged: widget.enabled
                      ? (value) {
                          setState(() {
                            _volume = value;
                          });
                        }
                      : null,
                ),
              ),
            ),
            Text(
              '${(_volume * 100).round()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white60,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isConnected ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isConnected ? 'Conexión estable' : 'Reconectando...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
            ),
            const Spacer(),
            Text(
              widget.enabled ? 'Listo para escuchar' : 'Deshabilitado',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Pantalla de demostración del widget. Al abrir esta ruta se ve el widget.
class AlazarPage extends StatelessWidget {
  const AlazarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlazarWidget(
        title: 'Midnight Drive',
        subtitle: 'Un demo visual con estilo premium y controles completos.',
        icon: Icons.music_note_rounded,
        primaryColor: const Color(0xFF1DB954),
        secondaryColor: const Color(0xFF0B6B3A),
        album: 'Alazar Sessions',
        duration: '3:45',
        trackDuration: const Duration(minutes: 3, seconds: 45),
        heroTag: 'alazar-demo-cover',
        onPressed: () {
          unawaited(
            NotificationService.showNotification(
              'Alazar',
              'Reproductor activado.',
            ),
          );
        },
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;

  const _GlowOrb({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.14),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : Colors.white38,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 84,
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white54,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  const _RoundActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: color,
            size: size * 0.44,
          ),
        ),
      ),
    );
  }
}

class _EqualizerBars extends StatelessWidget {
  final Color color;
  final bool isActive;

  const _EqualizerBars({
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final heights = isActive ? const [8.0, 16.0, 11.0] : const [6.0, 6.0, 6.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _AnimatedEqualizerBar(height: heights[0], color: color, delay: 0),
        const SizedBox(width: 3),
        _AnimatedEqualizerBar(height: heights[1], color: color, delay: 1),
        const SizedBox(width: 3),
        _AnimatedEqualizerBar(height: heights[2], color: color, delay: 2),
      ],
    );
  }
}

class _AnimatedEqualizerBar extends StatelessWidget {
  final double height;
  final Color color;
  final int delay;

  const _AnimatedEqualizerBar({
    required this.height,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 180 + (delay * 60)),
      curve: Curves.easeInOut,
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}