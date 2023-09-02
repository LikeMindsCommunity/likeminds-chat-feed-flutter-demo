import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

class BackButton extends StatelessWidget {
  final Function? onTap;
  const BackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap == null) {
          router.pop();
        } else {
          onTap!();
          router.pop();
        }
      },
      child: Container(
        height: 24.sp,
        width: 24.sp,
        decoration: BoxDecoration(
          color: LMBranding.instance.buttonColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.arrow_back,
          size: 18.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
