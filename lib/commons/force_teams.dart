import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/force_widget.dart';
import 'package:v34/models/force.dart';

class ForceTeams extends StatelessWidget {
  static const double OUTER_PADDING = 22;
  static const double INNER_PADDING = 3;
  static const double ICON_SIZE = 20;

  final Force? hostForce;
  final Force? visitorForce;
  final Force? globalForce;

  const ForceTeams({
    Key? key,
    required this.hostForce,
    required this.visitorForce,
    required this.globalForce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/attack.svg",
            width: ICON_SIZE + 4, color: Theme.of(context).textTheme.bodyText1!.color),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: OUTER_PADDING, bottom: INNER_PADDING),
                  child: Row(
                    children: [
                      Expanded(
                        child: hostForce != null && globalForce != null
                            ? ForceGraph(
                                value: hostForce!.totalAttackPerSet / globalForce!.totalAttackPerSet,
                                forceOrientation: ForceOrientation.rightToLeft,
                                textPosition: ForceTextPosition.above,
                              )
                            : SizedBox(),
                      ),
                      Container(width: 40, height: 20),
                      Expanded(
                        child: hostForce != null && globalForce != null
                            ? ForceGraph(
                                value: (25 - hostForce!.totalDefensePerSet) / (25 - globalForce!.totalDefensePerSet),
                                forceOrientation: ForceOrientation.leftToRight,
                                textPosition: ForceTextPosition.above,
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
                        Divider(thickness: 0.5, indent: 30, endIndent: 30),
                        Center(
                          child: Container(
                            color: Theme.of(context).cardTheme.color,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
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
                        child: visitorForce != null && globalForce != null
                            ? ForceGraph(
                                value: visitorForce!.totalAttackPerSet / globalForce!.totalAttackPerSet,
                                forceOrientation: ForceOrientation.rightToLeft,
                                textPosition: ForceTextPosition.below,
                              )
                            : SizedBox(),
                      ),
                      Container(width: 40, height: 20),
                      Expanded(
                        child: visitorForce != null && globalForce != null
                            ? ForceGraph(
                                value: (25 - visitorForce!.totalDefensePerSet) / (25 - globalForce!.totalDefensePerSet),
                                forceOrientation: ForceOrientation.leftToRight,
                                textPosition: ForceTextPosition.below,
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
        SvgPicture.asset("assets/defense.svg", width: ICON_SIZE, color: Theme.of(context).textTheme.bodyText1!.color),
      ],
    );
  }
}
