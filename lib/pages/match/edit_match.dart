import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v34/commons/animated_button.dart';
import 'package:v34/commons/ensure_visible_when_focused.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:validators/validators.dart';

class EditMatch extends StatefulWidget {
  final Team hostTeam;
  final Team visitorTeam;
  final Club hostClub;
  final Club visitorClub;

  const EditMatch(
      {Key? key, required this.hostTeam, required this.visitorTeam, required this.hostClub, required this.visitorClub})
      : super(key: key);

  @override
  State<EditMatch> createState() => _EditMatchState();
}

class _EditMatchState extends State<EditMatch> {
  final _formKey = GlobalKey<FormState>();
  String? _scoreSheetPhotoPath;
  static const bool PHOTO_REQUIRED = false;

  late final List<TextEditingController> _setControllers;
  late final List<FocusNode> _focusNodes;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _commentsController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _commentsFocus;

  int _hostSets = 0;
  int _visitorSets = 0;
  int _hostTotalPoints = 0;
  int _visitorTotalPoints = 0;

  @override
  void initState() {
    super.initState();
    _setControllers = List.generate(5 * 2, (index) => TextEditingController());
    _focusNodes = List.generate(
      5 * 2,
      (index) {
        var node = FocusNode();
        node.addListener(() {
          _computeTotal();
        });
        return node;
      },
    );
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _commentsController = TextEditingController();
    _nameFocus = FocusNode()..addListener(() => _computeTotal());
    _emailFocus = FocusNode()..addListener(() => _computeTotal());
    _commentsFocus = FocusNode()..addListener(() => _computeTotal());
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _commentsFocus.dispose();
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _setControllers.forEach((setController) => setController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Saisie d'un résultat"),
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
              SizedBox(height: 38),
              _buildOpponent(context, widget.hostTeam, widget.hostClub),
              Padding(
                padding: const EdgeInsets.only(left: 88.0),
                child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
              ),
              _buildOpponent(context, widget.visitorTeam, widget.visitorClub),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Paragraph(title: "Résultat"),
              ),
              ...List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18, top: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text("Set n° ", style: Theme.of(context).textTheme.bodyText1),
                      ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 8),
                        child: SizedBox(
                          width: 78,
                          height: 40,
                          child: _createSetField(index, true),
                        ),
                      ),
                      Text("/",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 78,
                          height: 40,
                          child: _createSetField(index, false),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              _buildCurrentResult(context),
              Paragraph(title: "Informations"),
              ..._buildInformation(context),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Paragraph(title: "Feuille de match"),
              ),
              _buildScoreSheetPhoto(),
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButton(
                      onPressed: (_formKey.currentState?.validate() ?? false) &&
                              ((PHOTO_REQUIRED && _scoreSheetPhotoPath != null) || !PHOTO_REQUIRED)
                          ? () => _sendResult(
                                context,
                                name: _nameController.text,
                                senderEmail: _emailController.text,
                                hostTeamName: widget.hostTeam.name!,
                                visitorTeamName: widget.visitorTeam.name!,
                                scoreSheetPath: _scoreSheetPhotoPath,
                              )
                          : null,
                      text: "ENVOYER",
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

  _sendResult(
    BuildContext context, {
    required String name,
    required String senderEmail,
    required String hostTeamName,
    required String visitorTeamName,
    required String? scoreSheetPath,
  }) async {
    var pointResults = _setControllers
        .where((setController) => setController.text.isNotEmpty)
        .map((setController) => setController.text)
        .toList()
        .asMap()
        .entries
        .map((entry) => entry.key % 2 == 0 ? " , ${entry.value} " : " - ${entry.value} ")
        .join()
        .substring(2);

    final MailOptions mailOptions = MailOptions(
        body: '''
      <strong><u>Envoi de résultats de $name ($senderEmail) pour l'équipe $hostTeamName</u></strong><br/>
      <br/>
      $hostTeamName reçoit $visitorTeamName :<br/>
      Détail des points : $pointResults<br/>
      Total des sets: $_hostSets - $_visitorSets<br/>
      Total des points: $_hostTotalPoints - $_visitorTotalPoints<br/>
      <br>
      ''',
        subject: "Résultats Volley 34",
        recipients: [
          senderEmail,
          //"resultat@volley34.fr",
        ],
        isHTML: true,
        ccRecipients: [senderEmail],
        attachments: scoreSheetPath != null ? [scoreSheetPath] : []);

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    String platformResponse;
    switch (response) {
      case MailerResponse.saved:

        /// ios only
        platformResponse = 'mail was saved to draft';
        break;
      case MailerResponse.sent:

        /// ios only
        platformResponse = 'mail was sent';
        break;
      case MailerResponse.cancelled:

        /// ios only
        platformResponse = 'mail was cancelled';
        break;
      case MailerResponse.android:
        platformResponse = 'intent was successful';
        break;
      default:
        platformResponse = 'unknown';
        break;
    }
    final snackBar = SnackBar(content: Text("Le résultat a été envoyé. Merci."));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar).closed..then((_) => Navigator.of(context).pop());
  }

  Widget _buildScoreSheetPhoto() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 240,
              width: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: PHOTO_REQUIRED && _scoreSheetPhotoPath == null
                        ? Theme.of(context).inputDecorationTheme.errorBorder!.borderSide.color
                        : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                    width: _scoreSheetPhotoPath == null
                        ? Theme.of(context).inputDecorationTheme.errorBorder!.borderSide.width
                        : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.width,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: _scoreSheetPhotoPath != null
                    ? Image.file(
                        File(_scoreSheetPhotoPath!),
                        fit: BoxFit.contain,
                        height: 200,
                        width: 100,
                      )
                    : Center(child: Text("Aucune photo", style: Theme.of(context).textTheme.bodyText1)),
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 18),
                icon: Icon(Icons.photo_camera_outlined),
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() {
                      _scoreSheetPhotoPath = photo.path;
                    });
                  }
                },
              ),
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 18),
                icon: Icon(Icons.photo_library_outlined),
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    setState(() {
                      _scoreSheetPhotoPath = photo.path;
                    });
                  }
                },
              ),
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 18),
                icon: Icon(Icons.clear),
                onPressed: _scoreSheetPhotoPath != null
                    ? () async {
                        setState(() {
                          _scoreSheetPhotoPath = null;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentResult(BuildContext context) {
    Color? scoreColor = Theme.of(context).textTheme.bodyText2!.color;
    String resultString = "est à égalité avec";

    if (_hostSets > _visitorSets || (_hostSets == _visitorSets && _hostTotalPoints > _visitorTotalPoints)) {
      scoreColor = Colors.green;
      resultString = "gagne contre";
    } else if (_hostSets < _visitorSets || (_hostSets == _visitorSets && _hostTotalPoints < _visitorTotalPoints)) {
      scoreColor = Colors.red;
      resultString = "perd contre";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 38.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.hostTeam.name}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style:
                      Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, color: scoreColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    resultString,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Text(
                  "${widget.visitorTeam.name}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, color: null),
                ),
              ],
            ),
          ),
          Column(
            children: [
              RichText(
                text: TextSpan(
                  text: "$_hostSets",
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                  children: [
                    TextSpan(
                        text: " - ",
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        )),
                    TextSpan(
                      text: "$_visitorSets",
                      style: TextStyle(
                        fontSize: 38.0,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "$_hostTotalPoints pts",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: scoreColor,
                  ),
                  children: [
                    TextSpan(
                        text: "    ",
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        )),
                    TextSpan(
                      text: "$_visitorTotalPoints pts",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextFormField _createSetField(int index, bool hostSet) {
    int fieldIndex = index * 2 + (hostSet ? 0 : 1);
    return TextFormField(
      controller: _setControllers[fieldIndex],
      focusNode: _focusNodes[fieldIndex],
      autofocus: true,
      textAlign: TextAlign.center,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      onEditingComplete: () {
        _focusNodes[fieldIndex].unfocus();
        if (fieldIndex < _focusNodes.length - 1) {
          _focusNodes[fieldIndex + 1].requestFocus();
        } else {
          _nameFocus.requestFocus();
        }
        _computeTotal();
      },
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        try {
          if (value == null || value.isEmpty) {
            return null;
          }
          int.parse(value);
          return null;
        } catch (e) {
          return "";
        }
      },
    );
  }

  void _computeTotal() {
    _hostSets = 0;
    _visitorSets = 0;
    _hostTotalPoints = 0;
    _visitorTotalPoints = 0;
    for (int index = 0; index < 5; index++) {
      try {
        int hostPoints = int.parse(_setControllers[index * 2].text);
        int visitorPoints = int.parse(_setControllers[index * 2 + 1].text);
        _hostTotalPoints += hostPoints;
        _visitorTotalPoints += visitorPoints;
        if (hostPoints >= 25 || visitorPoints >= 25) {
          if (hostPoints >= visitorPoints + 2) {
            _hostSets++;
          } else if (hostPoints + 2 <= visitorPoints) {
            _visitorSets++;
          }
        }
      } catch (e) {}
    }
    setState(() {});
  }

  Widget _buildOpponent(BuildContext context, Team team, Club club) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Hero(
              tag: "hero-logo-${team.code}",
              child: RoundedNetworkImage(40, club.logoUrl ?? ""),
            ),
          ),
          Expanded(
            child: Text(
              team.name!,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
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
}
