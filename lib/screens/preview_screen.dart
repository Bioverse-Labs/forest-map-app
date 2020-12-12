import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forestMapApp/common/input_decoration.dart';
import 'package:forestMapApp/notifiers/data_notifier.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('preview-screen.title').tr()),
      body: ListView(
        children: [
          Consumer<DataNotifier>(
            builder: (ctx, data, child) => Image.file(
              data.imgFile,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 32.0,
            ),
            child: Form(
              child: ListBody(
                children: [
                  TextFormField(
                    decoration: inputDecoration('labels.name'.tr()),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      child: Text('preview-screen.submit-button'.tr()),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
