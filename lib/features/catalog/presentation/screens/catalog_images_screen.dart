import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/screen.dart';
import '../notifiers/catalog_notifier.dart';

class CatalogImagesScreen extends StatelessWidget {
  const CatalogImagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ScreenWidget(
      backgrounColor: Colors.black,
      appBar: AppBar(),
      body: Consumer<CatalogNotifierImpl>(
        builder: (ctx, state, _) {
          final items = state.items[state.currentIndex].images;
          return Swiper(
            itemCount: items.length,
            pagination: SwiperPagination(),
            control: SwiperControl(
              color: Colors.white,
            ),
            loop: false,
            itemBuilder: (ctx, index) {
              return Image.asset(
                items[index],
                width: screenWidth,
                fit: BoxFit.fitWidth,
              );
            },
          );
        },
      ),
    );
  }
}
