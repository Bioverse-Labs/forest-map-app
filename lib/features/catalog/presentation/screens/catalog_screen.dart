import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/widgets/screen.dart';
import '../../data/catalog.dart';
import '../notifiers/catalog_notifier.dart';

class CatalogScreen extends StatelessWidget {
  final CatalogNotifierImpl _catalogNotifier;
  final AppNavigator? _appNavigator;

  const CatalogScreen(this._catalogNotifier, this._appNavigator, {Key? key})
      : super(key: key);

  void _onItemTap(int index) {
    _catalogNotifier.setState(index);
    _appNavigator!.push('/catalog/images');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: _catalogNotifier.items.values.length,
        itemBuilder: (ctx, index) {
          final item = catalogList[index]!;

          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Flexible(
                    child: Text('${item.name} - ${item.scientificName}'),
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              onTap: () => _onItemTap(index),
            ),
          );
        },
      ),
    );
  }
}
