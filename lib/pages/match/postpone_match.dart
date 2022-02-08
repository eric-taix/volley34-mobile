import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/animated_button.dart';
import 'package:v34/commons/ensure_visible_when_focused.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/match/match_info.dart';
import 'package:v34/repositories/repository.dart';
import 'package:validators/validators.dart';

class PostPoneMatch extends StatefulWidget {
  final Team hostTeam;
  final Team visitorTeam;
  final Club hostClub;
  final Club visitorClub;
  final DateTime matchDate;
  final String matchCode;

  const PostPoneMatch({
    Key? key,
    required this.matchCode,
    required this.hostTeam,
    required this.visitorTeam,
    required this.hostClub,
    required this.visitorClub,
    required this.matchDate,
  }) : super(key: key);

  @override
  _PostPoneMatchState createState() => _PostPoneMatchState();
}

class _PostPoneMatchState extends State<PostPoneMatch> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _commentsController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _commentsFocus;

  String? _applicantTeamCode;
  Team? _senderTeam;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _commentsController = TextEditingController();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _commentsFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _commentsFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Report d'un match"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: FocusScope(
          child: ListView(
            children: [
              MatchInfo(
                hostTeam: widget.hostTeam,
                visitorTeam: widget.visitorTeam,
                hostClub: widget.hostClub,
                visitorClub: widget.visitorClub,
                date: widget.matchDate,
                showTeamLink: false,
                showMatchDate: true,
              ),
              Paragraph(title: "Informations"),
              ..._buildInformation(context),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Paragraph(title: "Report"),
              ),
              ..._buildReport(context),
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: ((_formKey.currentState?.validate() ?? false) &&
                              _senderTeam != null &&
                              _applicantTeamCode != null)
                          ? () => _confirmPostpone(
                                context,
                                senderName: _nameController.text,
                                senderEmail: _emailController.text,
                                senderTeamName: _senderTeam!.name!,
                                hostTeam: widget.hostTeam,
                                visitorTeam: widget.visitorTeam,
                                comment: _commentsController.text,
                                applicationTeamCode: _applicantTeamCode!,
                                matchCode: widget.matchCode,
                              )
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                        child: Text("Envoyer"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInformation(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 38.0, left: 28, right: 28),
        child: EnsureVisibleWhenFocused(
          focusNode: _nameFocus,
          child: TextFormField(
            autofocus: true,
            focusNode: _nameFocus,
            controller: _nameController,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
            cursorWidth: 2,
            enableSuggestions: true,
            autofillHints: [
              AutofillHints.name,
            ],
            decoration: InputDecoration(
              labelText: "Votre nom",
              errorStyle: TextStyle(height: 1.1, fontSize: 14),
            ),
            autovalidateMode: AutovalidateMode.always,
            onEditingComplete: () {
              _nameFocus.unfocus();
              _emailFocus.requestFocus();
            },
            validator: (value) {
              return value != null && value.isNotEmpty ? null : "Le nom est obligatoire";
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28, right: 28),
        child: EnsureVisibleWhenFocused(
          focusNode: _emailFocus,
          child: TextFormField(
            autofocus: true,
            controller: _emailController,
            focusNode: _emailFocus,
            autovalidateMode: AutovalidateMode.always,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
            cursorWidth: 2,
            enableSuggestions: true,
            autofillHints: [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Votre e-mail",
              errorStyle: TextStyle(height: 1.1, fontSize: 14),
            ),
            onEditingComplete: () {
              _emailFocus.unfocus();
            },
            validator: (value) {
              return value != null && isEmail(value) ? null : "L'adresse email n'est pas valide";
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 38, right: 28),
        child: Text("Votre équipe", style: Theme.of(context).textTheme.bodyText1),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 28, right: 28),
        child: RadioListTile<Team>(
          groupValue: _senderTeam,
          value: widget.hostTeam,
          onChanged: (_) => setState(() => _senderTeam = widget.hostTeam),
          title: Text(widget.hostTeam.name!, style: Theme.of(context).textTheme.bodyText2),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 28, right: 28),
        child: RadioListTile<Team>(
          groupValue: _senderTeam,
          value: widget.visitorTeam,
          onChanged: (_) => setState(() => _senderTeam = widget.visitorTeam),
          title: Text(widget.visitorTeam.name!, style: Theme.of(context).textTheme.bodyText2),
        ),
      ),
      if (_senderTeam == null)
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: Text(
            "La sélection de votre équipe est obligatoire",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Theme.of(context).inputDecorationTheme.errorStyle!.color!),
          ),
        )
    ];
  }

  List<Widget> _buildReport(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 28.0, top: 18.0),
        child: Text("Le report a été demandé par", style: Theme.of(context).textTheme.bodyText1),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          children: [
            RadioListTile<String>(
              dense: true,
              title: Text(widget.hostTeam.name!, style: Theme.of(context).textTheme.bodyText2),
              value: widget.hostTeam.code!,
              groupValue: _applicantTeamCode,
              onChanged: (_) => setState(() => _applicantTeamCode = widget.hostTeam.code),
            ),
            RadioListTile<String>(
              dense: true,
              title: Text(widget.visitorTeam.name!, style: Theme.of(context).textTheme.bodyText2),
              value: widget.visitorTeam.code!,
              groupValue: _applicantTeamCode,
              onChanged: (_) => setState(() => _applicantTeamCode = widget.visitorTeam.code),
            ),
          ],
        ),
      ),
      if (_applicantTeamCode == null)
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            "L'équipe qui a fait la demande est obligatoire",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Theme.of(context).inputDecorationTheme.errorStyle!.color!),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28, right: 28),
        child: EnsureVisibleWhenFocused(
          focusNode: _commentsFocus,
          child: TextFormField(
            controller: _commentsController,
            focusNode: _commentsFocus,
            autofocus: true,
            cursorWidth: 2,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
            autovalidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(labelText: "Commentaires"),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 28.0, top: 8, right: 28),
        child: Text(
          "Merci d'indiquer la nouvelle date ainsi que le gymnase où se déroulera le match.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic),
        ),
      )
    ];
  }

  _confirmPostpone(
    BuildContext parentContext, {
    required String matchCode,
    required String senderName,
    required String senderTeamName,
    required String senderEmail,
    required Team hostTeam,
    required Team visitorTeam,
    required String comment,
    required String applicationTeamCode,
  }) async {
    return showDialog(
      barrierDismissible: false,
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).textTheme.headline5!.color,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Confirmation", style: Theme.of(context).textTheme.headline5),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 18),
              Text("$senderName, confirmez-vous le report du match suivant ?",
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 18),
              RichText(
                text: TextSpan(
                    text: "",
                    children: [
                      TextSpan(text: hostTeam.name, style: Theme.of(context).textTheme.bodyText2),
                      TextSpan(text: " reçoit "),
                      TextSpan(text: visitorTeam.name, style: Theme.of(context).textTheme.bodyText2),
                    ],
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              SizedBox(height: 18),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Annuler"),
            ),
            AnimatedButton(
              text: "Confirmer",
              width: 100,
              onPressed: () async {
                Repository repository = RepositoryProvider.of<Repository>(context);
                try {
                  var sendStatus = await repository.postponeMatch(
                    matchCode: matchCode,
                    senderName: senderName,
                    senderTeamName: senderTeamName,
                    senderEmail: senderEmail,
                    comment: comment,
                    applicantTeamCode: applicationTeamCode,
                    reportDate: null,
                    gymnasiumCode: null,
                  );

                  Navigator.of(context).pop();
                  if (sendStatus.startsWith("OK")) {
                    BlocProvider.of<MessageCubit>(parentContext).showSnack(
                        text: "Merci ! Le report a été pris en compte",
                        canClose: true,
                        duration: Duration(seconds: 20));
                    Navigator.of(parentContext).pop();
                  } else {
                    BlocProvider.of<MessageCubit>(parentContext).showMessage(
                      message: "Le report n'a pu être pris en compte. Merci d'envoyer un mail à resultats@volley34.fr",
                    );
                  }
                  return sendStatus;
                } on Exception {
                  return Future.value();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
