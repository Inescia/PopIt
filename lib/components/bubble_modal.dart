import 'package:flutter/material.dart';
import 'package:popit/classes/bubble.dart';
import 'package:popit/providers/space_provider.dart';
import 'package:provider/provider.dart';
import '../classes/space.dart';
import '../theme.dart';
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
  Bubble _bubble = Bubble.fromTemplate();
  bool _isLoading = false;

  /* API CALLS */
  Future<void> _addBubble(BuildContext context) async {
    if (_controller.text == '') return;
    setState(() => _isLoading = true);
    await Provider.of<SpaceProvider>(context, listen: false)
        .addBubble(widget.spaceIndex, _bubble);
    setState(() => _isLoading = false);
  }

  Future<void> _removeBubble(BuildContext context) async {
    setState(() => _isLoading = true);
    await Provider.of<SpaceProvider>(context, listen: false)
        .removeBubble(widget.spaceIndex, widget.index!);
    setState(() => _isLoading = false);
  }

  Future<void> _updateBubble(BuildContext context) async {
    if (_controller.text == '') return;
    setState(() => _isLoading = true);
    await Provider.of<SpaceProvider>(context, listen: false)
        .updateBubble(widget.spaceIndex, _bubble, widget.index!);
    setState(() => _isLoading = false);
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
    if (widget.bubble != null) _bubble = Bubble.copy(widget.bubble!);
    _controller.text = _bubble.name;
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
                                  widget.isNew
                                      ? 'Nouvelle bulle'
                                      : _bubble.name,
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
                              controller: _controller,
                              onChanged: (value) =>
                                  setState(() => _bubble.name = value),
                              decoration: InputDecoration(
                                errorText: _controller.text.isEmpty
                                    ? 'Le nom est obligatoire'
                                    : null,
                                isDense: true,
                                labelStyle: const TextStyle(fontSize: 12),
                                labelText: 'Nom *',
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
                                                  width: _bubble
                                                              .materialColor ==
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
                                                  width:
                                                      _bubble.materialColor ==
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
                                          : const Text('Supprimer'),
                                      onPressed: () => _removeBubble(context)
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
                                            ? 'Ajouter'
                                            : 'Valider'),
                                    onPressed: () => (widget.isNew
                                            ? _addBubble(context)
                                            : _updateBubble(context))
                                        .then((value) =>
                                            Navigator.of(context).pop()))
                              ])
                        ]))))));
  }
}
