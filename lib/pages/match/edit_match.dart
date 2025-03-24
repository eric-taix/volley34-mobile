import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:v34/commons/animated_button.dart';
import 'package:v34/commons/ensure_visible_when_focused.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/sended_match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/match/match_info.dart';
import 'package:v34/repositories/repository.dart';
import 'package:validators/validators.dart';

class EditMatch extends StatefulWidget {
  final String matchCode;
  final Team hostTeam;
  final Team visitorTeam;
  final Club hostClub;
  final Club visitorClub;
  final DateTime matchDate;
  const EditMatch({
    Key? key,
    required this.matchCode,
    required this.hostTeam,
    required this.visitorTeam,
    required this.hostClub,
    required this.visitorClub,
    required this.matchDate,
  }) : super(key: key);

  @override
  State<EditMatch> createState() => _EditMatchState();
}

class _EditMatchState extends State<EditMatch> {
  final _formKey = GlobalKey<FormState>();
  String? _scoreSheetPhotoPath;
  bool _showPhotoFullScreen = false;

  static const bool PHOTO_REQUIRED = false;

  late final List<TextEditingController> _setControllers;
  late final List<FocusNode> _focusNodes;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _commentsController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _commentsFocus;

  Team? _userTeam;

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
    _nameController.dispose();
    _emailController.dispose();
    _commentsController.dispose();
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _setControllers.forEach((setController) => setController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Saisie d'un résultat"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
      ),
      body: Stack(
        children: [
          Form(
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
                    showMatchDate: true,
                    showTeamLink: false,
                  ),
                  Paragraph(title: "Informations"),
                  ..._buildInformation(context),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Paragraph(title: "Résultat"),
                  ),
                  ...List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text("Set n° ",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context).canvasColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 8),
                            child: SizedBox(
                              width: 78,
                              height: 40,
                              child: _createSetField(context, index, true),
                            ),
                          ),
                          Text("/",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 78,
                              height: 40,
                              child: _createSetField(context, index, false),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  _buildCurrentResult(context),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 28, right: 28),
                    child: EnsureVisibleWhenFocused(
                      focusNode: _commentsFocus,
                      child: TextFormField(
                        controller: _commentsController,
                        focusNode: _commentsFocus,
                        cursorWidth: 2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 18),
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(labelText: "Commentaires"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Paragraph(title: "Feuille de match"),
                  ),
                  _buildScoreSheetPhoto(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 58.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (_formKey.currentState?.validate() ??
                                      false) &&
                                  ((PHOTO_REQUIRED &&
                                          _scoreSheetPhotoPath != null) ||
                                      !PHOTO_REQUIRED) &&
                                  _userTeam != null &&
                                  _setControllers[0].text.isNotEmpty &&
                                  _setControllers[1].text.isNotEmpty
                              ? () => _confirmResult(
                                    context,
                                    senderName: _nameController.text,
                                    senderEmail: _emailController.text,
                                    hostTeamName: widget.hostTeam.name!,
                                    visitorTeamName: widget.visitorTeam.name!,
                                    scoreSheetPath: _scoreSheetPhotoPath,
                                    senderTeam: _userTeam!,
                                    comment: _commentsController.text,
                                  )
                              : null,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 38.0),
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
          if (_showPhotoFullScreen) _buildFullScreenImage(context),
        ],
      ),
    );
  }

  _buildFullScreenImage(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Center(
                child: Image.file(
                  File(_scoreSheetPhotoPath!),
                  fit: BoxFit.cover,
                  height: 400,
                  width: 400,
                ),
              ),
            ),
            TextButton(
              child: Text("Fermer"),
              onPressed: () => setState(
                () {
                  _showPhotoFullScreen = false;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _confirmResult(
    BuildContext parentContext, {
    required String senderName,
    required String senderEmail,
    required String hostTeamName,
    required String visitorTeamName,
    required String? scoreSheetPath,
    required Team senderTeam,
    required String comment,
  }) async {
    var pointResults = _setControllers
        .where((setController) => setController.text.isNotEmpty)
        .map((setController) => setController.text)
        .toList()
        .asMap()
        .entries
        .map((entry) =>
            entry.key % 2 == 0 ? " , ${entry.value}" : "-${entry.value}")
        .join()
        .substring(2);

    return showDialog(
      barrierDismissible: false,
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Confirmation",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 18),
              Text("$senderName, confirmez-vous l'envoi du résultat suivant ?",
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 18),
              RichText(
                text: TextSpan(
                    text: "",
                    children: [
                      TextSpan(
                          text: hostTeamName,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(text: " a reçu "),
                      TextSpan(
                          text: visitorTeamName,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: " sur le score final de ",
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(
                          text: pointResults,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(height: 18),
              RichText(
                text: TextSpan(
                    text: "Total des sets : ",
                    children: [
                      TextSpan(
                          text: "$_hostSets - $_visitorSets",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              RichText(
                text: TextSpan(
                    text: "Total des points : ",
                    children: [
                      TextSpan(
                          text: "$_hostTotalPoints - $_visitorTotalPoints",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(height: 18),
              Text(
                  _scoreSheetPhotoPath != null
                      ? "* Une photo de la feuille de match a été jointe"
                      : "* Aucune photo de la feuille de match n'a été jointe",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontStyle: FontStyle.italic)),
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
                try {
                  var sendStatus = await _sendResult(
                    parentContext,
                    comment: comment,
                    senderName: senderName,
                    senderEmail: senderEmail,
                    senderTeamName: senderTeam.name!,
                    scoreSheetPath: scoreSheetPath,
                  );
                  Navigator.of(context).pop();
                  if (sendStatus.status.name.startsWith("OK")) {
                    BlocProvider.of<MessageCubit>(parentContext).showSnack(
                        text:
                            "Merci ! Le résultat suivant a été pris en compte :\n\n${sendStatus.comment}",
                        canClose: true,
                        duration: Duration(seconds: 20));
                    Navigator.of(parentContext).pop();
                  } else {
                    BlocProvider.of<MessageCubit>(parentContext).showMessage(
                      message:
                          "Le résultat n'a pu être pris en compte pour la raison suivante:\n\n${sendStatus.comment}",
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

  Future<SendedMatchResult> _sendResult(
    BuildContext context, {
    required String comment,
    required String senderName,
    required String senderEmail,
    required String senderTeamName,
    required String? scoreSheetPath,
  }) async {
    var sets =
        _setControllers.map((setController) => setController.text).toList();

    Repository repository = RepositoryProvider.of<Repository>(context);

    String? imageBase64Encoded;
    if (_scoreSheetPhotoPath != null) {
      final bytes = await File(_scoreSheetPhotoPath!).readAsBytes();

      var compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 1920,
        minWidth: 1080,
        quality: 75,
      );
      imageBase64Encoded = base64.encode(compressedBytes);
    }

    var sendStatus = await repository.sendResult(
      matchCode: widget.matchCode,
      sets: sets,
      comment: comment,
      senderName: senderName,
      senderEmail: senderEmail,
      senderTeamName: senderTeamName,
      matchSheetFilename:
          scoreSheetPath != null ? basename(scoreSheetPath) : null,
      matchSheetFileBase64: imageBase64Encoded,
    );
    return sendStatus;
  }

  Widget _buildScoreSheetPhoto(BuildContext context) {
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
                        ? Theme.of(context)
                            .inputDecorationTheme
                            .errorBorder!
                            .borderSide
                            .color
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
                    width: _scoreSheetPhotoPath == null
                        ? Theme.of(context)
                            .inputDecorationTheme
                            .errorBorder!
                            .borderSide
                            .width
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .width,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: _scoreSheetPhotoPath != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(_scoreSheetPhotoPath!),
                              fit: BoxFit.cover,
                              height: 400,
                              width: 400,
                            ),
                          ),
                          if (_scoreSheetPhotoPath != null)
                            Positioned(
                              left: -5,
                              top: -5,
                              child: IconButton(
                                icon: Icon(Icons.zoom_out_map_rounded),
                                onPressed: () => setState(
                                  () {
                                    _showPhotoFullScreen = true;
                                  },
                                ),
                              ),
                            )
                        ],
                      )
                    : Center(
                        child: Text("Aucune photo",
                            style: Theme.of(context).textTheme.bodyLarge)),
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
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(
                      () {
                        _scoreSheetPhotoPath = photo.path;
                      },
                    );
                  }
                },
              ),
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 18),
                icon: Icon(Icons.photo_library_outlined),
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.gallery);
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
    Color? scoreColor = Theme.of(context).textTheme.bodyMedium!.color;
    String resultString = "est à égalité avec";

    if (_hostSets > _visitorSets ||
        (_hostSets == _visitorSets && _hostTotalPoints > _visitorTotalPoints)) {
      scoreColor = Colors.green;
      resultString = "gagne contre";
    } else if (_hostSets < _visitorSets ||
        (_hostSets == _visitorSets && _hostTotalPoints < _visitorTotalPoints)) {
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold, color: scoreColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    resultString,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  "${widget.visitorTeam.name}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold, color: null),
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
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                    TextSpan(
                      text: "$_visitorSets",
                      style: TextStyle(
                        fontSize: 38.0,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
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
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                    TextSpan(
                      text: "$_visitorTotalPoints pts",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
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

  TextFormField _createSetField(BuildContext context, int index, bool hostSet) {
    int fieldIndex = index * 2 + (hostSet ? 0 : 1);

    int hostSetWon = 0;
    int visitorSetWon = 0;

    if (index > 0) {
      for (int set = 0; set < index; set++) {
        int hostPoints = 0;
        int visitorPoints = 0;
        try {
          hostPoints = int.parse(_setControllers[set * 2].text);
        } catch (_) {}
        try {
          visitorPoints = int.parse(_setControllers[set * 2 + 1].text);
        } catch (_) {}
        if (_isSetWon(set, hostPoints, visitorPoints)) {
          if (hostPoints > visitorPoints) {
            hostSetWon++;
          } else {
            visitorSetWon++;
          }
        }
      }
    }
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium,
      controller: _setControllers[fieldIndex],
      focusNode: _focusNodes[fieldIndex],
      textAlign: TextAlign.center,
      enableInteractiveSelection: false,
      enabled: hostSetWon < 3 && visitorSetWon < 3,
      keyboardType: TextInputType.number,
      onEditingComplete: () {
        _focusNodes[fieldIndex].unfocus();
        if (fieldIndex < _focusNodes.length - 1) {
          _focusNodes[fieldIndex + 1].requestFocus();
        }
        _computeTotal();
      },
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        try {
          if ((value == null || value.isEmpty) && fieldIndex > 1) {
            return null;
          }
          int.parse(value ?? "");
          return null;
        } catch (e) {
          return "";
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2)
      ],
    );
  }

  void _computeTotal() {
    _hostSets = 0;
    _visitorSets = 0;
    _hostTotalPoints = 0;
    _visitorTotalPoints = 0;
    for (int index = 0; index < 5; index++) {
      if (_hostSets >= 3 || _visitorSets >= 3) {
        _setControllers[index * 2].text = "";
        _setControllers[index * 2 + 1].text = "";
      } else {
        try {
          int hostPoints = int.parse(_setControllers[index * 2].text);
          int visitorPoints = int.parse(_setControllers[index * 2 + 1].text);
          _hostTotalPoints += hostPoints;
          _visitorTotalPoints += visitorPoints;
          if (_isSetWon(index, hostPoints, visitorPoints)) {
            if (hostPoints > visitorPoints) {
              _hostSets++;
            } else {
              _visitorSets++;
            }
          }
        } catch (e) {}
      }
    }
    setState(() {});
  }

  bool _isSetWon(int setIndex, int points, int otherPoints) {
    return ((points - otherPoints).abs() >= 2) &&
        (points >= 25 ||
            otherPoints >= 25 ||
            (setIndex == 4 && (points >= 15 || otherPoints >= 15)));
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
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
            cursorWidth: 2,
            enableSuggestions: true,
            autofillHints: [
              AutofillHints.name,
            ],
            decoration: InputDecoration(
              labelText: "Votre nom",
              errorStyle: TextStyle(fontSize: 14),
            ),
            autovalidateMode: AutovalidateMode.always,
            onEditingComplete: () {
              _nameFocus.unfocus();
              _emailFocus.requestFocus();
            },
            validator: (value) {
              return value != null && value.isNotEmpty
                  ? null
                  : "Le nom est obligatoire";
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
            autovalidateMode: AutovalidateMode.always,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
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
              return value != null && isEmail(value)
                  ? null
                  : "L'adresse email n'est pas valide";
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 38, right: 28),
        child:
            Text("Votre équipe", style: Theme.of(context).textTheme.bodyLarge),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 28, right: 28),
        child: RadioListTile<Team>(
          dense: true,
          groupValue: _userTeam,
          value: widget.hostTeam,
          onChanged: (_) => setState(() => _userTeam = widget.hostTeam),
          title: Text(widget.hostTeam.name!,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 28, right: 28),
        child: RadioListTile<Team>(
          dense: true,
          groupValue: _userTeam,
          value: widget.visitorTeam,
          onChanged: (_) => setState(() => _userTeam = widget.visitorTeam),
          title: Text(widget.visitorTeam.name!,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
      if (_userTeam == null)
        Padding(
          padding: const EdgeInsets.only(left: 38.0, top: 8),
          child: Text(
            "La sélection de votre équipe est obligatoire",
            style: Theme.of(context).inputDecorationTheme.errorStyle,
          ),
        )
    ];
  }
}
