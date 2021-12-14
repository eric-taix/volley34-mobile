import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/pages/favorite/favorite_wizard.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text("Profil")),
      body: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, state) => state is PreferencesUpdatedState
            ? ListView(
                children: [
                  SizedBox(height: 48),
                  ListTile(
                    leading: state.favoriteClub != null && state.favoriteClub!.logoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: state.favoriteClub!.logoUrl!,
                            width: 40,
                          )
                        : SvgPicture.asset("assets/shield.svg",
                            width: 20, color: Theme.of(context).textTheme.bodyText2!.color),
                    title: Text("${state.favoriteTeam!.name} - ${state.favoriteClub!.name}",
                        style: Theme.of(context).textTheme.bodyText2),
                    subtitle: Text("Choisissez votre équipe", style: Theme.of(context).textTheme.bodyText1),
                    onTap: () => showGeneralDialog(
                      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      context: context,
                      pageBuilder:
                          (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                              SelectFavoriteTeam(),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                  )
                ],
              )
            : SizedBox(),
      ),
    );
  }
}
