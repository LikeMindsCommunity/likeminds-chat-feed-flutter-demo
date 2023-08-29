import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/profile/bloc/profile_bloc.dart';
import 'package:likeminds_flutter_sample/chat/widgets/big_button.dart';
import 'package:likeminds_flutter_sample/chat/widgets/bloc_error.dart';
import 'package:likeminds_flutter_sample/chat/widgets/page_skeleton.dart';
import 'package:likeminds_flutter_sample/chat/widgets/back_button.dart' as bb;
import 'package:likeminds_flutter_sample/chat/widgets/spinner.dart';

class ProfilePage extends StatefulWidget {
  final bool isSelf;

  const ProfilePage({
    super.key,
    this.isSelf = true,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PageSkeleton(
      isListView: true,
      backgroundColor: LMBranding.instance.headerColor,
      appBarChildren: [
        const bb.BackButton(),
        Text(
          '',
          style: LMBranding.instance.fonts.regular.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 32,
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
      bodyChildren: [
        BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Spinner(color: kWhiteColor);
            }

            if (state is ProfileLoaded) {
              return Container(
                color: Colors.grey[300]!.withOpacity(0.9),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                                height: 160,
                                width: 100.w,
                                color: LMBranding.instance.headerColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        // color: Colors.green,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://picsum.photos/200/300",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "SG1234",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Member of ManMatters community since Jan 29 2020",
                                              softWrap: true,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              height: 150,
                              width: 100.w,
                              color: kWhiteColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bio",
                                      style: LMBranding.instance.fonts.medium
                                          .copyWith(
                                        fontSize: 14,
                                        color: LMBranding.instance.headerColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam tincidunt, nunc nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl. Sed euismod, nunc ut aliquam tincidunt, nunc nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.",
                                      softWrap: true,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 18,
                          bottom: 124,
                          child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.send,
                              color: LMBranding.instance.headerColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 100.w,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Other Details",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: LMBranding.instance.headerColor,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text("Interests",
                                style:
                                    LMBranding.instance.fonts.medium.copyWith(
                                  color: kGreyColor,
                                )),
                            const SizedBox(height: 6),
                            Text(
                              "Lorem ipsum, dolor sit amet, consectetur adipiscing",
                              softWrap: true,
                              style: LMBranding.instance.fonts.regular,
                            ),
                            const SizedBox(height: 12),
                            const Divider(thickness: 1),
                            const SizedBox(height: 12),
                            Text(
                              "Location",
                              style: LMBranding.instance.fonts.medium.copyWith(
                                color: kGreyColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Gurgaon, India",
                              softWrap: true,
                              style: LMBranding.instance.fonts.regular,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 100.w,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Spaces Joined",
                                  style:
                                      LMBranding.instance.fonts.medium.copyWith(
                                    color: LMBranding.instance.headerColor,
                                  ),
                                ),
                                Text(
                                  "24",
                                  style:
                                      LMBranding.instance.fonts.medium.copyWith(
                                    color: LMBranding.instance.headerColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            // const ChatItem(
                            //   name: "ManMatters design",
                            //   message:
                            //       "Lorem ipsum dolor sit amet, consectetur",
                            //   time: "12:00",
                            //   avatarUrl: "https://picsum.photos/200/300",
                            // ),
                            // const Divider(thickness: 1),
                            // const ChatItem(
                            //   name: "ManMatters engineering",
                            //   message:
                            //       "Lorem ipsum dolor sit amet, consectetur",
                            //   time: "12:00",
                            //   avatarUrl: "https://picsum.photos/200/300",
                            // ),
                            // const Divider(thickness: 1),
                            // const ChatItem(
                            //   name: "ManMatters HR",
                            //   message:
                            //       "Lorem ipsum dolor sit amet, consectetur",
                            //   time: "12:00",
                            //   avatarUrl: "https://picsum.photos/200/300",
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.isSelf)
                      BigButton(
                        text: "Edit Profile",
                        width: 60.w,
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            return const BlocError();
          },
        ),
      ],
    );
  }
}
