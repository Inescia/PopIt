import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popit/components/bubble_style.dart';
import 'package:popit/l10n/app_localizations.dart';

class EmptySpaceView extends StatefulWidget {
  final MaterialColor accent;
  final VoidCallback onCreate;

  const EmptySpaceView({
    required this.accent,
    required this.onCreate,
    super.key,
  });

  @override
  State<EmptySpaceView> createState() => _EmptySpaceViewState();
}

class _EmptySpaceViewState extends State<EmptySpaceView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _pulse = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accent;
    final titleColor = accent.shade600;
    final bodyColor = accent.shade400;
    final buttonColor = accent.shade400;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 80, 28, 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 340),
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.22),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 120,
                    width: 160,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _float.value),
                          child: Transform.scale(
                            scale: _pulse.value,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 18,
                            top: 28,
                            child: BubbleStyle.circle(
                              color: accent,
                              size: 42,
                              opacity: 0.45,
                              shadowBlur: 10,
                              shadowOffset: const Offset(0, 3),
                            ),
                          ),
                          Positioned(
                            right: 22,
                            top: 18,
                            child: BubbleStyle.circle(
                              color: accent,
                              size: 28,
                              opacity: 0.32,
                              shadowBlur: 8,
                              shadowOffset: const Offset(0, 2),
                            ),
                          ),
                          BubbleStyle.circle(
                            color: accent,
                            size: 78,
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.empty_space_hint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.empty_space_body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: bodyColor,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: widget.onCreate,
                    style: FilledButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 22),
                    label: Text(
                      l10n.empty_space_cta,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
