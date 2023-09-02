import 'package:flutter_svg/flutter_svg.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/assets_constants.dart';

Future loadSvgIntoCache() async {
  for (String assetPath in svgAssets) {
    SvgAssetLoader loader = SvgAssetLoader(assetPath);
    svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}
