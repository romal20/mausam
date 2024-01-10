import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/common_widgets/fade_in_animation/fade_in_animation_controller.dart';

class FadeInAnimation extends StatelessWidget {
  FadeInAnimation({
    super.key,
    required this.durationInMs,
    this.animate,
    required this.child
  });

  final controller = Get.put(FadeInAnimationController());
  final int durationInMs;
  final tAnimatePosition? animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedPositioned(
        duration: Duration(milliseconds: durationInMs),
        top: controller.animate.value ? animate!.topAfter : animate!.topBefore,
        left: controller.animate.value ? animate!.leftAfter : animate!.leftBefore,
        bottom: controller.animate.value ? animate!.bottomAfter : animate!.bottomBefore,
        right: controller.animate.value ? animate!.rightAfter : animate!.rightBefore,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: durationInMs),
          opacity: controller.animate.value ? 1 : 0,
          child: child,
            //child: const Image(image: AssetImage(SplashTopIcon),width: 110,height: 110,)
        )
    ));
  }
}