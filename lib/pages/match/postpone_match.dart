import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/animated_button.dart';
import 'package:v34/commons/ensure_visible_when_focused.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/match/match_info.dart';
import 'package:validators/validators.dart';

class PostPoneMatch extends StatefulWidget {
  final Team hostTeam;
  final Team visitorTeam;
  final Club hostClub;
  final Club visitorClub;
  final DateTime matchDate;

  const PostPoneMatch({
    Key? key,
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

  static const String BOTH_TEAMS = "both";

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _commentsController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _commentsFocus;

  String? _initiatorTeamCode;
  Team? _userTeam;

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
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Paragraph(title: "Report"),
              ),
              ..._buildReport(context),
              Paragraph(title: "Informations"),
              ..._buildInformation(context),
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButton(
                      onPressed: ((_formKey.currentState?.validate() ?? false) &&
                              _userTeam != null &&
                              _initiatorTeamCode != null)
                          ? () => _sendReport(
                                context,
                                name: _nameController.text,
                                senderEmail: _emailController.text,
                                hostTeam: widget.hostTeam,
                                visitorTeam: widget.visitorTeam,
                                userTeam: _userTeam!,
                                plannedDate: widget.matchDate,
                                comments: _commentsController.text,
                              )
                          : null,
                      text: "Envoyer",
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
            focusNode: _nameFocus,
            controller: _nameController,
            autofocus: true,
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
            controller: _emailController,
            focusNode: _emailFocus,
            autofocus: true,
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
          groupValue: _userTeam,
          value: widget.hostTeam,
          onChanged: (_) => setState(() => _userTeam = widget.hostTeam),
          title: Text(widget.hostTeam.name!, style: Theme.of(context).textTheme.bodyText2),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 28, right: 28),
        child: RadioListTile<Team>(
          groupValue: _userTeam,
          value: widget.visitorTeam,
          onChanged: (_) => setState(() => _userTeam = widget.visitorTeam),
          title: Text(widget.visitorTeam.name!, style: Theme.of(context).textTheme.bodyText2),
        ),
      ),
      if (_userTeam == null)
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
              groupValue: _initiatorTeamCode,
              onChanged: (_) => setState(() => _initiatorTeamCode = widget.hostTeam.code),
            ),
            RadioListTile<String>(
              dense: true,
              title: Text(widget.visitorTeam.name!, style: Theme.of(context).textTheme.bodyText2),
              value: widget.visitorTeam.code!,
              groupValue: _initiatorTeamCode,
              onChanged: (_) => setState(() => _initiatorTeamCode = widget.visitorTeam.code),
            ),
            RadioListTile<String>(
              dense: true,
              title: Text("Les 2 équipes", style: Theme.of(context).textTheme.bodyText2),
              value: BOTH_TEAMS,
              groupValue: _initiatorTeamCode,
              onChanged: (_) => setState(() => _initiatorTeamCode = BOTH_TEAMS),
            ),
          ],
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
    ];
  }

  _sendReport(
    BuildContext context, {
    required String name,
    required String senderEmail,
    required Team hostTeam,
    required Team visitorTeam,
    required Team userTeam,
    required DateTime plannedDate,
    required String comments,
  }) async {
    final DateFormat dateFormat = DateFormat("EEEE dd MMMM à HH:mm", "FR");

    final MailOptions mailOptions = MailOptions(
      body: '''
      <b><u>Notification de report envoyée par $name ($senderEmail) de l'équipe ${userTeam.name}</u></b><br/>
      <br/>
      Initialement prévu le ${dateFormat.format(plannedDate)}, le match ${hostTeam.name} reçoit ${visitorTeam.name} a été reporté.
      <br/><br/>
      Report demandé par : ${_initiatorTeamCode == BOTH_TEAMS ? "Les 2 équipes" : _initiatorTeamCode == hostTeam.code ? hostTeam.name : visitorTeam.name}
      <br><br/>
      ${comments.isNotEmpty ? "<b>Commentaires :</b><br/> $comments" : ""}
      ''',
      subject:
          "[Volley34 : Résultats et Classements] - Notification de report du Match ${hostTeam.name} reçoit ${visitorTeam.name}",
      recipients: [
        senderEmail,
        //"resultat@volley34.fr",
      ],
      isHTML: true,
      ccRecipients: [senderEmail],
    );

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    String platformResponse;
    switch (response) {
      case MailerResponse.saved:
        platformResponse = "L'e-mail a été sauvegardé en brouillon";
        break;
      case MailerResponse.sent:
        platformResponse = "L'e-mail a été envoyé";
        break;
      case MailerResponse.cancelled:
        platformResponse = "L'e-mail a été annulé. Merci";
        break;
      case MailerResponse.android:
        platformResponse = "L'e-mail a été envoyé. Merci";
        break;
      default:
        platformResponse = "Nous avons reçu une réponse inconnue de votre client d'e-mail !";
        break;
    }
    Navigator.of(context).pop();
    final snackBar = SnackBar(content: Text(platformResponse));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return Future.value();
  }
}
