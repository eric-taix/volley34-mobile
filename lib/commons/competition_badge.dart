import 'package:flutter/material.dart';

class CompetitionBadge extends StatelessWidget {
  final double deltaSize;
  final String? competitionCode;
  final TextStyle? labelStyle;
  final bool showSubTitle;
  final bool blackAndWhite;

  const CompetitionBadge(
      {Key? key,
      this.deltaSize = 1,
      required this.competitionCode,
      this.labelStyle,
      this.showSubTitle = true,
      this.blackAndWhite = false})
      : super(key: key);

  _CompetitionBadgePainter _drawCompetitionBadge(BuildContext context) {
    String gameType = competitionCode?.substring(competitionCode!.length - 1) ?? "-1";
    TextStyle? subTitleStyle = Theme.of(context).textTheme.bodyText1;
    switch (int.parse(gameType)) {
      case 1:
        return _CompetitionBadgePainter(
            context: context,
            label: "4",
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            labelStyle: blackAndWhite ? Theme.of(context).textTheme.bodyText2 : labelStyle,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      case 2:
        return _CompetitionBadgePainter(
            context: context,
            label: "6",
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            labelStyle: blackAndWhite ? Theme.of(context).textTheme.bodyText2 : labelStyle,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      case 3:
      case 4:
        return _CompetitionBadgePainter(
            context: context,
            label: "4",
            labelStyle: labelStyle,
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      case 5:
        return _CompetitionBadgePainter(
            context: context,
            label: "6",
            labelStyle: labelStyle,
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      case 6:
        return _CompetitionBadgePainter(
            context: context,
            label: "4",
            labelStyle: labelStyle,
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      case 7:
        return _CompetitionBadgePainter(
            context: context,
            label: "6",
            labelStyle: labelStyle,
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText2!.color! : Colors.pinkAccent,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
      default:
        return _CompetitionBadgePainter(
            context: context,
            label: "?",
            leftColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            rightColor: blackAndWhite ? Theme.of(context).textTheme.bodyText1!.color! : Colors.blue,
            labelStyle: labelStyle,
            subtitleStyle: subTitleStyle,
            subtitle: showSubTitle ? getBadgeTitle(competitionCode!) : null);
    }
  }

  static String getBadgeTitle(String competitionCode) {
    String gameType = competitionCode.substring(competitionCode.length - 1);
    switch (int.parse(gameType)) {
      case 1:
        return "4x4 masculin";
      case 2:
        return "6x6 masculin";
      case 3:
      case 4:
        return "4x4 mixte";
      case 5:
        return "6x6 mixte";
      case 6:
        return "4x4 féminin";
      case 7:
        return "6x6 féminin";
      default:
        return "inconnu";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deltaSize * 90,
      height: deltaSize * 40,
      child: CustomPaint(painter: _drawCompetitionBadge(context)),
    );
  }
}

class _CompetitionBadgePainter extends CustomPainter {
  final BuildContext context;
  final String label;
  final Color leftColor;
  final Color rightColor;
  final TextStyle? labelStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;

  _CompetitionBadgePainter(
      {required this.context,
      required this.label,
      required this.leftColor,
      required this.subtitle,
      required this.labelStyle,
      required this.subtitleStyle,
      Color? rightColor})
      : this.rightColor = rightColor ?? leftColor;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height, demiHeight = height / 2;

    Paint left = new Paint()
      ..color = leftColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint leftSquare = new Paint()
      ..color = leftColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint right = new Paint()
      ..color = rightColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint rightSquare = new Paint()
      ..color = rightColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..strokeWidth = height;

    canvas.drawLine(Offset(demiHeight, demiHeight), Offset(demiHeight, demiHeight), left);
    canvas.drawLine(Offset(demiHeight, demiHeight), Offset(height, demiHeight), leftSquare);
    canvas.drawLine(Offset(width - demiHeight, demiHeight), Offset(width - demiHeight, demiHeight), right);
    canvas.drawLine(Offset(width - demiHeight, demiHeight), Offset(width - height, demiHeight), rightSquare);

    TextStyle textStyle = labelStyle ?? TextStyle(color: Colors.white, fontSize: 18);
    TextSpan span = TextSpan(text: label, style: textStyle);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(demiHeight - (tp.width / 2) + 1 * tp.width / 4, demiHeight - tp.height / 2));
    tp.paint(canvas, Offset(width - demiHeight - tp.width / 2 - tp.width / 4, demiHeight - tp.height / 2));

    if (subtitle != null) {
      TextSpan subtitleSpan = TextSpan(text: subtitle, style: subtitleStyle);
      TextPainter subtitleTp =
          TextPainter(text: subtitleSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      subtitleTp.layout();
      subtitleTp.paint(canvas, Offset(size.width / 2 - subtitleTp.width / 2, height + subtitleTp.height / 4));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
