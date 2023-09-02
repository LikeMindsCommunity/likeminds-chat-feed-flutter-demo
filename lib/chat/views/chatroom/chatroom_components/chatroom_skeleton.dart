import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

class SkeletonChatPage extends StatelessWidget {
  const SkeletonChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalPaddingLarge,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const BB.BackButton(),
              // SizedBox(width: 4.w),
              SkeletonAnimation(
                child: Container(
                  width: 30.sp,
                  height: 30.sp,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: greyColor,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonAnimation(
                      child: Container(
                        width: 40.w,
                        height: 11.sp,
                        decoration: const BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    verticalPaddingSmall,
                    SkeletonAnimation(
                      child: Container(
                        width: 40.w,
                        height: 9.sp,
                        decoration: const BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              horizontalPaddingMedium,
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Container(
            color: greyColor.withOpacity(0.2),
            child: const SkeletonChatList(),
          ),
        ),
        // const Spacer(),
        Container(
          color: greyColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 12,
              // bottom: 4.h,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: SkeletonAnimation(
                      child: Container(
                        width: 40.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(1.h),
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalPaddingMedium,
                  SkeletonAnimation(
                    child: Container(
                      width: 32.sp,
                      height: 32.sp,
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SkeletonChatList extends StatelessWidget {
  const SkeletonChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.generate(
      5,
      (index) => SkeletonChatBubble(isSent: index % 2 == 0),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: list,
      ),
    );
  }
}

class SkeletonChatBubble extends StatelessWidget {
  final bool isSent;
  const SkeletonChatBubble({
    Key? key,
    required this.isSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.5.h,
      ),
      child: Column(
        crossAxisAlignment:
            isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isSent)
                const Spacer()
              else
                SkeletonAnimation(
                  child: Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.sp),
                      ),
                    ),
                  ),
                ),
              horizontalPaddingMedium,
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: BoxConstraints(
                  maxWidth: 32.w,
                  maxHeight: 4.8.h,
                  minHeight: 4.8.h,
                ),
                alignment: Alignment.center,
                child: SkeletonAnimation(
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              horizontalPaddingMedium,
              if (isSent)
                SkeletonAnimation(
                  child: Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.sp),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonAnimation extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;

  const SkeletonAnimation({
    Key? key,
    required this.child,
    this.duration,
    this.curve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade200,
      period: const Duration(seconds: 2),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}
