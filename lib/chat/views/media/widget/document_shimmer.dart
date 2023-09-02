import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

Widget getDocumentTileShimmer() {
  return Container(
    height: 78,
    width: 60.w,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        border: Border.all(color: greyWebBGColor, width: 1),
        borderRadius: BorderRadius.circular(borderRadiusMedium)),
    padding: const EdgeInsets.all(paddingLarge),
    child: Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
          height: 10.w,
          width: 10.w,
          color: whiteColor,
        ),
        horizontalPaddingLarge,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: 30.w,
              color: whiteColor,
            ),
            verticalPaddingMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 6,
                  width: 10.w,
                  color: whiteColor,
                ),
                horizontalPaddingXSmall,
                const Text(
                  '·',
                  style: TextStyle(fontSize: fontSmall, color: grey3Color),
                ),
                horizontalPaddingXSmall,
                Container(
                  height: 6,
                  width: 10.w,
                  color: whiteColor,
                ),
              ],
            )
          ],
        )
      ]),
    ),
  );
}
