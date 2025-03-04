import 'package:flutter/material.dart';
import '../classes/space.dart';
import '../screens/home.dart';
import '../services.dart';
import '../theme.dart';
import 'dart:ui';

class SpaceModal extends StatefulWidget {
  const SpaceModal({this.isNew = false, this.space, super.key});
  final bool isNew;
  final Space? space;

  @override
  State<SpaceModal> createState() => _SpaceModal();
}

class _SpaceModal extends State<SpaceModal> {
  final TextEditingController _controller = TextEditingController();
  Space _space = Space.fromTemplate();
  bool _isLoading = false;

  /* API CALLS */
  Future<bool> _addSpace() async {
    /*if (_controller.text == '') return false;
    setState(() => _isLoading = true);
    _space.calculTodayActivities();
    bool result = await addSpaceAPI(_space);
    setState(() => _isLoading = false);
    return result;*/
    return true;
  }

  Future<bool> _removeSpace(Space space) async {
    /*setState(() => _isLoading = true);
    bool result = await removeSpaceAPI(space);
    setState(() => _isLoading = false);
    return result;*/
    return true;
  }

  Future<bool> _updateSpace() async {
    /*if (_controller.text == '') return false;
    // If changing name => Remove the old and add the new
    if (widget.space != null && _controller.text != widget.space!.name) {
      return await _addSpace() && await _removeSpace(widget.space!);
    }

    setState(() => _isLoading = true);
    _space.calculTodayActivities();
    bool result = await updateSpacePlanningAPI(_space) &&
        await updateSpaceActivityAPI(_space);
    setState(() => _isLoading = false);
    return result;
    */
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.space != null) _space = Space.copy(widget.space!);
    _controller.text = _space.name;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.isNew ? 'Nouvel espace' : _space.name,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child:
                                  const Icon(Icons.close, color: Colors.black),
                            )
                          ]),
                      const SizedBox(height: 15),
                      TextField(
                          controller: _controller,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            errorText: _controller.text.isEmpty
                                ? 'Le nom est obligatoire'
                                : null,
                            isDense: true,
                            labelStyle: const TextStyle(fontSize: 12),
                            labelText: 'Nom *',
                          )),
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
                                onPressed: () {
                                  if (!_isLoading) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            TextButton(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : Text(
                                        widget.isNew ? 'Ajouter' : 'Valider'),
                                onPressed: () {
                                  if (!_isLoading) {
                                    Navigator.of(context)
                                        .pop(); // Simule l'ajout ou la validation
                                  }
                                })
                          ])
                    ])))));
  }
}
    
   /* AlertDialog(
      backgroundColor: Colors.transparent,
      titlePadding: const EdgeInsets.only(top: 15, left: 22, right: 15),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.isNew ? 'Nouvel espace' : _space.name,
            style: const TextStyle(fontSize: 20)),
        GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close))
      ]),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
              controller: _controller,
              onChanged: ((value) => setState(() => _space.name = value)),
              decoration: InputDecoration(
                errorText:
                    _controller.text == '' ? 'Le nom est obligatoire' : null,
                isDense: true,
                labelStyle: const TextStyle(fontSize: 10),
                labelText: 'Nom *',
              )),
          Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Container())
        ],
      )),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      
  }*/


