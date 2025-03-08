import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:popit/classes/space.dart';
import 'package:popit/theme.dart';
import 'dart:ui';

class SpaceModal extends StatefulWidget {
  final bool isNew;
  final Space? space;
  final int? index;

  const SpaceModal({this.isNew = false, this.space, this.index, super.key});

  @override
  State<SpaceModal> createState() => _SpaceModal();
}

class _SpaceModal extends State<SpaceModal> {
  final TextEditingController _controller = TextEditingController();
  Space _space = Space.fromTemplate();
  bool _isLoading = false;

  /* API CALLS */
  Future<void> _addSpace(BuildContext context) async {
    if (_controller.text == '') return;
    setState(() => _isLoading = true);
    await Provider.of<AppProvider>(context, listen: false).addSpace(_space);
    setState(() => _isLoading = false);
  }

  Future<void> _removeSpace(BuildContext context) async {
    setState(() => _isLoading = true);
    await Provider.of<AppProvider>(context, listen: false)
        .removeSpace(widget.index!);
    setState(() => _isLoading = false);
  }

  Future<void> _updateSpace(BuildContext context) async {
    if (_controller.text == '') return;
    setState(() => _isLoading = true);
    await Provider.of<AppProvider>(context, listen: false)
        .updateSpace(_space, widget.index!);
    setState(() => _isLoading = false);
  }

  /* METHODS */
  void _changeColorByIndex(int index) {
    var color = COLORS.entries.elementAt(index);
    _space.color = color.key;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.space != null) _space = Space.copy(widget.space!);
    _controller.text = _space.name;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(150),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.isNew
                                      ? AppLocalizations.of(context)!.new_space
                                      : _space.name,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Icon(Icons.close,
                                      color: Colors.black),
                                )
                              ]),
                          const SizedBox(height: 15),
                          TextField(
                              maxLength: 35,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _controller,
                              onChanged: (value) =>
                                  setState(() => _space.name = value),
                              decoration: InputDecoration(
                                errorText: _controller.text.isEmpty
                                    ? AppLocalizations.of(context)!
                                        .field_name_required
                                    : null,
                                isDense: true,
                                labelStyle: const TextStyle(fontSize: 12),
                                labelText:
                                    AppLocalizations.of(context)!.field_name,
                              )),
                          const SizedBox(height: 20),
                          Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                  5,
                                  (index) => GestureDetector(
                                      onTap: () => _changeColorByIndex(index),
                                      child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 6)
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: _space.materialColor ==
                                                          getColorByIndex(index)
                                                      ? 2
                                                      : 0),
                                              color: getColorByIndex(index)
                                                  .shade200)))),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                  5,
                                  (index) => GestureDetector(
                                      onTap: () =>
                                          _changeColorByIndex(index + 5),
                                      child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 6)
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: _space.materialColor ==
                                                          getColorByIndex(
                                                              index + 5)
                                                      ? 2
                                                      : 0),
                                              color: getColorByIndex(index + 5)
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
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2))
                                          : Text(AppLocalizations.of(context)!
                                              .button_remove),
                                      onPressed: () => _removeSpace(context)
                                          .then((value) =>
                                              Navigator.of(context).pop())),
                                TextButton(
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2))
                                        : Text(widget.isNew
                                            ? AppLocalizations.of(context)!
                                                .button_add
                                            : AppLocalizations.of(context)!
                                                .button_update),
                                    onPressed: () => _controller.text.isEmpty
                                        ? null
                                        : (widget.isNew
                                                ? _addSpace(context)
                                                : _updateSpace(context))
                                            .then((value) =>
                                                Navigator.of(context).pop()))
                              ])
                        ]))))));
  }
}
