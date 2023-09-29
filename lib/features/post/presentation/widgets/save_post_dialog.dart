import 'package:flutter/material.dart';

import '../../../../core/platform/camera.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../catalog/data/catalog.dart';
import '../../../catalog/data/land_use.dart';

enum PostType {
  Specie,
  LandUse,
}

class SavePostDialog extends StatefulWidget {
  final BuildContext ctx;
  final CameraResponse cameraResponse;
  final AppTheme? appTheme;
  final LocalizedString? localizedString;
  final Function(dynamic value, {int? dbh}) onSave;
  final VoidCallback onExample;
  final Function onCancel;
  final PostType postType;

  SavePostDialog({
    Key? key,
    required this.ctx,
    required this.cameraResponse,
    required this.appTheme,
    required this.localizedString,
    required this.onSave,
    required this.onExample,
    required this.onCancel,
    required this.postType,
  }) : super(key: key);

  @override
  _SavePostDialogState createState() => _SavePostDialogState();
}

class _SavePostDialogState extends State<SavePostDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _specie = 0;
  int? _landUse;
  String? _otherLandUse;
  int? _dbh;

  bool get isOtherLandUse => _landUse == landUseList.length - 1;

  void _handleSelectChange(specie) => setState(() {
        _specie = specie;
      });

  void _handleSelectLandUseChange(value) => setState(() {
        _landUse = value;
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCancel as void Function()?,
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
                  SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: widget.postType == PostType.Specie
                        ? _specieFields()
                        : _landUseFields(),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            widget.postType == PostType.Specie
                                ? catalogList[_specie]
                                : isOtherLandUse
                                    ? _otherLandUse
                                    : landUseList[_landUse!],
                            dbh: _dbh,
                          );
                        }
                      },
                      child: Text(
                        widget.localizedString!.getLocalizedString(
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

  Widget _landUseFields() {
    return Column(
      children: [
        DropdownButtonFormField(
          isExpanded: true,
          value: _landUse,
          onChanged: _handleSelectLandUseChange,
          decoration: widget.appTheme!.inputDecoration(
            widget.localizedString!
                .getLocalizedString('map-screen.land-use.input-label'),
            placeholder: widget.localizedString!
                .getLocalizedString('map-screen.land-use.input-placeholder'),
          ),
          validator: (dynamic value) {
            if (value == null) {
              return widget.localizedString!.getLocalizedString(
                'input-validations.required',
              );
            }

            return null;
          },
          items: landUseList
              .map<DropdownMenuItem>(
                (item) => DropdownMenuItem(
                  child: Text(
                    item,
                  ),
                  value: landUseList.indexOf(item),
                ),
              )
              .toList(),
        ),
        isOtherLandUse
            ? TextFormField(
                decoration: widget.appTheme!.inputDecoration(
                  widget.localizedString!
                      .getLocalizedString('map-screen.land-use.other'),
                ),
                onChanged: (value) => _otherLandUse = value,
                validator: (dynamic value) {
                  if (value == null || value.isEmpty) {
                    return widget.localizedString!.getLocalizedString(
                      'input-validations.required',
                    );
                  }

                  return null;
                },
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _specieFields() {
    return Column(
      children: [
        DropdownButtonFormField(
          isExpanded: true,
          value: _specie,
          onChanged: _handleSelectChange,
          decoration: widget.appTheme!.inputDecoration(
            widget.localizedString!
                .getLocalizedString('map-screen.input-label'),
            placeholder: widget.localizedString!
                .getLocalizedString('map-screen.input-placeholder'),
          ),
          validator: (dynamic value) {
            if (value == null) {
              return widget.localizedString!.getLocalizedString(
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
        TextButton(
          onPressed: widget.onExample,
          child: Text(
            widget.localizedString!.getLocalizedString(
              'map-screen.example-button',
            ),
          ),
        ),
        TextFormField(
          decoration: widget.appTheme!.inputDecoration(
            widget.localizedString!.getLocalizedString('map-screen.dbh-label'),
            suffixText: widget.localizedString!
                .getLocalizedString('map-screen.dbh-suffix'),
            helperText: widget.localizedString!
                .getLocalizedString('map-screen.dbh-helper'),
          ),
          keyboardType: TextInputType.number,
          validator: (dynamic value) {
            if (value == null || value.isEmpty) {
              return widget.localizedString!.getLocalizedString(
                'input-validations.required',
              );
            } else {
              _dbh = int.tryParse(value);

              if (_dbh == null) {
                return widget.localizedString!.getLocalizedString(
                  'input-validations.invalid-int',
                );
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
