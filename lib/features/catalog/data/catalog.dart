import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/entities/catalog.dart';

final catalogList = {
  0: Catalog(
    id: 0,
    name: 'Castanheira',
    scientificName: 'Bertholletia excelsa',
    images: [
      'assets/example_images/castanheira_1.png',
      'assets/example_images/castanheira_2.png',
      'assets/example_images/castanheira_3.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  ),
  1: Catalog(
    id: 1,
    name: 'Andiroba',
    scientificName: 'Carapa guianensis',
    images: [
      'assets/example_images/andiroba_1.png',
      'assets/example_images/andiroba_2.png',
      'assets/example_images/andiroba_3.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
  2: Catalog(
    id: 2,
    name: 'Ucuuba',
    scientificName: 'Virola surinamensis',
    images: [
      'assets/example_images/Ucuuba_1.png',
      'assets/example_images/Ucuuba_2.png',
      'assets/example_images/Ucuuba_3.png',
      'assets/example_images/Ucuuba_4.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
  ),
  3: Catalog(
    id: 3,
    name: 'Murumuru',
    scientificName: 'Astrocaryum murumuru',
    images: [
      'assets/example_images/Murumuru_1.png',
      'assets/example_images/Murumuru_2.png',
      'assets/example_images/Murumuru_3.png',
      'assets/example_images/Murumuru_4.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  ),
  4: Catalog(
    id: 4,
    name: 'Tucumã',
    scientificName: 'Astrocaryum aculeatum',
    images: [
      'assets/example_images/Tucuma_1.png',
      'assets/example_images/Tucuma_2.png',
      'assets/example_images/Tucuma_3.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  ),
  5: Catalog(
    id: 5,
    name: 'Pataua',
    scientificName: 'Oenocarpus bataua',
    images: [
      'assets/example_images/Pataua_1.png',
      'assets/example_images/Pataua_2.png',
      'assets/example_images/Pataua_3.png',
      'assets/example_images/Pataua_4.png',
      'assets/example_images/Pataua_5.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
  6: Catalog(
    id: 6,
    name: 'Mucauba / Macaja',
    scientificName: 'Acrocomia aculeata',
    images: [
      'assets/example_images/Mucauba_1.png',
      'assets/example_images/Mucauba_2.png',
      'assets/example_images/Mucauba_3.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  7: Catalog(
    id: 7,
    name: 'Açai',
    scientificName: 'Euterpe Oleracea',
    images: [
      'assets/example_images/Acai_1.png',
      'assets/example_images/Acai_2.png',
      'assets/example_images/Acai_3.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  ),
  8: Catalog(
    id: 8,
    name: 'Mumaru',
    scientificName: 'Dipteryx odorata',
    images: [
      'assets/example_images/Mumaru_1.png',
      'assets/example_images/Mumaru_2.png',
      'assets/example_images/Mumaru_3.png',
      'assets/example_images/Mumaru_4.png',
    ],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
  ),
};
