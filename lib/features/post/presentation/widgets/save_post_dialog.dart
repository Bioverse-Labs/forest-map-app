import 'package:flutter/material.dart';

import '../../../../core/platform/camera.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../catalog/data/catalog.dart';
import '../../../catalog/domain/entities/catalog.dart';

class SavePostDialog extends StatefulWidget {
  final BuildContext ctx;
  final CameraResponse cameraResponse;
  final AppTheme appTheme;
  final LocalizedString localizedString;
  final Function(Catalog specie) onSave;
  final VoidCallback onExample;
  final Function onCancel;

  SavePostDialog({
    Key key,
    @required this.ctx,
    @required this.cameraResponse,
    @required this.appTheme,
    @required this.localizedString,
    @required this.onSave,
    @required this.onExample,
    @required this.onCancel,
  }) : super(key: key);

  @override
  _SavePostDialogState createState() => _SavePostDialogState();
}

class _SavePostDialogState extends State<SavePostDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _specie = 0;

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
                      isExpanded: true,
                      value: _specie,
                      onChanged: _handleSelectChange,
                      decoration: widget.appTheme.inputDecoration(
                        widget.localizedString
                            .getLocalizedString('map-screen.input-label'),
                        placeholder: widget.localizedString
                            .getLocalizedString('map-screen.input-placeholder'),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return widget.localizedString.getLocalizedString(
                            'input-validations.required',
                          );
                        }

                        return null;
                      },
                      items: catalogList.values
                          .map<DropdownMenuItem>(
                            (item) => DropdownMenuItem(
                              child: Text(
                                '${item.name} - ${item.scientificName}',
                              ),
                              value: item.id,
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
                          widget.onSave(catalogList[_specie]);
                        }
                      },
                      child: Text(
                        widget.localizedString.getLocalizedString(
                          'map-screen.save-button',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.onExample,
                      child: Text(
                        widget.localizedString
                            .getLocalizedString('map-screen.example-button'),
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
