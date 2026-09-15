import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/components/bubble_style.dart';
import 'package:popit/l10n/app_localizations.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:popit/theme.dart';
import 'package:provider/provider.dart';

class BubbleModal extends StatefulWidget {
  final bool isNew;
  final Bubble? bubble;
  final int? index;
  final int spaceIndex;

  const BubbleModal({
    required this.spaceIndex,
    this.isNew = false,
    this.bubble,
    this.index,
    super.key,
  });

  @override
  State<BubbleModal> createState() => _BubbleModal();
}

class _BubbleModal extends State<BubbleModal> {
  final TextEditingController _controller = TextEditingController();
  late final Bubble _bubble;

  SizedBox get _circularLoader => const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(strokeWidth: 2),
      );

  bool get _isEmpty => _controller.text.isEmpty;

  Future<void> _addBubble(BuildContext context) async {
    await Provider.of<AppProvider>(context, listen: false)
        .addBubble(widget.spaceIndex, _bubble);
  }

  Future<void> _removeBubble(BuildContext context) async {
    await Provider.of<AppProvider>(context, listen: false)
        .removeBubble(widget.spaceIndex, widget.index!);
  }

  Future<void> _updateBubble(BuildContext context) async {
    await Provider.of<AppProvider>(context, listen: false)
        .updateBubble(widget.spaceIndex, _bubble, widget.index!);
  }

  void _changeColorByIndex(int index) {
    final color = COLORS.entries.elementAt(index);
    _bubble.color = color.key;
    setState(() {});
  }

  Future<void> _submit(BuildContext context) async {
    if (_isEmpty) return;
    if (widget.isNew) {
      await _addBubble(context);
    } else {
      await _updateBubble(context);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _bubble =
        widget.isNew ? Bubble.fromTemplate() : Bubble.copy(widget.bubble!);
    _controller.text = _bubble.name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final maxHeight = MediaQuery.sizeOf(context).height -
        viewInsets.bottom -
        48; // keep room above keyboard

    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: maxHeight.clamp(220, double.infinity),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.isNew
                                    ? AppLocalizations.of(context)!.new_bubble
                                    : _bubble.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.close, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _BubblePreview(
                          color: _bubble.materialColor,
                          name: _controller.text,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          autofocus: true,
                          maxLength: 35,
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            _bubble.name = value;
                            setState(() {});
                          },
                          onEditingComplete: () => _submit(context),
                          decoration: InputDecoration(
                            errorText: _isEmpty
                                ? AppLocalizations.of(context)!
                                    .field_name_required
                                : null,
                            isDense: true,
                            labelStyle: const TextStyle(fontSize: 12),
                            labelText:
                                AppLocalizations.of(context)!.field_name,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            COLORS.length,
                            (index) {
                              final color = getColorByIndex(index);
                              final selected =
                                  _bubble.materialColor == color;
                              return GestureDetector(
                                onTap: () => _changeColorByIndex(index),
                                child: _ColorBubbleChip(
                                  color: color,
                                  selected: selected,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: widget.isNew
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            if (!widget.isNew)
                              TextButton(
                                onPressed: () => _removeBubble(context).then(
                                  (_) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                child: appProvider.isLoading('remove')
                                    ? _circularLoader
                                    : Text(AppLocalizations.of(context)!
                                        .button_remove),
                              ),
                            if (!widget.isNew)
                              TextButton(
                                onPressed: () => _submit(context),
                                child: appProvider.isLoading('update')
                                    ? _circularLoader
                                    : Text(AppLocalizations.of(context)!
                                        .button_update),
                              )
                            else
                              TextButton(
                                onPressed: () => _submit(context),
                                child: appProvider.isLoading('add')
                                    ? _circularLoader
                                    : Text(AppLocalizations.of(context)!
                                        .button_add),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Live preview matching [BubbleWidget] look.
class _BubblePreview extends StatelessWidget {
  final MaterialColor color;
  final String name;

  const _BubblePreview({
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleStyle.circle(
      color: color,
      size: 96,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          name.isEmpty ? '…' : name,
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ColorBubbleChip extends StatelessWidget {
  final MaterialColor color;
  final bool selected;

  const _ColorBubbleChip({
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleStyle.circle(
      color: color,
      size: 36,
      shadowBlur: selected ? 10 : 6,
      shadowOffset: const Offset(0, 3),
      border: Border.all(
        color: Colors.white,
        width: selected ? 2.5 : 0,
      ),
    );
  }
}
