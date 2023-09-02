import 'package:cached_network_image/cached_network_image.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/lm_fonts.dart';

import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/utils/ui_utils.dart';
import 'package:likeminds_flutter_sample/chat/views/media/media_utils.dart';

class PictureOrInitial extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double? size;
  final double? fontSize;
  final Color? backgroundColor;

  const PictureOrInitial({
    super.key,
    this.imageUrl,
    required this.fallbackText,
    this.size,
    this.fontSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 42.sp,
      width: size ?? 42.sp,
      decoration: BoxDecoration(
        color: LMTheme.headerColor == LMTheme.buttonColor
            ? backgroundColor ?? LMTheme.buttonColor
            : backgroundColor ?? LMTheme.headerColor,
        shape: BoxShape.circle,
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                height: size ?? 42.sp,
                width: size ?? 42.sp,
                decoration: BoxDecoration(
                  color: LMBranding.instance.headerColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, progress) =>
                  mediaShimmer(
                isPP: true,
              ),
              errorWidget: (context, url, error) => mediaErrorWidget(
                isPP: true,
              ),
            )
          : Center(
              child: Text(
                getInitials(fallbackText),
                style: LMFonts.instance.bold.copyWith(
                  fontSize: fontSize ?? 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
