import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../../core/widgets/screen.dart';
import '../../../organization/presentation/notifiers/organizations_notifier.dart';

class StaticMapScreen extends StatelessWidget {
  final OrganizationNotifierImpl organizationNotifier;

  const StaticMapScreen({
    Key key,
    @required this.organizationNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(),
      backgrounColor: Colors.grey.shade400,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SfMaps(
            title: MapTitle(
              "Datasource: 16JUN19140331-M3DS_R01C3-012954101010_01_P001",
              padding: const EdgeInsets.all(32),
              textStyle: Theme.of(context).textTheme.headline6,
            ),
            layers: [
              MapShapeLayer(
                color: Colors.blue.withOpacity(0.4),
                strokeColor: Colors.blue,
                strokeWidth: 1,
                zoomPanBehavior: MapZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                  showToolbar: true,
                ),
                loadingBuilder: (ctx) {
                  return Center(child: CircularProgressIndicator());
                },
                source: MapShapeSource.asset(
                  "assets/test.geojson",
                  shapeDataField:
                      "16JUN19140331-M3DS_R01C3-012954101010_01_P001",
                  dataCount: organizationNotifier
                      .organization.geolocationData.first.dataProperties.length,
                  primaryValueMapper: (index) => organizationNotifier
                      .organization
                      .geolocationData
                      .first
                      .dataProperties[index]
                      .id,
                ),
                tooltipSettings: const MapTooltipSettings(
                  color: Colors.blue,
                  strokeColor: Color.fromRGBO(252, 187, 15, 1),
                  strokeWidth: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
