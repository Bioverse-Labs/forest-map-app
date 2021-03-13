import 'package:dartz/dartz.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_it/get_it.dart';

import '../../features/organization/domain/entities/organization.dart';
import '../enums/exception_origin_types.dart';
import '../errors/failure.dart';
import 'localized_string.dart';

Future<Either<LocalFailure, Uri>> generateInviteLink(
  Organization organization,
) async {
  try {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://forestmap.page.link/',
      link: Uri.parse(
        'https://forestmap.page.link/add-member?orgId=${organization.id}',
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.bioverselabs.forestmap',
        minimumVersion: 000001,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.bioverselabs.forestmap',
        minimumVersion: '1.0.1',
        appStoreId: '',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: GetIt.I<LocalizedString>().getLocalizedString(
          'invitation-link.title',
        ),
        description: GetIt.I<LocalizedString>().getLocalizedString(
          'invitation-link.description',
          namedArgs: {'name': organization.name},
        ),
        imageUrl: Uri.parse(
          'https://raw.githubusercontent.com/Bioverse-Labs/forest-map-app/master/bioverse.png',
        ),
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    final dynamicUrl = await parameters.buildShortLink();

    return Right(dynamicUrl.shortUrl);
  } catch (error) {
    return Left(LocalFailure(
      GetIt.I<LocalizedString>().getLocalizedString('generic-exception'),
      'link-error',
      ExceptionOriginTypes.platform,
      stackTrace: StackTrace.fromString(error.toString()),
    ));
  }
}
