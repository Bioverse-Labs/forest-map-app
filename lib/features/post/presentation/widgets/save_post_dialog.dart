import 'package:flutter/material.dart';

import '../../../../core/platform/camera.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';

class SavePostDialog extends StatelessWidget {
  final BuildContext ctx;
  final CameraResponse cameraResponse;
  final AppTheme appTheme;
  final LocalizedString localizedString;
  final Function(String name) onSave;
  final Function onCancel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
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
                    child: Image.file(cameraResponse.file),
                  ),
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: appTheme.inputDecoration(
                        localizedString
                            .getLocalizedString('map-screen.input-label'),
                        placeholder: localizedString
                            .getLocalizedString('map-screen.input-placeholder'),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return localizedString.getLocalizedString(
                            'input-validations.required',
                          );
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          onSave(_nameController.text);
                        }
                      },
                      child: Text(
                        localizedString.getLocalizedString(
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
