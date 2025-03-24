import 'package:feature_flags/feature_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/force_widget.dart';
import 'package:v34/features_flag.dart';
import 'package:v34/models/force.dart';

class ForceTeams extends StatelessWidget {
  static const double OUTER_PADDING = 12;
  static const double INNER_PADDING = 0;
  static const double ICON_SIZE = 16;

  final String hostCode;
  final String visitorCode;
  final Forces? forces;
  final String receiveText;
  final Color backgroundColor;
  final bool showDivider;

  const ForceTeams({
    Key? key,
    required this.forces,
    required this.backgroundColor,
    this.receiveText = "reçoit",
    required this.hostCode,
    required this.visitorCode,
    required this.showDivider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        forces != null
            ? SvgPicture.asset("assets/attack.svg",
                width: ICON_SIZE + 4, colorFilter: ColorFilter.mode(Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn))
            : SizedBox(),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: OUTER_PADDING, bottom: INNER_PADDING),
                  child: Row(
                    children: [
                      Expanded(
                          child: forces != null
                              ? ForceGraph(
                                  value: forces!.getAttackPercentage(hostCode),
                                  forceOrientation: ForceOrientation.rightToLeft,
                                  textPosition: ForceTextPosition.above,
                                  showValue: Features.isFeatureEnabled(context, display_force_percentage),
                                )
                              : SizedBox()),
                      Container(width: 40, height: forces != null ? 20 : 0),
                      Expanded(
                        child: forces != null
                            ? ForceGraph(
                                value: forces!.getDefensePercentage(hostCode),
                                forceOrientation: ForceOrientation.leftToRight,
                                textPosition: ForceTextPosition.above,
                                showValue: Features.isFeatureEnabled(context, display_force_percentage),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Stack(
                      children: [
                        showDivider ? Divider(thickness: 0.2, indent: 30, endIndent: 30) : SizedBox(),
                        Center(
                          child: Container(
                            color: backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(receiveText, style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: INNER_PADDING, bottom: OUTER_PADDING),
                  child: Row(
                    children: [
                      Expanded(
                        child: forces != null
                            ? ForceGraph(
                                value: forces!.getAttackPercentage(visitorCode),
                                forceOrientation: ForceOrientation.rightToLeft,
                                textPosition: ForceTextPosition.below,
                                showValue: Features.isFeatureEnabled(context, display_force_percentage),
                              )
                            : SizedBox(),
                      ),
                      Container(width: 40, height: forces != null ? 20 : 0),
                      Expanded(
                        child: forces != null
                            ? ForceGraph(
                                value: forces!.getDefensePercentage(visitorCode),
                                forceOrientation: ForceOrientation.leftToRight,
                                textPosition: ForceTextPosition.below,
                                showValue: Features.isFeatureEnabled(context, display_force_percentage),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        forces != null
            ? SvgPicture.asset("assets/defense.svg",
                width: ICON_SIZE, colorFilter: ColorFilter.mode(Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn))
            : SizedBox(),
      ],
    );
  }
}
