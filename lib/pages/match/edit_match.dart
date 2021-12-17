import 'package:flutter/material.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';

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

  late List<TextEditingController> _setControllers;
  late List<FocusNode> _focusNodes;

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
          if (node.hasFocus) {
            _setControllers[index].text = "";
            _computeTotal();
          }
        });
        return node;
      },
    );
  }

  @override
  void dispose() {
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
              SizedBox(height: 50),
            ],
          ),
        ),
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
        }
        _computeTotal();
      },
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        try {
          if ((value == null || value.isEmpty) && _focusNodes[fieldIndex].hasFocus) {
            return null;
          }
          int.parse(value ?? "");
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
        if (_hostSets >= 3 || _visitorSets >= 3) {
          _focusNodes.forEach((focusNode) => focusNode.unfocus());
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
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
          cursorWidth: 2,
          enableSuggestions: true,
          autofillHints: [AutofillHints.name, AutofillHints.familyName],
          decoration: InputDecoration(labelText: "Votre nom"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28, right: 28),
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
          cursorWidth: 2,
          enableSuggestions: true,
          autofillHints: [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: "Votre e-mail"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 28, right: 28),
        child: TextFormField(
          cursorWidth: 2,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(labelText: "Commentaires"),
        ),
      ),
    ];
  }
}
