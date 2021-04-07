import 'package:flutter/material.dart';

import '../../../../core/platform/camera.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';

class SavePostDialog extends StatefulWidget {
  final BuildContext ctx;
  final CameraResponse cameraResponse;
  final AppTheme appTheme;
  final LocalizedString localizedString;
  final Function(String name) onSave;
  final Function onCancel;

  SavePostDialog({
    Key key,
    @required this.ctx,
    @required this.cameraResponse,
    @required this.appTheme,
    @required this.localizedString,
    @required this.onSave,
    @required this.onCancel,
  }) : super(key: key);

  @override
  _SavePostDialogState createState() => _SavePostDialogState();
}

class _SavePostDialogState extends State<SavePostDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _specie = 'Castanheira';

  final _species = <String>[
    'Castanheira',
    'Andiroba',
    'Cumaru',
    'Breu',
    'Copaiba',
  ];

  void _handleSelectChange(specie) => setState(() {
        _specie = specie;
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCancel,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.file(widget.cameraResponse.file),
                  ),
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: DropdownButtonFormField(
                      value: _specie,
                      onChanged: _handleSelectChange,
                      decoration: widget.appTheme.inputDecoration(
                        widget.localizedString
                            .getLocalizedString('map-screen.input-label'),
                        placeholder: widget.localizedString
                            .getLocalizedString('map-screen.input-placeholder'),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.localizedString.getLocalizedString(
                            'input-validations.required',
                          );
                        }

                        return null;
                      },
                      items: _species
                          .map<DropdownMenuItem>(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.onSave(_specie);
                        }
                      },
                      child: Text(
                        widget.localizedString.getLocalizedString(
                          'map-screen.save-button',
                        ),
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
