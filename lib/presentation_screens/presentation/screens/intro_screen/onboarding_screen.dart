// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
 
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../_authenticator/presentation/auth_screens/register_screen.dart';
import '../../../../core/widgets/custom_button/custom_button.dart';
import '../../../../core/widgets/custom_do_animtion/custom_fade_animation.dart';
import '../../../../core/widgets/custom_text/text.dart';
import '../../../domain/entitie/entite_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();

  int turn = 0;

  bool transferWidget = false;

  void iconButton() {
    if (turn == 0) {
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          setState(() {
            transferWidget = !transferWidget;
          });
        },
      );
    }
    controller.nextPage(
        duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
  }

  void navigataButton() {
    Navigator.push(
      context,
      PageTransition(
          child: fadeDownTOUp(child: const RegisterScreen()),
          duration: const Duration(milliseconds: 1500),
          type: PageTransitionType.bottomToTop),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    List<OnBoardingModel> modelOnBoarding = [
      OnBoardingModel(
        title: AppLocalizations.of(context)!.onBoardingTitle1,
        image: "assets/animation_image/on_boarding/onBoarding1.json",
        subTitle: AppLocalizations.of(context)!.onBoarding1,
      ),
      OnBoardingModel(
          title: AppLocalizations.of(context)!.onBoardingTitle3,
          image1: "assets/images/cloudy.png",
          subTitle: AppLocalizations.of(context)!.onBoarding3),
    ];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: media.width * .05, vertical: media.width * .1),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: media.width * .02),
              padding: EdgeInsets.symmetric(
                  horizontal: media.width * .03, vertical: media.height * .009),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.grey.shade200,
              ),
              child: SmoothPageIndicator(
                controller: controller,
                count: modelOnBoarding.length,
                effect: const ScrollingDotsEffect(
                    spacing: 8.0,
                    dotWidth: 20.0,
                    dotColor: Colors.black54,
                    activeDotColor: Colors.yellow),
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modelOnBoarding.length,
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    turn = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: media.height * .5,
                          child: modelOnBoarding[index].image1 == null
                              ? Lottie.asset(
                                  modelOnBoarding[index].image.toString(),
                                )
                              : Image.asset(
                                  modelOnBoarding[index].image1.toString(),
                                  width: media.width * .4,
                                )),
                      Container(
                        padding: EdgeInsets.all(media.width * .02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.4),
                            Colors.black.withOpacity(.2),
                            Colors.transparent
                          ]),
                        ),
                        child: CustomText(
                          text: modelOnBoarding[index].title,
                          fontSize: media.width * .05,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        height: media.height * .03,
                      ),
                      CustomText(
                          text: modelOnBoarding[index].subTitle,
                          fontSize: media.width * .04),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          transferWidget == false
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                      onPressed: () => iconButton(),
                                      icon: const Icon(
                                        Icons.navigate_next_sharp,
                                      )),
                                )
                              : fadeElasticIn(
                                  child: CustomButton(
                                    onPressed: () => navigataButton(),
                                    text: "Start",
                                    elevation: 50.0,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
