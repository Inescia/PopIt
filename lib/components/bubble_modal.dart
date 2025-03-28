import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/theme.dart';
import 'dart:ui';

class BubbleModal extends StatefulWidget {
  final bool isNew;
  final Bubble? bubble;
  final int? index;
  final int spaceIndex;

  const BubbleModal(
      {required this.spaceIndex,
      this.isNew = false,
      this.bubble,
      this.index,
      super.key});

  @override
  State<BubbleModal> createState() => _BubbleModal();
}

class _BubbleModal extends State<BubbleModal> {
  final TextEditingController _controller = TextEditingController();
  late final Bubble _bubble;

  SizedBox get _circularLoader => const SizedBox(
      width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2));

  bool get _isEmpty => _controller.text.isEmpty;

  /* API CALLS */
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

  /* METHODS */
  void _changeColorByIndex(int index) {
    var color = COLORS.entries.elementAt(index);
    _bubble.color = color.key;
    setState(() {});
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(100),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            widget.isNew
                                                ? AppLocalizations.of(context)!
                                                    .new_bubble
                                                : _bubble.name,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                            maxLines: 1,
                                          )),
                                          GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: const Icon(Icons.close,
                                                color: Colors.black),
                                          )
                                        ]),
                                    const SizedBox(height: 15),
                                    TextField(
                                        autofocus: true,
                                        maxLength: 35,
                                        controller: _controller,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        onChanged: (value) =>
                                            _bubble.name = value,
                                        onEditingComplete: () => _isEmpty
                                            ? null
                                            : (widget.isNew
                                                    ? _addBubble(context)
                                                    : _updateBubble(context))
                                                .then((value) =>
                                                    Navigator.of(context)
                                                        .pop()),
                                        decoration: InputDecoration(
                                          errorText: _isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .field_name_required
                                              : null,
                                          isDense: true,
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .field_name,
                                        )),
                                    const SizedBox(height: 20),
                                    Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List.generate(
                                            5,
                                            (index) => GestureDetector(
                                                onTap: () =>
                                                    _changeColorByIndex(index),
                                                child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 6)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: _bubble
                                                                        .materialColor ==
                                                                    getColorByIndex(
                                                                        index)
                                                                ? 2
                                                                : 0),
                                                        color:
                                                            getColorByIndex(index)
                                                                .shade200)))),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List.generate(
                                            5,
                                            (index) => GestureDetector(
                                                onTap: () =>
                                                    _changeColorByIndex(
                                                        index + 5),
                                                child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(0, 2),
                                                              blurRadius: 6)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width:
                                                                _bubble.materialColor == getColorByIndex(index + 5)
                                                                    ? 2
                                                                    : 0),
                                                        color: getColorByIndex(
                                                                index + 5)
                                                            .shade200)))),
                                      )
                                    ]),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment: widget.isNew
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (!widget.isNew)
                                            TextButton(
                                                child: appProvider
                                                        .isLoading('remove')
                                                    ? _circularLoader
                                                    : Text(AppLocalizations.of(
                                                            context)!
                                                        .button_remove),
                                                onPressed: () => _removeBubble(
                                                        context)
                                                    .then((value) =>
                                                        Navigator.of(context)
                                                            .pop())),
                                          if (!widget.isNew)
                                            TextButton(
                                                child: appProvider.isLoading('update')
                                                    ? _circularLoader
                                                    : Text(AppLocalizations.of(context)!
                                                        .button_update),
                                                onPressed: () => _isEmpty
                                                    ? null
                                                    : _updateBubble(context).then(
                                                        (value) => Navigator.of(context)
                                                            .pop()))
                                          else
                                            TextButton(
                                                child: appProvider.isLoading('add')
                                                    ? _circularLoader
                                                    : Text(AppLocalizations.of(context)!
                                                        .button_add),
                                                onPressed: () => _isEmpty
                                                    ? null
                                                    : _addBubble(context).then((value) => Navigator.of(context).pop()))
                                        ])
                                  ])))))));
    });
  }
}
